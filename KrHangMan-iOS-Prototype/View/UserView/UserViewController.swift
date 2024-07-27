//
//  UserViewController.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2023/01/05.
//

import UIKit

class UserViewController: UIViewController {
    
    var isCheck = false
    
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var UserTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var datamanager: UserViewDataManager = UserViewDataManager()
    
    // coredata
    var user = [UserEntity]()
    
    var UserName: String = ""
    
    var userInfo: ((UserInfo) -> Void)?
    
    var isValidName = false {
        didSet { //프로퍼티 옵저버
            self.validateUserInfo()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LoginBtn.isEnabled = false
        // login coredata check 
        checkUser()
        
        configureView()
        setupTextField()
        
        // coredata
        user = CoreDataManager.share.fetchUser()
        
        print(user.count)
        
        //데이터 삭제 시
        // deleteCoreData(a: 0)
        
    }
    // MARK: - 기능
    func configureView() {
        
        titleLabel.adjustsFontSizeToFitWidth = true
        UserTextField.adjustsFontSizeToFitWidth = true
        
        LoginBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        LoginBtn.layer.cornerRadius = 15
        setbackground()
    }
    
    func setbackground() {
        let backgroundImage = UIService.getBackgroundImg(backgroundView)
        backgroundView.backgroundColor = UIColor(patternImage: backgroundImage)
    }
    
    func validateUserInfo() {
        if isValidName {
            self.LoginBtn.isEnabled = true
            UIView.animate(withDuration: 0.33) {
                self.LoginBtn.backgroundColor = UIColor.darkGray
            }
        } else {
            self.LoginBtn.isEnabled = false
            UIView.animate(withDuration: 0.33) {
                self.LoginBtn.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    func gotoMain() {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "mainView") else {
            return
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func checkUser() {
        let user = CoreDataManager.share.fetchUser()
        if user.isEmpty == true {
           
        } else {
            gotoMain()
            popupAlert(title: user[0].username! + "님", message: "자동 로그인 되셨습니다.")
        }
    }
    
    
    
    // MARK: - Actions
    @objc
    func textFieldEditingChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        
        switch sender {
        case UserTextField:
            
            //print("username")
            self.isValidName = text.isValidUserName()
            self.UserName = text
            
        default:
            fatalError("TextField Error...")
        }
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        self.showIndicator()
        let userInfo = UserInfo(username: self.UserName)
        self.userInfo?(userInfo)
        datamanager.requestLogin(delegate: self, userInfo: userInfo)
        
    }
    
    // MARK: - coredata
    func saveCoreData() {
        let user = UserEntity(context: CoreDataManager.share.context)
        user.username = String(self.UserName)
        user.score = 0
        user.isRankUpdate = false
        user.isReGame = false
        user.inputWord = nil
        user.answer = nil
        CoreDataManager.share.saveContext()
    }
    
    func deleteCoreData(a:Int) {
        for i in 0...a {
            CoreDataManager.share.context.delete(user[i])
        }
        CoreDataManager.share.saveContext()
    }
    
    // MARK: - Helpers
    private func setupTextField() {
        // user 텍스트 필드 입력 액션 처리 연결
        UserTextField.addTarget(self,
                                action: #selector(textFieldEditingChanged(_:)),
                                for: .editingChanged)
        UserTextField.delegate = self
    }
    
    // MARK: - extension
    
}

extension String {
    func isValidUserName() -> Bool {
        let userExpression = "^[가-힣ㄱ-ㅎㅏ-ㅣA-Z0-9a-z]{2,10}$"
        let usernameValid = NSPredicate(format:"SELF MATCHES %@", userExpression)
        return usernameValid.evaluate(with: self)
    }
}

extension UserViewController {
    
    func SuccessLogin() {
        self.dismissIndicator()
        
        // 이동 할 곳
        gotoMain()
        // 로그인 성공 시 코어데이터 저장
        saveCoreData()
    }
    
    func failedLogin() {
        self.dismissIndicator()
        presentAlert(title: " 이미 사용중인 ID 입니다.")
        print("fail")
    }
    
    func failedServer() {
        self.dismissIndicator()
        presentAlert(title: " 서버 에러 발생!")
    }
}

extension UserViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
      return true
    }
}
