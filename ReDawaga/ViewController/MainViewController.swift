//
//  MainViewController.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import UIKit
import ReSwift

class MainViewController: UIViewController {

    
    
    // MARK: - UI Initialization
    
    private var searchView: MainViewSearchView!
    private var bookmarkTableView: UITableView!
    
    
    // MARK: - Property
    
    private var markList: [MarkRealmEntity] = [] {
        didSet {
            bookmarkTableView.reloadData()
        }
    }
            
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appStore.subscribe(self)
        
        navigationController?.navigationBar.isHidden = true
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appStore.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSearchView()
        setupBookmarkTableView()
        
        BookMarkListActionCreator.fetchBookMarkList()
    }

    
    // MARK: - Function

    private func setupSearchView() {
        searchView = MainViewSearchView()
        view.addSubview(searchView)
        
        searchView.quickMapButtonAction = {
            let dawagaMapVC = DawagaMapViewController()
            BookMarkListActionCreator.fetchTransitionType(type: .Quick)
            self.navigationController?.pushViewController(dawagaMapVC, animated: true)
        }
        
        searchView.quickSearchButtonAction = { address in
            BookMarkListActionCreator.fetchSearchAddress(address: address ?? "")
            BookMarkListActionCreator.fetchTransitionType(type: .Search)
            self.presentSearchVC()
        }
        
        searchView.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.height.equalTo(MainViewSearchView.VIEW_HEIGHT)
        })
    }
    
    private func setupBookmarkTableView() {
        bookmarkTableView = UITableView()
        view.addSubview(bookmarkTableView)
        
        bookmarkTableView.register(BookMarkTableViewCell.self, forCellReuseIdentifier: BookMarkTableViewCell.self.identifier)
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
        bookmarkTableView.estimatedRowHeight = BookMarkTableViewCell.CELL_HEIGHT
        bookmarkTableView.separatorStyle = .none
                        
        bookmarkTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom).offset(50)
        }
    }
    
    private func presentSearchVC() {
        let searchVC = PlaceSearchViewController()
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension MainViewController: StoreSubscriber {
    func newState(state: AppState) {
        self.markList = state.bookMarkListState.markRealm
    }
}

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
        
        self.navigationController?.pushViewController(dawagaMapVC, animated: true)
    }
}


