//
//  CoreDataService.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2023/01/13.
//

import Foundation

class UserDataService: ServiceAble {
    var user: UserEntity? = nil
    var processingGameViewModel: GameViewModel? = nil
    
    init() {
        let users = CoreDataManager.share.fetchUser()
        if(!users.isEmpty) {
            self.user = users[0]
            print("\(String(describing: user?.username)) is Info")
            print("userscore : \(String(describing: user?.score))")
            print("isRankUpdate : \(String(describing: user?.isRankUpdate))")

        }
    }
    
    func getUserName() -> String? {
        guard let user = user else {
            return nil
        }
        return user.username
    }
    
    func getUserScore() -> Int? {
        guard let user = user else {
            return nil
        }
        return Int(user.score)
    }
    
    func getIsRankUpdate() -> Bool? {
        guard let user = user else {
            return nil
        }
        return user.isRankUpdate
    }
    
    func getAnswer() -> String? {
        guard let user = user else {
            return nil
        }
        return user.answer
    }
    
    func getInputWord() -> String? {
        guard let user = user else {
            return nil
        }
        return user.inputWord
    }
    
    func getIsReGame() -> Bool? {
        guard let user = user else {
            return nil
        }
        return user.isReGame
    }
    
    
    func setData(userName: String? = nil, score: Int? = nil, isRankUpdate: Bool? = nil, isReGame: Bool? = nil, answer: String? = nil, inputWord: String? = nil, processingGameViewModel: GameViewModel? = nil) {
        guard let user = user else {
            print("UserDataService setData Error user is nil")
            return
        }
        
        if let userName = userName {
            print("backup userName : \(userName)")
            user.username = userName
        }
        
        if let score = score {
            print("backup score : \(score)")
            user.score = Int16(score)
        }
        
        if let isRankUpdate = isRankUpdate {
            print("backup isRankUpdate : \(isRankUpdate)")
            user.isRankUpdate = isRankUpdate
        }
        
        if let isReGame = isReGame {
            print("backup isReGame : \(isReGame)")
            user.isReGame = isReGame
        }
        
        if let answer = answer {
            print("backup answer : \(answer)")
            user.answer = answer
        }
        
        if let inputWord = inputWord {
            print("backup inputWord : \(inputWord)")
            user.inputWord = inputWord
        }
        
        if let processingGameViewModel = processingGameViewModel {
            print("backup gameViewModel")
            self.processingGameViewModel = processingGameViewModel
        }
    }
    
    func saveData() {
        CoreDataManager.share.saveContext()
    }
}
