//
//  DawagaLoadingViewController.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/13.
//

import UIKit
import ReSwift
import CoreLocation

class DawagaLoadingViewController: UIViewController {

    // MARK: - UI Initialization
    
    private let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        return shapeLayer
    }()
    
    private lazy var seperator: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .ultraLightGray
        iv.layer.cornerRadius = 1.5
        return iv
    }()
    
    private let fishImageView = UIImageView(image: UIImage(named: "Fish"))
    
    
    // MARK: - Property
    
    private weak var displayLink: CADisplayLink?
    private var startTime: CFTimeInterval = 0
    
    private var isFishSetup: Bool = false
    private let locationNotificationScheduler = LocationNotificationScheduler()
    
    private let locationManager = CLLocationManager()
    private lazy var locationEmitter = LocationEmitter(locationManager: locationManager)
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationController()
        appStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appStore.unsubscribe(self)
        self.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        startDisplayLink()
        
        setupNotificationCenter()
        startUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animateFish()
    }

    
    // MARK: - Function
    
    private func startUpdatingLocation() {
        self.locationEmitter.startUpdatingLocation()
    }
    
    private func stopUpdatingLocation() {
        self.locationEmitter.stopUpdatingLocation()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(startAnimateFish), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setIsFishSetupFalse), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    
    // MARK: - Wave Animation
    
    private func startDisplayLink() {
        startTime = CACurrentMediaTime()
        self.displayLink?.invalidate()
        let displayLink = CADisplayLink(target: self, selector:#selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
    }
    
    @objc private func handleDisplayLink(_ displayLink: CADisplayLink) {
        let elapsed = CACurrentMediaTime() - startTime
        shapeLayer.path = wave(at: elapsed).cgPath
    }
    
    private func wave(at elapsed: Double) -> UIBezierPath {
        let elapsed = CGFloat(elapsed)
        let centerY = view.bounds.midY
        let amplitude = 40 - abs(elapsed.remainder(dividingBy: 3)) * 40
        
        func f(_ x: CGFloat) -> CGFloat {
            return sin((x + elapsed) * 1.5 * .pi) * amplitude + centerY
        }
        
        let path = UIBezierPath()
        let steps = Int(view.bounds.width / 10)
        
        path.move(to: CGPoint(x: 0, y: f(0)))
        for step in 1 ... steps {
            let x = CGFloat(step) / CGFloat(steps)
            path.addLine(to: CGPoint(x: x * view.bounds.width, y: f(x)))
        }
        
        return path
    }

    
    // MARK: - Fish Animation
    
    @objc func startAnimateFish(){
        self.animateFish()
    }
    
    private func animateFish() {
        if self.isFishSetup { return }
        self.setIsFishSetupTrue()
        
        let duration = 1.5

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.view.frame.midY))
        path.addQuadCurve(to: CGPoint(x: self.view.frame.maxX, y: self.view.frame.midY), controlPoint: CGPoint(x: self.view.frame.midX, y: 0))

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath

        animation.duration = duration
        animation.repeatCount = .infinity
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = -Double.pi/4
        rotationAnimation.toValue = Double.pi/4
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = .infinity

        fishImageView.layer.add(animation, forKey: "position")
        fishImageView.layer.add(rotationAnimation, forKey: nil)
        
        fishImageView.center = CGPoint(x: 0, y: self.view.frame.midY)
    }
    
    @objc func setIsFishSetupFalse() {
        self.isFishSetup = false
    }
    @objc func setIsFishSetupTrue() {
        self.isFishSetup = true
    }
}


// MARK: - Redux

extension DawagaLoadingViewController: StoreSubscriber {
    
    func newState(state: AppState) {

        if state.dawagaLoadingState.isNotificationPermissionDenied {
            self.showAlertNotificationPermissionDenied()
        }
        
        if let _ = state.dawagaLoadingState.notificationSchedule {
            self.showAlertNotificationScheduleError()
        }

        switch state.locationEmitterState.authorizationStatus {
        case .denied, .restricted:
            _ = self.navigationController?.popToRootViewController(animated: true)
        case .authorizedAlways, .authorizedWhenInUse:
            break
        case .notDetermined:
            print("not determined")
            return
        @unknown default:
            break
        }
        
        if let location = state.locationEmitterState.location {
                        
            guard let destination = state.dawagaMapState.destination else { return }
            
            let distance = location.distance(from: destination)
            let setDistance: Double = Double(state.dawagaMapState.distanceState)
            
            guard distance <= setDistance else { return }
            
            self.stopUpdatingLocation()
            
            let info = LocationNotificationEntity(notificationId: AppString.NotificationID, locationId: AppString.LocationID, title: AppString.NotificationTitle.localized(), body: AppString.NotificationBody.localized(), data: ["Location":"Arrived"])
            locationNotificationScheduler.request(with: info)
            
            self.showAlertDestinationComplete()
        }
    }
}


// MARK: - UI Setup
extension DawagaLoadingViewController {
    
    private func configureUI() {
        view.backgroundColor = .middleBlue
        
        view.addSubview(seperator)
        seperator.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(3)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        
        view.layer.addSublayer(shapeLayer)
        
        fishImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        fishImageView.backgroundColor = .clear

        self.view.addSubview(fishImageView)
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .white
    }
}


// MARK: - Notification Alert Func

extension DawagaLoadingViewController {
    
    private func showAlertDestinationComplete() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        self.showAlert(title: AppString.NotificationTitle.localized(), message: AppString.NotificationBody.localized(), style: .alert, actions: [action])
    }
    
    private func showAlertNotificationScheduleError() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        self.showAlert(title: AppString.NotificationErrorTitle.localized(), message: AppString.NotificationErrorMessage.localized(), style: .alert, actions: [action])
    }
    
    private func showAlertNotificationPermissionDenied() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        self.showAlert(title: AppString.NotificationPermissionTitle.localized(), message: AppString.NotificationPermissionMessage.localized(), style: .alert, actions: [action])
    }
}
