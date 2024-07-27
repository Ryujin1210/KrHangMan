//
//  UserEntity+CoreDataProperties.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2023/01/11.
//
//

import Foundation
import CoreData


extension UserEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var username: String?
    @NSManaged public var answer: String?
    @NSManaged public var inputWord: String?
    @NSManaged public var score: Int16
    @NSManaged public var isRankUpdate: Bool
    @NSManaged public var isReGame: Bool

    

}

extension UserEntity : Identifiable {

}
