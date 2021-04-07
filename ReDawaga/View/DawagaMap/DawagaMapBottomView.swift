//
//  DawagaMapBottomView.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/06.
//

import UIKit

class DawagaMapBottomView: CornerView {
    
    static let VIEW_HEIGHT: CGFloat = 220
        
    // MARK: - UI Initialization
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let distanceFiftyButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .lightGray
        bt.setTitle(AppString.Fifty.localized(), for: .normal)
        bt.backgroundColor = .red
        return bt
    }()
    
    private let distanceHundredButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .lightGray
        bt.setTitle(AppString.Hundred.localized(), for: .normal)
        return bt
    }()
    
    private let distanceThousandButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .lightGray
        bt.setTitle(AppString.Thousand.localized(), for: .normal)
        return bt
    }()
    
    private let distanceEditButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 5
        bt.backgroundColor = .lightGray
        bt.setTitle(AppString.DistanceEdit.localized(), for: .normal)
        return bt
    }()
    
    private let favoriteButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .middleBlue
        bt.setImage(UIImage(systemName: "star"), for: .normal)
        bt.tintColor = .white
        return bt
    }()
    
    private let startButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .middleBlue
        bt.setTitle(AppString.QuickMapStart.localized(), for: .normal)
        return bt
    }()
    
    private let valueEditDimView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return view
    }()
    
    private let valueEditView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()

    private let valueTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 20)
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(string: AppString.QuickMapEditValuePlaceHolder.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)])
        tf.textAlignment = .center
        tf.borderStyle = .none
        tf.returnKeyType = .done
        return tf
    }()
    
    private let valueEditButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .middleBlue
        bt.setTitle(AppString.Enter.localized(), for: .normal)
        return bt
    }()
    
    private let valueEditExitButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
        bt.contentHorizontalAlignment = .fill
        bt.contentVerticalAlignment = .fill
        return bt
    }()
    
    private let favoriteField: PaddingTextField = {
        let tf = PaddingTextField(padding: 10, type: .Default)
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.attributedPlaceholder = NSAttributedString(string: AppString.QuickMapNamePlaceHolder.localized(), attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        tf.layer.borderColor = UIColor.middleBlue.cgColor
        tf.layer.borderWidth = 1.5
        tf.layer.cornerRadius = 4.0
        tf.allowsEditingTextAttributes = false
        tf.textAlignment = .center
        tf.adjustsFontSizeToFitWidth = true
        return tf
    }()
    
    private let favoriteView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightBlue
        return view
    }()
    
    private let favoriteIconButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .lightGray
        bt.setImage(UIImage(systemName: "plus"), for: .normal)
        bt.tintColor = .white
        return bt
    }()
    
    private let favoriteCreateButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .middleBlue
        bt.setTitle(AppString.QuickMapAddFavorite.localized(), for: .normal)
        bt.tintColor = .white
        return bt
    }()
    
    private let favoriteDeleteButton: UIButton = {
        let bt = UIButton()
        bt.layer.cornerRadius = 8
        bt.backgroundColor = .middleBlue
        bt.setImage(UIImage(systemName: "trash"), for: .normal)
        bt.tintColor = .white
        return bt
    }()
    
    // MARK: - Property
    
    enum EditViewState { case on, off }
    enum EditState { case none, distance, favorite }
    enum DistanceState: Int{
        case Fifty = 50
        case Hundred = 100
        case Thousand = 1000
        case EditValue = 0
    }
    
    private var editViewState: EditViewState = .off
    private var editState: EditState = .none
    private var distanceState: DistanceState = .Fifty
    
    private var transitionType: DawagaMapViewController.TransitionType = .Quick
    private var mark: MarkRealmEntity?
    
    // MARK: - Lifecycle
    
    override init(cornerRadius: CGFloat) {
        super.init(cornerRadius: cornerRadius)
        self.backgroundColor = .lightBlue
        
        setupUI()
        setupBottomView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function

    func setupTransitionType(type: DawagaMapViewController.TransitionType, mark: MarkRealmEntity? = nil) {
        self.transitionType = type
        self.mark = mark
    }
    
    func configureRegionField(address: String) {
        self.regionLabel.text = address
    }
    
    @objc private func onEditFavorite() {
        switch (editViewState) {
        case .on:
            self.editOffFavorite()
            editViewState = .off
        case .off:
            self.editOnFavorite()
            editViewState = .on
        }
    }
}


// MARK: - UI

extension DawagaMapBottomView {
    
    private func setupUI() {
        
        valueEditDimView.addSubview(valueEditView)
        valueEditDimView.addSubview(valueEditExitButton)
        valueEditView.addSubview(valueTextField)
        valueEditView.addSubview(valueEditButton)
        
        valueEditExitButton.snp.makeConstraints { (make) in
            make.width.equalTo(valueEditView.snp.width).dividedBy(3)
            make.height.equalTo(valueEditView.snp.width).dividedBy(3)
            make.bottom.equalTo(valueEditView.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        
        valueEditView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(self.frame.width/2)
            make.height.equalTo(self.frame.height/5.5)
        }
        
        valueTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(valueEditButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.lessThanOrEqualToSuperview().offset(20)
        }
        valueEditButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-10)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.frame.width/3)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    private func setupBottomView() {
        let topStack = UIStackView(arrangedSubviews: [distanceFiftyButton,
                                                   distanceHundredButton,
                                                   distanceThousandButton,
                                                   distanceEditButton])
        topStack.axis = .horizontal
        topStack.spacing = 10
        topStack.distribution = .fillEqually
                
        
        self.addSubview(topStack)
        
        self.addSubview(regionLabel)
        self.addSubview(favoriteButton)
        self.addSubview(startButton)

        favoriteButton.addTarget(self, action: #selector(onEditFavorite), for: .touchUpInside)
        
        topStack.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        
        regionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topStack.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        startButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(regionLabel.snp.bottom).offset(20)
            make.height.equalTo(DawagaMapBottomView.VIEW_HEIGHT/4)
            make.width.equalTo(DeviceSize.screenWidth()-110)
        }
        
        favoriteButton.snp.makeConstraints { (make) in
            make.left.equalTo(startButton.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(startButton.snp.centerY)
            make.height.equalTo(startButton.snp.height)
        }
    }
    
    private func setupFavoriteIcon(image: UIImage) {
        favoriteIconButton.backgroundColor = .clear
        favoriteIconButton.layer.borderColor = UIColor.lightGray.cgColor
        favoriteIconButton.layer.borderWidth = 1.5
        favoriteIconButton.layer.cornerRadius = 8
        favoriteIconButton.contentVerticalAlignment = .fill
        favoriteIconButton.contentHorizontalAlignment = .fill
        favoriteIconButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        favoriteIconButton.setImage(image, for: .normal)
    }
}


// MARK: - Animation

extension DawagaMapBottomView {
    
    private func editOnFavorite() {
        self.snp.updateConstraints { (make) in
            make.top.equalToSuperview().offset(DeviceSize.screenHeight()-(DawagaMapBottomView.VIEW_HEIGHT*2.5))
            make.bottom.equalToSuperview()
        }
        startButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.width.equalTo(0)
        }

        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
        
        favoriteButton.setTitle(AppString.QuickMapDeleteFavorite.localized(), for: .normal)
        favoriteButton.backgroundColor = .middlePink
            
        favoriteView.addSubview(favoriteField)
        favoriteView.addSubview(favoriteCreateButton)
        favoriteView.addSubview(favoriteIconButton)
        
        self.addSubview(favoriteView)
        
        favoriteView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-40)
            make.top.equalTo(startButton.snp.bottom).offset(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        favoriteField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        favoriteIconButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(favoriteIconButton.snp.width)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.top.equalToSuperview()
        }
        
        if self.transitionType == .BookMark {
                        
            favoriteField.text = mark?.name
            let image = ResourceManager.shared.loadImageWithFileName(fileName: mark?.iconImageUrl ?? "")
            setupFavoriteIcon(image: image)

            favoriteView.addSubview(favoriteDeleteButton)
            favoriteCreateButton.setTitle(AppString.QuickMapModifyFavorite.localized(), for: .normal)
            favoriteCreateButton.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(20)
                make.height.equalTo(startButton.snp.height)
                make.width.equalToSuperview().multipliedBy(0.7)
                make.bottom.equalToSuperview()
            }
            
            favoriteDeleteButton.snp.makeConstraints { (make) in
                make.left.equalTo(favoriteCreateButton.snp.right).offset(20)
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalTo(favoriteCreateButton.snp.centerY)
                make.height.equalTo(favoriteCreateButton.snp.height)
            }
        } else {
            favoriteCreateButton.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(startButton.snp.height)
                make.width.equalToSuperview().multipliedBy(0.8)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    private func editOffFavorite() {
        self.snp.updateConstraints { (make) in
            make.bottom.equalToSuperview().offset(DeviceSize.screenHeight()-DawagaMapBottomView.VIEW_HEIGHT)
            make.top.equalToSuperview().offset(DeviceSize.screenHeight()-DawagaMapBottomView.VIEW_HEIGHT)
        }
        
        startButton.snp.updateConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(DeviceSize.screenWidth()-110)
        }
                        
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
        UIView.animate(withDuration: 0.5) {
            self.superview?.layoutIfNeeded()
        }
        
        favoriteButton.setTitle("", for: .normal)
        favoriteButton.backgroundColor = .middleBlue
        
        favoriteField.removeFromSuperview()
        favoriteIconButton.removeFromSuperview()
        favoriteCreateButton.removeFromSuperview()
        
        if self.transitionType == .BookMark {
            favoriteDeleteButton.removeFromSuperview()
        }
    }
}
