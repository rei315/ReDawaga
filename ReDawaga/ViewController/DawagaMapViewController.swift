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
    
    private lazy var mapView: GMSMapView = {
        let mapView = GMSMapView()
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        return mapView
    }()
    
    private let markSize = 35
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
    
    private var distanceEditView: DawagaMapEditView?
        
    
    // MARK: - Property
    
    private lazy var circle: GMSCircle = {
        let circle = GMSCircle()
        circle.fillColor = UIColor.red.withAlphaComponent(0.2)
        circle.strokeColor = UIColor.red
        circle.strokeWidth = 1
        return circle
    }()
                
    private var locationManager: CLLocationManager = CLLocationManager()
    private lazy var locationEmitter = LocationEmitter(locationManager: locationManager)
    
    private var currentLocation: CLLocation?
    private var currentEmitterLocation: CLLocation?
    private var searchedLocation: CLLocation?
    
    private let zoomLevel: Float = 15.0
    
    private var curBookMarkTitle: String = ""
    private var curBookMarkIconName: String = ""
    private var curBookMarkIdentity: String = ""
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appStore.subscribe(self)
        
        self.setupNavigationController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        appStore.unsubscribe(self)
        
        LocationEmitterActionCreator.fetchLocation(location: nil)
        
        DawagaMapActionCreator.fetchBookMarkIconName(with: "")
        BookMarkListActionCreator.fetchBookMark(mark: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupBottomView()
        
        configureType()
    }

    
    // MARK: - Function

    private func configureType() {
        let type = appStore.state.bookMarkListState.transitionType
        
        switch type {
        case .Quick:
            configureQuick()
        case .Search:
            guard let placeID = appStore.state.placeSearchState.selectedPlace?.placeId else { return }
            configureSearch(placeId: placeID)
        case .BookMark:
            guard let bookMark = appStore.state.bookMarkListState.bookMark else { return }
            configureBookMark(bookMark: bookMark)
        }
    }
    
    private func configureBookMark(bookMark: MarkRealmEntity) {
        let location = CLLocation(latitude: bookMark.latitude, longitude: bookMark.longitude)
        let title = bookMark.name
        let icon = bookMark.iconImageUrl
        
        self.configureMapCenter(with: location)
        self.curBookMarkTitle = title
        self.curBookMarkIconName = icon
        self.curBookMarkIdentity = bookMark.identity
        self.bottomView.configureBookMarkField(title: title)
        
        let image = ResourceManager.shared.loadImageWithFileName(fileName: icon)
        
        self.bottomView.setupBookMarkIcon(image: image)
    }
    
    private func configureSearch(placeId: String) {
        DawagaMapActionCreator.fetchSearchLocation(id: placeId)
    }
    
    private func configureQuick() {
        locationEmitter.requestLocation()
    }
    
    private func configureMapCenter(with location: CLLocation) {
        let region = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)

        self.mapView.camera = region
    }
    
    private func configureCircle(with radius: Int) {
        mapView.clear()
        
        let cllDistance = CLLocationDistance(radius)
        let center = CGPoint(x: self.mapView.center.x , y: self.mapView.center.y - DawagaMapBottomView.VIEW_HEIGHT/2)
        let coor = self.mapView.projection.coordinate(for: center)
                
        circle.position = coor
        circle.radius = cllDistance
        
        circle.map = mapView
    }
    
    private func presentBookMarkIconSelectorVC() {
        let bookMarkIconSelectorVC = BookMarkIconSelectorViewController()
        
        self.present(bookMarkIconSelectorVC, animated: true, completion: nil)
    }
}

extension DawagaMapViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        
        switch state.locationEmitterState.authorizationStatus {
        case .denied, .restricted:
            let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            self.showAlert(title: AppString.LocationDeniedTitle.localized(), message: AppString.LocationDeniedMessage.localized(), style: .alert, actions: [action])
        case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
        
        if let location = state.locationEmitterState.location, self.currentEmitterLocation != location {
            self.currentEmitterLocation = location
            configureMapCenter(with: location)
        }
        
        // SearchLocation Makes Center
        if state.bookMarkListState.transitionType == .Search {
            if searchedLocation != state.dawagaMapState.searchLocationDetail?.location {
                if let searched = state.dawagaMapState.searchLocationDetail?.location {
                    self.searchedLocation = searched
                    self.configureMapCenter(with: searched)
                }
            }
        }
        
        if curBookMarkIconName != state.dawagaMapState.bookMarkIconName && state.dawagaMapState.bookMarkIconName != "" {
            let name = state.dawagaMapState.bookMarkIconName
            self.curBookMarkIconName = name
            let image = ResourceManager.shared.loadImageWithFileName(fileName: name)
            
            bottomView.setupBookMarkIcon(image: image)
        }
        
        // ReverseGeocode
        if currentLocation != state.dawagaMapState.idleLocation {
            if let location = state.dawagaMapState.idleLocation {
                self.currentLocation = location
                DawagaMapActionCreator.fetchReverseGeocode(location: location)
            }
        }
        
        bottomView.configureRegionField(address: state.dawagaMapState.reverseLocationDetail?.title ?? "")
    }
}

extension DawagaMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let center = self.mapView.center
        let cgCenter = CGPoint(x: center.x, y: center.y - DawagaMapBottomView.VIEW_HEIGHT/2)
        let coorCenter = self.mapView.projection.coordinate(for: cgCenter)
        let location = CLLocation(latitude: coorCenter.latitude, longitude: coorCenter.longitude)
        
        DawagaMapActionCreator.fetchIdleLocation(location: location)
        
        let distance = appStore.state.dawagaMapState.distanceState
        self.configureCircle(with: distance)
    }
}

// MARK: - UI Setup

extension DawagaMapViewController {
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        let mapInsets = UIEdgeInsets(top: 0, left: 0, bottom: DawagaMapBottomView.VIEW_HEIGHT*0.9, right: 0)
        mapView.padding = mapInsets
        mapView.addSubview(markImageView)
        mapView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
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
        
        bottomView.fiftyButtonAction = { distance in
            DawagaMapActionCreator.fetchDistanceState(with: distance)
            self.configureCircle(with: distance)
        }
        
        bottomView.hundredButtonAction = { distance in
            DawagaMapActionCreator.fetchDistanceState(with: distance)
            self.configureCircle(with: distance)
        }
        
        bottomView.thousandButtonAction = { distance in
            DawagaMapActionCreator.fetchDistanceState(with: distance)
            self.configureCircle(with: distance)
        }
        
        bottomView.bookMarkIconButtonAction = {
            self.presentBookMarkIconSelectorVC()
        }
        
        bottomView.editViewAction = { state in
            switch state {
            case .BookMark:
                self.setupDistanceEditView(state: .BookMark)
            case .Distance:
                self.setupDistanceEditView(state: .Distance)
            case .None:
                break
            }
        }
        
        bottomView.startDawagaButtonAction = {
            let coordinate = self.circle.position
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            DawagaMapActionCreator.fetchDestination(with: location)
            
            let DawagaLoadingVC = DawagaLoadingViewController()
            self.navigationController?.pushViewController(DawagaLoadingVC, animated: true)
        }
        
        bottomView.saveBookMarkButtonAction = {
            let title = self.curBookMarkTitle
            let markIcon = self.curBookMarkIconName
            let location = self.circle.position
            let address = appStore.state.dawagaMapState.reverseLocationDetail?.title ?? ""
            
            guard self.checkMarkRealmTitleAvailable(title: title) else {
                let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkNameEmptyAlertMessage.localized(), style: .alert, actions: [action])
                return
            }
            guard self.checkMarkRealmIconAvailable(icon: markIcon) else {
                let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkImageEmptyAlertMessage.localized(), style: .alert, actions: [action])
                return
            }
            
            let realmMark = MarkRealmEntity(identity: "\(Date())", name: title, latitude: location.latitude, longitude: location.longitude, address: address, iconImageUrl: markIcon)
            
            MarkRealm.saveMarkRealm(mark: realmMark)
                .done {
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                    self.showAlert(title: AppString.CreatedComplete.localized(), message: AppString.BookMarkCreated.localized(), style: .alert, actions: [action])
                }
                .catch { error in
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                    self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
                }
        }
        
        bottomView.editBookMarkButtonAction = {
            guard let lat = self.currentLocation?.coordinate.latitude else { return }
            guard let lng = self.currentLocation?.coordinate.longitude else { return }
            guard let address = appStore.state.dawagaMapState.reverseLocationDetail?.title else { return }
            
            let title = self.curBookMarkTitle
            let markIcon = self.curBookMarkIconName
            
            guard self.checkMarkRealmTitleAvailable(title: title) else {
                let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkNameEmptyAlertMessage.localized(), style: .alert, actions: [action])
                return
            }
            guard self.checkMarkRealmIconAvailable(icon: markIcon) else {
                let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkImageEmptyAlertMessage.localized(), style: .alert, actions: [action])
                return
            }
            
            MarkRealm.editMarkRealm(identity: self.curBookMarkIdentity, name: self.curBookMarkTitle, address: address, iconImage: self.curBookMarkIconName, latitude: lat , longitude: lng)
                .done { isSuccess in
                    if isSuccess {
                        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
                            _ = self.navigationController?.popToRootViewController(animated: true)
                        }
                        self.showAlert(title: AppString.UpdateComplete.localized(), message: AppString.BookMarkUpdated.localized(), style: .alert, actions: [action])
                    }
                    else {
                        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                        self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
                    }
                }
                .catch { error in
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                    self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
                }
        }
        
        bottomView.deleteBookMarkButtonAction = {
            MarkRealm.removeMarkRealm(identity: self.curBookMarkIdentity)
                .done { isSuccess in
                    if isSuccess {
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                    else {
                        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                        self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
                    }
                }
                .catch { error in
                    let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
                    self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
                }
        }
        
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(view.frame.height-DawagaMapBottomView.VIEW_HEIGHT)
        }
    }
    
    private func checkMarkRealmTitleAvailable(title: String) -> Bool {
        if title.isEmpty { return false }
                
        return true
    }
    private func checkMarkRealmIconAvailable(icon: String) -> Bool {
        if icon.isEmpty { return false }
        return true
    }
    
    private func setupDistanceEditView(state: DawagaMapBottomView.EditState) {
        guard distanceEditView == nil else { return }
        
        self.distanceEditView = DawagaMapEditView(state: state)
        if let view = self.distanceEditView {
            self.view.addSubview(view)
        }
        
        distanceEditView?.enterDistanceButtonAction = { value in
            DawagaMapActionCreator.fetchDistanceState(with: value)
            self.distanceEditView?.removeFromSuperview()
            self.distanceEditView = nil
        }
        
        distanceEditView?.enterBookMarkButtonAction = { title in
            self.curBookMarkTitle = title
            self.bottomView.configureBookMarkField(title: title)
            self.distanceEditView?.removeFromSuperview()
            self.distanceEditView = nil
        }
        
        distanceEditView?.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
    }
}
