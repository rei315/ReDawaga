//
//  PlaceSearchViewController.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/05.
//

import UIKit
import ReSwift

class PlaceSearchViewController: UIViewController {

    // MARK: - UI Initialization
    
    private let searchView: PlaceSearchView = {
        let sv = PlaceSearchView()
        return sv
    }()
    
    private lazy var placeTableView: UITableView = {
        let tv = UITableView()
        tv.register(PlaceSearchTableViewCell.self, forCellReuseIdentifier: PlaceSearchTableViewCell.self.identifier)
        tv.delegate = self
        tv.dataSource = self
        tv.estimatedRowHeight = PlaceSearchTableViewCell.CELL_HEIGHT
        return tv
    }()
    
    
    // MARK: - Property
    
    private var placeList: [PlaceEntity] = [] {
        didSet {
            DispatchQueue.main.async {
                self.placeTableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appStore.subscribe(self)
        self.view.backgroundColor = .white
        
        self.setupNavigationController()
    }
             
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        appStore.unsubscribe(self)                
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkMonitor.shared.startMonitor()
        self.setupSearchView()
        self.setupPlaceTableView()        
    }
    
    
    // MARK: - Function
    
    private func presentDawagaMapVC(place: PlaceEntity) {
        let dawagaMapVC = DawagaMapViewController()
        PlaceSearchActionCreator.fetchSelectedPlace(place: place)
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(dawagaMapVC, animated: true)
        }        
    }
}


// MARK: - Redux
extension PlaceSearchViewController: StoreSubscriber  {
    
    func newState(state: AppState) {
        if !state.networkMonitorState.isConnected {
            self.showAlertNetworkConnectionError()
        }
        
        self.placeList = state.placeSearchState.placeList
    }
}


// MARK: - UI Setup
extension PlaceSearchViewController {
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = NavigationTitle.DestinationAddress.localized()
    }
    
    private func setupSearchView() {
        view.addSubview(searchView)
        
        searchView.searchButtonAction = { address in
            appStore.dispatch(thunkFetchAutoCompleteList(address ?? ""))
        }
        let storeAddress = appStore.state.bookMarkListState.searchAddress
        
        searchView.configureItem(address: storeAddress)
        searchView.searchButtonAction?(storeAddress)
        
        searchView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(PlaceSearchView.VIEW_HEIGHT)
        }
    }
    
    private func setupPlaceTableView() {
        view.addSubview(placeTableView)
        
        placeTableView.backgroundView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(onBackgroundView))
        placeTableView.backgroundView?.addGestureRecognizer(tap)
        
        placeTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
    }
    
    @objc func onBackgroundView() {
        self.view.endEditing(true)
    }
    
}


// MARK: - Alert
extension PlaceSearchViewController {
    private func showAlertNetworkConnectionError() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        self.showAlert(title: AppString.NetworkConnectionErrorTitle.localized(), message: AppString.NetworkConnectionErrorMessage.localized(), style: .alert, actions: [action])
    }
}


// MARK: - TableView Delegate
extension PlaceSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = placeList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaceSearchTableViewCell.self.identifier) as! PlaceSearchTableViewCell
        cell.configurePlace(place: place)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PlaceSearchTableViewCell.CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = placeList[indexPath.row]
        presentDawagaMapVC(place: place)
    }
}
