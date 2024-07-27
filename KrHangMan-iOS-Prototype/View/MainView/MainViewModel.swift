//
//  MainViewModel.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2023/01/12.
//

import Foundation

class MainViewModel {
    
    
    
    func receiveViewEvent(_ event: MainViewController.MainViewEvent) {
        print("MainViewEvent Occur \(event)")
        switch event {
        case .reViewDidLoad:
            receiveReViewDidLoad()
            
        }
    }

    
    private func receiveReViewDidLoad() {

        patchUpdateRank()
    }
    
    
    
    private func patchUpdateRank() {
        guard let isRankUpdate = AppManager.useUserDataService().getIsRankUpdate() else {
            return
        }
        
        if(isRankUpdate) {
            guard let score  = AppManager.useUserDataService().getUserScore() else {
                return
            }
            guard let userName = AppManager.useUserDataService().getUserName() else {
                return
            }
            let parameter = FetchRankParameter(count: score)
            let urlString = Constant.getURLString(.PATCH_RANK, AppManager.useUserDataService().getUserName())
            
            AppManager.useAPIService().requestPatch(urlString: urlString, parameter: parameter) { statusCode in
                guard let statusCode = statusCode else {
                    return
                }
                if(statusCode == 200) {
                    AppManager.useUserDataService().setData(isRankUpdate: false)
                    AppManager.useUserDataService().saveData()
                }
            }
        }
    }
    
    
}
