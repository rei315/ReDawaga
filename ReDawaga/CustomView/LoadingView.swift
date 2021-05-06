//
//  LoadingView.swift
//  ReDawaga
//
//  Created by 김민국 on 2021/04/27.
//

import UIKit
import SnapKit

class LoadingView: UIView {

    // MARK: - UI Initialization

    private let loadingIndicator: ProgressView = {
        let progress = ProgressView(colors: [.middleBlue], lineWidth: 5)
        return progress
    }()
    
    
    // MARK: - Lifecycle
    
    init(backgroundColor: UIColor) {
        super.init(frame: .zero)
        
        self.setupUI(color: backgroundColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Function

    func startLoading() {
        isHidden = false
        loadingIndicator.isAnimating = true
    }
    
    func stopLoading() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.loadingIndicator.isAnimating = false
            self.isHidden = true
        }
    }
    
    private func setupUI(color: UIColor) {
        self.backgroundColor = color
        
        self.addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
}
