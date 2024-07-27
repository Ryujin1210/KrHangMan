//
//  RankViewDataManager.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2022/12/29.
//

import Alamofire

class RankViewDataManager {
    //let url = Constant.Rank_URL
    //let myRankurl = Constant.MyRank_URL
    let url = Constant.getURLString(.GET_RANK)
    let myRankurl = Constant.getURLString(.GET_USER_RANK, AppManager.useUserDataService().getUserName())
    
    func searchRankingList(delegate: RankViewController) {
        AF.request(url, method: .get, parameters: nil, headers: nil )
            .responseDecodable(of:ResRank.self) { response in
                switch response.result {
                case .success(let response):
                    delegate.didRetrieveRanks(result: response)
                    print(response)
                case .failure(let error):
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다")
                    print(response)
                    print(error.localizedDescription)
                }
            }
    }
    
    func searchMyRanking(delegate: RankViewController) { // params 에 내부 db username 넣기
        AF.request(myRankurl, method: .get, parameters: nil,headers: nil)
            .responseDecodable(of:ResMyRank.self) { response in
                debugPrint(response)
                switch response.result {
                case.success(let response):
                    delegate.didRetrieveMyRanks(result: response)
                    print(response)
                case .failure(let error):
                    delegate.failedToRequest(message: "서버와의 연결이 원활하지 않습니다.")
                    print(error.localizedDescription)
                }
            }
    }
}


