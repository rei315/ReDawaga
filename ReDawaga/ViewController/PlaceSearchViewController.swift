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
    
    private var searchView: PlaceSearchView!
    private var placeTableView: UITableView!
    
    
    // MARK: - Property
    
    private var placeList: [PlaceEntity] = [] {
        didSet {
            placeTableView.reloadData()
        }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appStore.subscribe(self)
        self.view.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = NavigationTitle.DestinationAddress.localized()
    }
             
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appStore.unsubscribe(self)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchView()
        setupPlaceTableView()
    }
    
    
    // MARK: - Function
    
    private func setupSearchView() {
        searchView = PlaceSearchView()
        view.addSubview(searchView)
        
        searchView.searchButtonAction = { address in
            PlaceSearchActionCreator.fetchPlaceList(address: address ?? "")
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
        placeTableView = UITableView()
        view.addSubview(placeTableView)
        
        placeTableView.register(PlaceSearchTableViewCell.self, forCellReuseIdentifier: PlaceSearchTableViewCell.self.identifier)
        placeTableView.delegate = self
        placeTableView.dataSource = self
        placeTableView.estimatedRowHeight = PlaceSearchTableViewCell.CELL_HEIGHT
        
        placeTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
    }
    
    private func presentDawagaMapVC(place: PlaceEntity) {
        let dawagaMapVC = DawagaMapViewController()        
        PlaceSearchActionCreator.fetchSelectedPlace(place: place)
        
        self.navigationController?.pushViewController(dawagaMapVC, animated: true)
    }
}

extension PlaceSearchViewController: StoreSubscriber  {
    
    func newState(state: AppState) {
        // 이런식으로 추가
        // let isPlaceEmpty = emptyErrorView.isHidden ? True : False
        
        self.placeList = state.placeSearchState.placeList
    }
}

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
