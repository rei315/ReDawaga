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
        
    private let loadingView: LoadingView = {
        let loadingView = LoadingView(backgroundColor: .lightGray)        
        loadingView.isUserInteractionEnabled = false
        return loadingView
    }()
    
    
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
    
    private let zoomLevel: Float = 15.0
    
    private var curBookMarkIdentity: String = ""
        
    private var curDistance: Int = DawagaMapBottomView.DistanceState.Fifty.rawValue
    
    
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
        
        appStore.dispatch(DawagaMapActionCreator.fetchReverseGeocode(location: nil))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMapView()
        self.configureType()
        self.setupBottomView()
        self.setupLoadingView()
    }

    
    // MARK: - Function

    private func configureType() {
        let type = appStore.state.bookMarkListState.transitionType
        
        switch type {
        case .Quick:
            self.configureQuick()
        case .Search:
            guard let placeID = appStore.state.placeSearchState.selectedPlace?.placeId else { return }
            self.configureSearch(placeId: placeID)
        case .BookMark:
            guard let bookMark = appStore.state.bookMarkListState.bookMark else { return }
            self.configureBookMark(bookMark: bookMark)
        }
    }
    
    private func configureBookMark(bookMark: MarkRealmEntity) {
        let location = CLLocation(latitude: bookMark.latitude, longitude: bookMark.longitude)
        let title = bookMark.name
        let icon = bookMark.iconImageUrl
        
        self.configureMapCenter(with: location)
        self.curBookMarkIdentity = bookMark.identity
        self.bottomView.configureBookMarkField(title: title)
        
        self.bottomView.setupBookMarkIcon(imageName: icon)
    }
    
    private func configureSearch(placeId: String) {        
        appStore.dispatch(thunkFetchSearchLocation(placeId))
    }
    
    private func configureQuick() {
        locationEmitter.startUpdatingLocation(type: .OneTime)
    }
    
    private func configureMapCenter(with location: CLLocation) {
        let region = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)

        self.mapView.camera = region
    }
    
    private func configureCircle(with radius: Int) {
        mapView.clear()
        
        let cllDistance = CLLocationDistance(radius)
                
        circle.position = mapView.camera.target
        circle.radius = cllDistance
        
        circle.map = mapView
    }
    
    private func presentBookMarkIconSelectorVC() {
        let bookMarkIconSelectorVC = BookMarkIconSelectorViewController()
        
        DispatchQueue.main.async {
            self.present(bookMarkIconSelectorVC, animated: true, completion: nil)
        }
    }
}


extension DawagaMapViewController: StoreSubscriber {
    
    func newState(state: AppState) {        
        guard !state.dawagaLoadingState.isStartDawaga else { return }
        
        switch state.locationEmitterState.authorizationStatus {
        case .denied, .restricted:
            self.setAuthorizationFailedState()
            return
        case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
        
        switch state.bookMarkListState.transitionType {
        case .Quick:
            if let location = state.locationEmitterState.location {
                self.setLocationEmitterState(location: location)
                LocationEmitterActionCreator.fetchLocation(location: nil)
                return
            }
        case .Search:
            if let location = state.dawagaMapState.searchLocationDetail?.location {
                self.setMapCenterState(location: location)
                appStore.dispatch(DawagaMapActionCreator.fetchSearchLocation(location: nil))
                return
            }
        case .BookMark:
            break
        }
        
        if let location = state.dawagaMapState.idleLocation {
            self.reverseGeocodeState(location: location)
            DawagaMapActionCreator.fetchIdleLocation(location: nil)
            return
        }
        
        if let iconName = state.dawagaMapState.bookMarkIconName {
            self.setBookMarkIconState(name: iconName)
            DawagaMapActionCreator.fetchBookMarkIconName(with: nil)
            return
        }
        
        switch state.dawagaMapState.realmBookMarkType {
        case let .save(type):
            switch type {
            case .isComplete:
                self.showAlertBookMarkCreateComplete()
                DawagaMapActionCreator.fetchInitRealmBookMark()
                return
            case .isError:
                self.showAlertBookMarkCreateError()
                DawagaMapActionCreator.fetchInitRealmBookMark()
                return
            case .isLoading:
                break
            }
        case let .edit(type):
            switch type {
            case .isComplete:
                self.showAlertBookMarkEditComplete()
                DawagaMapActionCreator.fetchInitRealmBookMark()
                return
            case .isError:
                self.showAlertBookMarkEditError()
                DawagaMapActionCreator.fetchInitRealmBookMark()
                return
            case .isLoading:
                break
            }
        case let .delete(type):
            switch type {
            case .isComplete:
                _ = self.navigationController?.popToRootViewController(animated: true)
                DawagaMapActionCreator.fetchInitRealmBookMark()
               return
            case .isError:
                self.showAlertBookMarkDeleteError()
                DawagaMapActionCreator.fetchInitRealmBookMark()
                return
            case .isLoading:
                break
            }
        case .none:
            break
        }
        
        
        if let region = state.dawagaMapState.reverseLocationDetail {
            bottomView.configureRegionField(address: region.title)
//            return
        }
    }
        
    
    private func setAuthorizationFailedState() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        self.showAlert(title: AppString.LocationDeniedTitle.localized(), message: AppString.LocationDeniedMessage.localized(), style: .alert, actions: [action])
    }
    
    private func setLocationEmitterState(location: CLLocation) {
        loadingView.stopLoading()
        configureMapCenter(with: location)
    }
    
    private func setMapCenterState(location: CLLocation) {
        self.configureMapCenter(with: location)
    }
    
    private func setBookMarkIconState(name: String) {
        self.bottomView.setupBookMarkIcon(imageName: name)
    }
    
    private func reverseGeocodeState(location: CLLocation) {
        appStore.dispatch(thunkFetchReverseLocation(location))
    }
}

extension DawagaMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let coor = mapView.camera.target
        
        DawagaMapActionCreator.fetchIdleLocation(location: CLLocation(latitude: coor.latitude, longitude: coor.longitude))
                        
        self.configureCircle(with: self.curDistance)
    }
}

// MARK: - UI Setup

extension DawagaMapViewController {
    
    private func setupLoadingView() {
        if appStore.state.bookMarkListState.transitionType == .Quick {
            view.addSubview(loadingView)
            loadingView.startLoading()
            
            loadingView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
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
            make.centerY.equalToSuperview().offset(-markSize-Int(DawagaMapBottomView.VIEW_HEIGHT)/4)
            make.width.equalTo(markSize)
            make.height.equalTo(markSize)
        }
    }
    
    private func setupBottomView() {
        
        bottomView.setupTransitionType(
            type: appStore.state.bookMarkListState.transitionType,
            mark: appStore.state.bookMarkListState.bookMark
        )
        
        bottomView.distanceButtonAction = { [weak self] distance in
            guard let self = self else { return }
            
            self.curDistance = distance
            self.configureCircle(with: distance)
        }
        
        bottomView.bookMarkIconButtonAction = { [weak self] in
            guard let self = self else { return }
            
            self.presentBookMarkIconSelectorVC()
        }
        
        bottomView.editViewAction = { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .BookMark:
                self.setupDistanceEditView(state: .BookMark)
            case .Distance:
                self.setupDistanceEditView(state: .Distance)
            case .None:
                break
            }
        }
        
        bottomView.startDawagaButtonAction = { [weak self] in
            guard let self = self else { return }
            
            let coordinate = self.circle.position
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            DawagaMapActionCreator.fetchDestination(with: location)
            
            let DawagaLoadingVC = DawagaLoadingViewController()
            
            DispatchQueue.main.async {
                self.present(DawagaLoadingVC, animated: true, completion: nil)
            }
        }
        
        bottomView.saveBookMarkButtonAction = { [weak self] param in
            guard let self = self else { return }
            
            let location = self.circle.position
            
            guard self.checkMarkRealmTitleAvailable(title: param.title) else {
                self.showAlertBookMarkTitleError()
                return
            }
            guard self.checkMarkRealmIconAvailable(icon: param.icon) else {
                self.showAlertBookMarkIconError()
                return
            }
            
            let realmMark = MarkRealmEntity(identity: "\(Date())", name: param.title, latitude: location.latitude, longitude: location.longitude, address: param.address, iconImageUrl: param.icon)
            
            appStore.dispatch(thunkSaveBookMark(mark: realmMark))
        }
        
        bottomView.editBookMarkButtonAction = { [weak self] param in
            guard let self = self else { return }
            
            let lat = self.circle.position.latitude
            let lng = self.circle.position.longitude
            
            guard self.checkMarkRealmTitleAvailable(title: param.title) else {
                self.showAlertBookMarkTitleError()
                return
            }
            guard self.checkMarkRealmIconAvailable(icon: param.icon) else {
                self.showAlertBookMarkIconError()
                return
            }
            
            appStore.dispatch(thunkEditBookMark(identity: self.curBookMarkIdentity, name: param.title, address: param.address, iconImage: param.icon, latityde: lat, longitude: lng))
        }
        
        bottomView.deleteBookMarkButtonAction = { [weak self] in
            guard let self = self else { return }
            
            appStore.dispatch(thunkDeleteBookMark(identity: self.curBookMarkIdentity))
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
        
        distanceEditView?.enterDistanceButtonAction = { [weak self] value in
            guard let self = self else { return }
            
            self.curDistance = value
            self.configureCircle(with: value)
            self.distanceEditView?.removeFromSuperview()
            self.distanceEditView = nil
        }
        
        distanceEditView?.enterBookMarkButtonAction = { [weak self] title in
            guard let self = self else { return }
            
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


// MARK: - Alert
extension DawagaMapViewController {
    private func showAlertBookMarkTitleError() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
        self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkNameEmptyAlertMessage.localized(), style: .alert, actions: [action])
    }
    
    private func showAlertBookMarkIconError() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
        self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkImageEmptyAlertMessage.localized(), style: .alert, actions: [action])
    }
    
    private func showAlertBookMarkCreateComplete() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        self.showAlert(title: AppString.CreatedComplete.localized(), message: AppString.BookMarkCreated.localized(), style: .alert, actions: [action])
    }
    
    private func showAlertBookMarkCreateError() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
        self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
    }
    
    private func showAlertBookMarkEditComplete() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        self.showAlert(title: AppString.UpdateComplete.localized(), message: AppString.BookMarkUpdated.localized(), style: .alert, actions: [action])
    }
    
    private func showAlertBookMarkEditError() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
        self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
    }
    
    private func showAlertBookMarkDeleteError() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default)
        self.showAlert(title: AppString.InputError.localized(), message: AppString.BookMarkRealmErrorAlertMessage.localized(), style: .alert, actions: [action])
    }        
}
