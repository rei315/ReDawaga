//
//  MainViewSearchView.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/03/31.
//

import UIKit
import SnapKit

class MainViewSearchView: UIView {
    
    static let VIEW_HEIGHT: CGFloat = 240
    
    
    // MARK: - UI Initialization
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 2
        label.text = AppString.HomeTitle.localized()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onBackgroundView))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var addressTextField: PaddingTextField = {
        let tf = PaddingTextField(padding: 10, type: .Delete)
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.adjustsFontSizeToFitWidth = true
        tf.attributedPlaceholder = NSAttributedString(string: AppString.AddressPlaceHolder.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.backgroundColor = .lightBlue
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1.5
        tf.layer.cornerRadius = 4.0
        tf.clearButtonMode = .always
        tf.returnKeyType = .search
        tf.delegate = self
        return tf
    }()
    
    private lazy var quickSearchButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        bt.backgroundColor = .lightBlue
        bt.layer.borderColor = UIColor.lightGray.cgColor
        bt.layer.borderWidth = 1.5
        bt.layer.cornerRadius = 4.0
        return bt
    }()
    
    private lazy var quickMapButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "map"), for: .normal)
        bt.backgroundColor = .lightBlue
        bt.layer.borderColor = UIColor.lightGray.cgColor
        bt.layer.borderWidth = 1.5
        bt.layer.cornerRadius = 4.0
        return bt
    }()
    
    private lazy var bookMarkLabel: UILabel = {
        let label = UILabel()
        label.text = AppString.BookMarkTitle.localized()
        label.font = UIFont.systemFont(ofSize: 25)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onBackgroundView))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var seperator: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .ultraLightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onBackgroundView))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()

    
    // MARK: - Property
    
    var quickSearchButtonAction: ((String?) -> ())?
    var quickMapButtonAction: (() -> ())?
    
    
    // MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupQuickSearchButtonView()
        setupQuickMapButtonView()        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function

    func clearTextField() {
        addressTextField.text = ""
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(addressTextField)
        addSubview(quickMapButton)
        addSubview(bookMarkLabel)
        addSubview(quickSearchButton)
        addSubview(seperator)        
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        addressTextField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(quickMapButton.snp.height)
        }
        
        quickSearchButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressTextField)
            make.left.equalTo(addressTextField.snp.right).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        quickMapButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(addressTextField)
            make.left.equalTo(quickSearchButton.snp.right).offset(5)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        seperator.snp.makeConstraints { (make) in
            make.bottom.equalTo(bookMarkLabel.snp.top).offset(-10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        bookMarkLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    @objc private func onQuickSearchButton(sender: UIButton) {
        quickSearchButtonAction?(addressTextField.text)
    }
    
    @objc private func onQuickMapButton(sender: UIButton) {
        quickMapButtonAction?()
    }
    
    private func setupQuickSearchButtonView() {
        quickSearchButton.addTarget(self, action: #selector(onQuickSearchButton(sender:)), for: .touchUpInside)
    }
    
    private func setupQuickMapButtonView() {
        quickMapButton.addTarget(self, action: #selector(onQuickMapButton(sender:)), for: .touchUpInside)
    }
    
    @objc private func onBackgroundView() {
        print("??")
        addressTextField.resignFirstResponder()
    }
}

extension MainViewSearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        quickSearchButtonAction?(addressTextField.text)
        return true
    }
}
