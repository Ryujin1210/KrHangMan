//
//  UserViewDataManager.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2023/01/10.
//

import Alamofire

class UserViewDataManager {
    let url = Constant.getURLString(.GET_USER)
    
    func requestLogin(delegate: UserViewController, userInfo: UserInfo) {
        
        AF.request(url,method: .post,parameters: userInfo, headers: nil)
            .responseDecodable(of:ResUser.self) { response in
                
                switch response.result {
                case .success(let response):
                    switch response.code {
                    case 202:
                        delegate.SuccessLogin()
                        print(response)
                    case 203:
                        delegate.failedLogin()
                        print(response)
                    default:
                        delegate.failedServer()
                        print(response)
                    }

                case .failure(let error):
                    print(error.localizedDescription)
                    delegate.failedServer()
                }
        }
    }
}
