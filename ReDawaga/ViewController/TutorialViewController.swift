//
//  TutorialViewController.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/15.
//

import UIKit

class TutorialViewController: UIViewController {

    // MARK: - UI Initialization
    
    private lazy var tutorialView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = .white
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    private lazy var tutorialPage: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = UIColor.middleBlue
        pc.currentPageIndicatorTintColor = UIColor.systemOrange
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private lazy var tutorialDoneButton: UIButton = {
        let bt = UIButton()
        bt.backgroundColor = UIColor.systemOrange
        bt.layer.cornerRadius = 8
        bt.clipsToBounds = true
        bt.tintColor = .white
        bt.setTitle(AppString.TutorialDoneTitle.localized(), for: .normal)
        bt.isHidden = true
        bt.addTarget(self, action: #selector(onTutorialDoneButton), for: .touchUpInside)
        return bt
    }()
    
    
    // MARK: - Property
    
    private var tutorialImages: [UIImage] = []
    
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTutorialView()
    }
    
    
    // MARK: - Function
    private let tutorialDoneButtonHeight: CGFloat = 60
    
    @objc private func onTutorialDoneButton() {
        self.tutorialDoneButton.setTitle("", for: .normal)
        
        tutorialDoneButton.snp.updateConstraints { make in
            make.width.height.equalTo(tutorialDoneButtonHeight)
        }
        
        tutorialDoneButton.layer.cornerRadius = tutorialDoneButtonHeight/2
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .medium)
            self?.tutorialDoneButton.setImage(UIImage(systemName: "arrow.clockwise.circle", withConfiguration: largeConfig), for: .normal)
            self?.tutorialDoneButton.rotate()
        }
        
        UserDefaults.standard.setValue(true, forKey: "LaunchedBefore")

        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
            appDelegate.setupMainView()
        })
    }
}


// MARK: - ScrollView Delegate
extension TutorialViewController: UIScrollViewDelegate  {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / self.view.frame.width)
        
        tutorialPage.currentPage = Int(pageNumber)
        
        let maxPage = tutorialImages.count - 1
        
        if tutorialPage.currentPage == maxPage && tutorialDoneButton.isHidden {
            self.animateTutorialDoneButton(state: .Up)
            return
        }
        if tutorialPage.currentPage != maxPage && !tutorialDoneButton.isHidden {
            self.animateTutorialDoneButton(state: .Down)
            return
        }
    }
}


// MARK: - UI Setup
extension TutorialViewController {
    
    private func setupTutorialView() {
        view.addSubview(tutorialView)
        view.addSubview(tutorialPage)
        view.addSubview(tutorialDoneButton)
        
        tutorialView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tutorialPage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(70)
        }
        
        if var code = Locale.current.languageCode {
            if code != "ko" && code != "ja" && code != "en" { code = "en" }
            
            let tutorial_str = "tutorial_"
            let tutorial_str_1 = tutorial_str + code + "_1"
            let tutorial_str_2 = tutorial_str + code + "_2"
            let tutorial_str_3 = tutorial_str + code + "_3"
            let tutorial_str_4 = tutorial_str + code + "_4"
            
            tutorialImages.append(UIImage(named: tutorial_str_1) ?? UIImage())
            tutorialImages.append(UIImage(named: tutorial_str_2) ?? UIImage())
            tutorialImages.append(UIImage(named: tutorial_str_3) ?? UIImage())
            tutorialImages.append(UIImage(named: tutorial_str_4) ?? UIImage())
        }
        
        let pageWidth = self.view.frame.width
        
        tutorialView.contentSize = CGSize(width: CGFloat(tutorialImages.count) * self.view.frame.maxX, height: self.view.frame.height)
                
        tutorialImages.enumerated().forEach { index, image in
            let backView = UIView()
            let iv = UIImageView()
            iv.image = image
            iv.contentMode = .scaleAspectFit
            backView.addSubview(iv)
            
            tutorialView.addSubview(backView)
            
            let offset = CGFloat(index) * pageWidth
            
            backView.snp.makeConstraints { (make) in
                make.width.equalToSuperview()
                make.height.equalToSuperview()
                make.left.equalToSuperview().offset(offset)
                make.centerY.equalToSuperview()
            }
            
            iv.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.top.equalTo(tutorialPage.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
        }
        
        tutorialPage.numberOfPages = tutorialImages.count
        
        tutorialDoneButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(50)
//            make.width.equalToSuperview().multipliedBy(0.4)
            make.width.equalTo(view.frame.width*0.4)
            make.height.equalTo(50)
        }
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
    }
}


// MARK: - DoneButton Animation
extension TutorialViewController {
    
    enum TutorialDoneButtonAnimation { case Up, Down }
    
    private func animateTutorialDoneButton(state: TutorialDoneButtonAnimation) {
        switch state {
        case .Up:
            tutorialDoneButton.isHidden = false
            tutorialDoneButton.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(-100)
            }
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            
        case .Down:
            tutorialDoneButton.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(50)
            }
            self.tutorialDoneButton.isHidden = true
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
}
