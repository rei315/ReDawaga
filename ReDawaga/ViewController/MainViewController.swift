//
//  MainViewController.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import UIKit
import ReSwift
import SnapKit

class MainViewController: UIViewController {

    
    // MARK: - UI Initialization
    
    private let searchView: MainViewSearchView = {
        let sv = MainViewSearchView()
        return sv
    }()
    
    private let bookmarkTableView: UITableView = {
        let tv = UITableView()
        return tv
    }()
    
    private let loadingView: LoadingView = {
        let loadingView = LoadingView(backgroundColor: .white)
        return loadingView
    }()

    // MARK: - Property
    
    private var markList: [MarkRealmEntity] = [] {
        didSet {
            DispatchQueue.main.async {
                self.bookmarkTableView.reloadData()
            }
            if !markList.isEmpty {
                self.setupTouchViewInTableView()
            }            
        }
    }
            
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isUserInteractionEnabled = false
        appStore.subscribe(self)
        
        self.setupNavigationController()
                                
        appStore.dispatch(thunkFetchBookMarkList)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        
        appStore.unsubscribe(self)        
        
        self.searchView.clearTextField()
        
        appStore.dispatch(BookMarkListActionCreator.fetchBookMarkList(marks: []))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        NetworkMonitor.shared.startMonitor()
        
        self.setupSearchView()
        self.setupBookmarkTableView()
    }

    
    // MARK: - Function
  
    private func presentSearchVC() {
        let searchVC = PlaceSearchViewController()
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(searchVC, animated: true)
        }        
    }
}


// MARK: - Redux
extension MainViewController: StoreSubscriber {
    func newState(state: AppState) {
        if !state.networkMonitorState.isConnected {
            self.showAlertNetworkConnectionError()
        }
        
        if state.bookMarkListState.isLoadingMarkRealm {
            bookmarkTableView.backgroundView = loadingView
            loadingView.startLoading()
        } else {
            loadingView.stopLoading()
            
            self.view.isUserInteractionEnabled = true
        }
        
        self.markList = state.bookMarkListState.markRealm
//        if !state.bookMarkListState.markRealm.isEmpty {
//            self.markList = state.bookMarkListState.markRealm
                                    
//            self.setupTouchViewInTableView()
//        }
    }
}


// MARK: - UI Setup
extension MainViewController {
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupSearchView() {
        view.addSubview(searchView)
        
        searchView.quickMapButtonAction = { [weak self] in
            
            let dawagaMapVC = DawagaMapViewController()
            BookMarkListActionCreator.fetchTransitionType(type: .Quick)
            DispatchQueue.main.async {
                self?.navigationController?.pushViewController(dawagaMapVC, animated: true)
            }
        }
        
        searchView.quickSearchButtonAction = { [weak self] address in
            
            BookMarkListActionCreator.fetchSearchAddress(address: address ?? "")
            BookMarkListActionCreator.fetchTransitionType(type: .Search)
            self?.presentSearchVC()
        }
        
        searchView.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(MainViewSearchView.VIEW_HEIGHT)
        })
    }
    
    private func setupBookmarkTableView() {
        view.addSubview(bookmarkTableView)
        
        bookmarkTableView.register(BookMarkTableViewCell.self, forCellReuseIdentifier: BookMarkTableViewCell.self.identifier)
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.estimatedRowHeight = BookMarkTableViewCell.CELL_HEIGHT
        bookmarkTableView.separatorStyle = .none
        
        bookmarkTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
        }
    }
    
    private func setupTouchViewInTableView() {
        bookmarkTableView.backgroundView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(onBackgroundView))
        bookmarkTableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func onBackgroundView() {
        self.view.endEditing(true)
    }
}


// MARK: - TableView Delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return markList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mark = markList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: BookMarkTableViewCell.self.identifier) as! BookMarkTableViewCell
        cell.configureItem(mark: mark)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookMarkTableViewCell.CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mark = self.markList[indexPath.row]
        let dawagaMapVC = DawagaMapViewController()
        BookMarkListActionCreator.fetchTransitionType(type: .BookMark)
        BookMarkListActionCreator.fetchBookMark(mark: mark)
                
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(dawagaMapVC, animated: true)
        }        
    }
}


// MARK: - Alert
extension MainViewController {
    
    private func showAlertNetworkConnectionError() {
        let action = UIAlertAction(title: AppString.Enter.localized(), style: .default) { _ in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        self.showAlert(title: AppString.NetworkConnectionErrorTitle.localized(), message: AppString.NetworkConnectionErrorMessage.localized(), style: .alert, actions: [action])
    }
}
