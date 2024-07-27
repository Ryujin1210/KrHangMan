//
//  UIViewController.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2023/01/02.
//

import UIKit

extension UIViewController {
    // MARK: - alert 기능
    func presentAlert(title: String, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      handler: ((UIAlertAction) -> Void)? = nil) {
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let actionDone = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(actionDone)
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentSucessAlert(title: String, message: String? = nil,
                            preferredStyle style: UIAlertController.Style = .alert,
                            homeHandler: ((UIAlertAction) -> Void)? = nil , nextHandler: ((UIAlertAction) -> Void)? = nil) {
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let actionHome = UIAlertAction(title: "홈으로", style: .default, handler: homeHandler)
        let actionNext = UIAlertAction(title: "다음문제", style: .default, handler: nextHandler)
        alert.addAction(actionHome)
        alert.addAction(actionNext)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentFailAlsert(title: String, message: String? = nil,
                           preferredStyle style: UIAlertController.Style = .alert,
                           checkHandler: ((UIAlertAction) -> Void)? = nil , regameHandler: ((UIAlertAction) -> Void)? = nil) {
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let actionCheck = UIAlertAction(title: "정답확인", style: .default, handler: checkHandler)
        let actionRegame = UIAlertAction(title: "다시풀기", style: .default, handler: regameHandler)
        alert.addAction(actionCheck)
        alert.addAction(actionRegame)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func popupAlert(title: String, message: String? = nil, preferredStyle style: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)})
    }
    
    // MARK: - 인디케이터 표시
    func showIndicator() {
        IndicatorView.shared.show()
        IndicatorView.shared.showIndicator()
    }
    
    // MARK: - 인디케이터 숨김
    func dismissIndicator() {
        IndicatorView.shared.dismiss()
    }
}

// MARK: - 인디케이터
open class IndicatorView {
    static let shared = IndicatorView()
    
    let containerView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    open func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let scene = UIApplication.shared.connectedScenes
        let windowScene = scene.first as? UIWindowScene
        let windows = windowScene?.windows.first
        
        self.containerView.frame = window.frame
        self.containerView.center = window.center
        self.containerView.backgroundColor = .clear
        
        self.containerView.addSubview(self.activityIndicator)
        windows?.addSubview(self.containerView)
        //UIApplication.shared.windows.first?.addSubview(self.containerView)
    }
    
    open func showIndicator() {
        self.containerView.backgroundColor = UIColor(white: 0x000000, alpha: 0.4)
        
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.activityIndicator.style = .large
        self.activityIndicator.color = UIColor(white: 0x808080, alpha: 0.4)
        self.activityIndicator.center = self.containerView.center
        
        self.activityIndicator.startAnimating()
    }
    
    open func dismiss() {
        self.activityIndicator.stopAnimating()
        self.containerView.removeFromSuperview()
    }
}

