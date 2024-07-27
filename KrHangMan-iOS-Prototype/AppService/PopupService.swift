//
//  PopupService.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2023/01/03.
//

import Foundation
import UIKit
import SnapKit

struct PopUpMessage {
    enum MessageType {
        case ok, cancle, data
    }
    let type: MessageType
    let data: String?
}

class PopupService: ServiceAble {
    
    func popUp(parentUIView: UIView, popUpUIView: UIView) -> ObservableObject<PopUpMessage>? {
        
        parentUIView.addSubview(popUpUIView)
        
        popUpUIView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        if let popUpUIView = popUpUIView as? PopUpAble {
            return popUpUIView.getPopUpMessage()
        }
        
        return nil
    }
    
    func popUpIndicator(parentUIView: UIView, popUpIndicatorUIView: UIView) -> ObservableObject<PopUpMessage>? {
        parentUIView.addSubview(popUpIndicatorUIView)
        
        popUpIndicatorUIView.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        if let popUpUIView = popUpIndicatorUIView as? PopUpAble {
            return popUpUIView.getPopUpMessage()
        }
        
        return nil
    }
}

protocol PopUpAble {
    func getPopUpMessage() -> ObservableObject<PopUpMessage>
}

class InfoPopUpView: UIView, PopUpAble {
   
    let popupMessageObservable = ObservableObject<PopUpMessage>(nil)
    
    let popupUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let okButton: UIButton = {
       let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(tappedOkButton), for: .touchDown)
        return button
    }()
    
    let cancleButton: UIButton = {
       let button = UIButton()
        button.setTitle("Cancle", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(tappedCancleButton), for: .touchDown)
        return button
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"

        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "Content"

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawView() {
        self.layer.cornerRadius = 5
        self.backgroundColor = .systemGray.withAlphaComponent(0.5)
        
        self.addSubview(popupUIView)
        popupUIView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        popupUIView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        popupUIView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        popupUIView.addSubview(okButton)
        okButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview().offset(50)
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.1)
            
        }
        popupUIView.addSubview(cancleButton)
        cancleButton.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview().multipliedBy(1.5)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.1)
            
        }
    }
    
    @objc
    func tappedOkButton() {
        popupMessageObservable.value = PopUpMessage(type: .ok, data: nil)
        self.removeFromSuperview()
    }
    
    @objc
    func tappedCancleButton() {
        popupMessageObservable.value = PopUpMessage(type: .cancle, data: nil)
        self.removeFromSuperview()
    }
    
    func getPopUpMessage() -> ObservableObject<PopUpMessage> {
        return popupMessageObservable
    }
}

class LoadingPopUpView: UIView, PopUpAble {
   
    let popupMessageObservable = ObservableObject<PopUpMessage>(nil)
    
    let popupUIView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Title"

        return label
    }()
    
    let loadIndicatorView: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func drawView() {
        self.layer.cornerRadius = 5
        self.backgroundColor = .systemGray.withAlphaComponent(0.5)
        self.addSubview(popupUIView)
        
        popupUIView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        popupUIView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        popupUIView.addSubview(loadIndicatorView)
        loadIndicatorView.snp.makeConstraints{ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
    
    private func run() {
        loadIndicatorView.startAnimating()
        //runProcess

    }
    
    func stop() {
        loadIndicatorView.stopAnimating()
        self.removeFromSuperview()
    }
    
    
    func getPopUpMessage() -> ObservableObject<PopUpMessage> {
        run()
        return popupMessageObservable
    }
}
