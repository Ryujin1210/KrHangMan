//
//  APIServcie.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2022/12/29.
//

import Foundation
import Alamofire



class APIService: ServiceAble{

    enum APIError {
        case DECODE_ERROR, NETWORK_ERROR
    }
    
    func requestGet<T: Decodable>(urlString: String, type: T.Type, completion: @escaping (T?, APIError?)->Void) {
        if let url = URL(string: urlString) {
            sleep(1)
            AF.request(url, method: .get, parameters: [:]).response{ responseData in
                let decoder = JSONDecoder()
                switch responseData.result {
                case let .success(data):
                    do {
                        if let data = data {
                            let decodingData = try decoder.decode(type, from: data)
                            completion(decodingData, nil)
                        }
                    }
                    catch {
                        print("DECODE ERROR API 및 데이터 구조를 확인하세요.")
                        completion(nil, .DECODE_ERROR)
                    }
                case let .failure(error):
                    print("네트워크 오류 네트워크 및 서버 상태를 확인하세요.")
                    completion(nil, .NETWORK_ERROR)
                }
            }
        }
    }
    
    func requestPatch<T: Encodable>(urlString: String, parameter: T, completion: @escaping (Int?) -> Void) {
        if let url = URL(string: urlString) {
            AF.request(url,
                       method: .patch,
                       parameters: parameter,
                       encoder: JSONParameterEncoder.default).response { response in
                completion(response.response?.statusCode)
                debugPrint(response)
            }
        }
       
    }
}
