//
//  APIParameter.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2023/01/12.
//

import Foundation

struct FetchRankParameter: Codable {
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case count = "correct_cnt"
    }
}
