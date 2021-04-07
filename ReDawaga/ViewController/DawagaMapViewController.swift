//
//  DawagaMapViewController.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import UIKit
import ReSwift
import GoogleMaps

class DawagaMapViewController: UIViewController {

    
    
    enum TransitionType {
        case Search, Quick, BookMark
    }
    
    // MARK: - UI Initialization
    
    private let mapView: GMSMapView = GMSMapView()
    
    private let markImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "pin")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let bottomView: DawagaMapBottomView = {
        let bottomView = DawagaMapBottomView(cornerRadius: 12)
        return bottomView
    }()
    
    
    // MARK: - Property
    
    private var circle = GMSCircle()
                
    private var locationManager: CLLocationManager?
    
    private var currentLocation: CLLocation?
    private var searchedLocation: CLLocation?
    
    let zoomLevel: Float = 15.0
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appStore.subscribe(self)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appStore.unsubscribe(self)
        
        view.backgroundColor = .white        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupBottomView()
        configureLocationManager()
        
        configureType()
    }

    
    // MARK: - Function

    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.requestAlwaysAuthorization()
    }
    
    private func configureType() {
        let type = appStore.state.bookMarkListState.transitionType
        
        switch type {
        case .Quick:
            configureQuick()
        case .Search:
            let placeID = appStore.state.placeSearchState.selectedPlace?.placeId ?? ""
            configureSearch(placeId: placeID)
        case .BookMark:
            let bookMark = appStore.state.bookMarkListState.bookMark
            let loc = CLLocation(latitude: bookMark?.latitude ?? 0, longitude: bookMark?.longitude ?? 0)
            configureFavorite(locatoin: loc)
        }
    }
    
    private func configureFavorite(locatoin: CLLocation) {
//        model.startUpdatingLocation()
//
//        Observable.just(locatoin)
//            .subscribe(onNext: { [weak self] loc in
//                self?.didUpdateLocation.accept(loc)
//            })
//            .disposed(by: disposeBag)
    }
    
    private func configureSearch(placeId: String) {
        DawagaMapActionCreator.fetchSearchLocation(id: placeId)
    }
    
    private func configureQuick() {
        guard let locationManager = self.locationManager else {
            self.configureLocationManager()
            return
        }
        
        DawagaMapActionCreator.requestMonitoring(locationManager: locationManager)
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        
        let mapInsets = UIEdgeInsets(top: 0, left: 0, bottom: DawagaMapBottomView.VIEW_HEIGHT*0.9, right: 0)
        mapView.padding = mapInsets
        mapView.addSubview(markImageView)
        mapView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let markSize = 35
        markImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-markSize/2-Int(DawagaMapBottomView.VIEW_HEIGHT)/2)
            make.width.equalTo(markSize)
            make.height.equalTo(markSize)
        }
    }
    
    private func setupBottomView() {
        bottomView.setupTransitionType(
            type: appStore.state.bookMarkListState.transitionType,
            mark: appStore.state.bookMarkListState.bookMark
        )
        
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(view.frame.height-DawagaMapBottomView.VIEW_HEIGHT)
        }
    }
    
    private func configureMapCenter(with location: CLLocation) {
        let region = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)

        self.mapView.camera = region
    }
}

extension DawagaMapViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        
        // fetchReverseGeocode
        if currentLocation != state.dawagaMapState.idleLocation {
            if let location = state.dawagaMapState.idleLocation {
                self.currentLocation = location
                DawagaMapActionCreator.fetchReverseGeocode(location: location)
            }
        }

        bottomView.configureRegionField(address: state.dawagaMapState.reverseLocationDetail?.title ?? "")
        
        // fetch searchLocation
        if searchedLocation != state.dawagaMapState.searchLocationDetail?.location {
            if let searched = state.dawagaMapState.searchLocationDetail?.location {
                self.searchedLocation = searched
                configureMapCenter(with: searched)
            }            
        }
    }
}

extension DawagaMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let center = self.mapView.center
        let cgCenter = CGPoint(x: center.x, y: center.y)
        let coorCenter = self.mapView.projection.coordinate(for: cgCenter)
        let location = CLLocation(latitude: coorCenter.latitude, longitude: coorCenter.longitude)
        
        
        DawagaMapActionCreator.fetchIdleLocation(location: location)
    }
}

extension DawagaMapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.isAuthorization(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

        let region = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: zoomLevel)

        self.mapView.camera = region
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DawagaMapActionCreator.fetchErrorRequestMonotoring(locationManager: self.locationManager ?? CLLocationManager())
    }
}

extension DawagaMapViewController {
    
    private func isAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            DawagaMapActionCreator.fetchAuthorization(isAuthorized: true)
        case .denied, .restricted:
            DawagaMapActionCreator.fetchAuthorization(isAuthorized: false)
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            
        @unknown default:
            fatalError("isAuthorization: @unknown default")
        }
    }
}
