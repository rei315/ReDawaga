//
//  BookMarkIconCell.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/08.
//

import UIKit
import SnapKit


class BookMarkIconCell: UICollectionViewCell {
        
    // MARK: - UI Initialization
    
    private lazy var iconImageButton: UIButton = {
        let bt = UIButton()
        bt.layer.borderColor = UIColor.lightGray.cgColor
        bt.layer.borderWidth = 1.5
        bt.layer.cornerRadius = 8
        bt.contentVerticalAlignment = .fill
        bt.contentHorizontalAlignment = .fill
        bt.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        bt.isUserInteractionEnabled = false
        return bt
    }()
    
    // MARK: - Property
    
    private var iconUrl: String = ""
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
//        setupButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function
    
    func configureItem(iconUrl url: String) {
        self.iconUrl = url
        let image = ResourceManager.shared.getImageFromURL(str: url)
        
        iconImageButton.setImage(image, for: .normal)
    }
    
    
    // MARK: - Function
    
    private func setupUI() {
        self.addSubview(iconImageButton)
        iconImageButton.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        selectedBackgroundView = view
    }
    
    func setupButtonAction() {
//        iconImageButton.rx.touchDownGesture()
//            .when(.began)
//            .subscribe(onNext: { [weak self] _ in
//                self?.iconImageButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
//            })
//            .disposed(by: disposeBag)
//        iconImageButton.rx
//            .swipeGesture([.down, .left, .right, .up])
//            .when(.ended)
//            .subscribe({ [weak self] _ in
//                self?.iconImageButton.backgroundColor = UIColor.white
//            })
//            .disposed(by: disposeBag)
//        iconImageButton.rx
//            .anyGesture(.tap())
//            .when(.ended)
//            .subscribe({ [weak self] _ in
//                self?.iconImageButton.backgroundColor = UIColor.white
//                self?.delegate?.markCellSelected(selectedImage: self?.iconImageButton.image(for: .normal) ?? UIImage(), url: self?.iconUrl ?? "")
//            })
//            .disposed(by: disposeBag)
    }
}
