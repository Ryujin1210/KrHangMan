//
//  HelpPopupView.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2023/01/11.
//

import Foundation
import UIKit
import SnapKit

class HelpPopupView: UIView {
    
    let closeButton: UIButton = {
       let button = UIButton()
        button.tintColor = .darkGray
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        button.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
        return button
    }()
    
    let popupView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configurePopupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePopupView(){
        self.backgroundColor = .darkGray.withAlphaComponent(0.5)
        
        self.addSubview(popupView)
        popupView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.4)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        popupView.addSubview(closeButton)
        closeButton.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(5)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }
    
    func configureBackground() {
        let backgroundImg = AppManager.useUIService().getHelpImg(popupView)
        popupView.backgroundColor = UIColor(patternImage: backgroundImg)
    }
    
    @objc
    func tappedCloseButton() {
        self.isHidden = true
    }
}
