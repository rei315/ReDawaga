//
//  BookMarkIconSelectorViewController.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/08.
//

import UIKit
import ReSwift

class BookMarkIconSelectorViewController: UIViewController {

    // MARK: - UI Initialization
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = .zero
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(BookMarkIconCell.self, forCellWithReuseIdentifier: BookMarkIconCell.self.identifier)
        return cv
    }()
    
    
    // MARK: - Property
    
    private var iconTitles: [String] = [] {
        
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appStore.subscribe(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        appStore.unsubscribe(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadIconResource()
        self.setupCollectionView()
    }
    

    // MARK: - Function

    private func loadIconResource() {
        BookMarkIconSelectorActionCreator.fetchIconTitles()
    }
    
    private func setupCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}

// MARK: - Redux
extension BookMarkIconSelectorViewController: StoreSubscriber {
    
    func newState(state: AppState) {
        self.iconTitles = state.bookMarkIconSelectorState.iconTitles
    }
}


// MARK: - CollectionView Delegate
extension BookMarkIconSelectorViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookMarkIconCell.self.identifier, for: indexPath) as! BookMarkIconCell
        let iconTitle = iconTitles[indexPath.row]
        cell.configureItem(iconUrl: iconTitle)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = self.iconTitles[indexPath.row]
//        BookMarkIconSelectorActionCreator.fetchSelectedTitle(title: title)
                
        self.dismiss(animated: true) {
            DawagaMapActionCreator.fetchBookMarkIconName(with: ResourceManager.shared.getFileName(fullURL: title))
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            cell.contentView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            cell.contentView.backgroundColor = nil
//        }
//    }
}


// MARK: - CollectionView FlowLayout
extension BookMarkIconSelectorViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGFloat = self.view.frame.width / 5
        return CGSize(width: cellSize, height: cellSize)
    }
}
