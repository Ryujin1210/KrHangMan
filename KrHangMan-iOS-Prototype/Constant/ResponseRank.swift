//
//  responseRank.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2022/12/29.
//

import Foundation


// MARK: - ResRank
struct ResRank: Codable {
    let addRank: [AddRank]
    let code: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case addRank = "add_rank"
        case code, message
    }
}

// MARK: - AddRank
struct AddRank: Codable {
    let username: String
    let correctCnt, ranking: Int

    enum CodingKeys: String, CodingKey {
        case username
        case correctCnt = "correct_cnt"
        case ranking
    }
}
// MARK: - ResMyRank
struct ResMyRank: Codable {
    let username: String
    let ranking, code: Int
    let message: String
}
