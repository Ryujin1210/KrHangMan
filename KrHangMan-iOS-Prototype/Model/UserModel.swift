//
//  UserModel.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2023/01/10.
//

import Foundation

struct UserInfo : Codable {
    var username: String
}

struct ResUser: Codable {
    let code: Int
    let message: String
}

struct User : Codable {
    var username: String
    var correct_cnt : Int
    var etc1 : Int
    var etc2 : Int
    var etc3 : Int
}
