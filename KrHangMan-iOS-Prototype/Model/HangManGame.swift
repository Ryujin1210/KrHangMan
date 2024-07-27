//
//  HangManGameService.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2022/12/29.
//

import Foundation


enum GameStatus {
    case initing, requestQuestions, serverErrorOfRequestQuestions, networkErrorOfRequestQuestions, sucessOfRequestQuestions, processingOfGame, sucessOfGameClear, failOfGameClear
}

class HangManGame {
    
    var gameConfig: HangManGameConfig
    //var questionsObservable = ObservableObject<[Word]>(nil)
    var gameStatusObservable = ObservableObject<GameStatus>(nil)
    
    
    var questions: [Word] = [] {
        didSet(oldValue) {
            print( "Question : \(oldValue) -> \(questions)")
        }
    }
    var question: Word? = nil {
        didSet(oldValue) {
            guard let question = question else { return }
            print( "Question : \(oldValue) -> \(question)")
        }
    }
    var chanceCount: Int = 0 {
        didSet(oldValue) {
            print( "ChanceCount : \(oldValue) -> \(chanceCount)")
        }
    }
    var totalInputs: [String] = []
    
    var inputs: [String] = [] {
        didSet {
            print("inputs : \(inputs)")
            if let newInput = inputs.last {
                totalInputs.append(newInput)
            }
        }
    }
    
    var isReGame: Bool = false {
        didSet {
            print("Hangman Game isReGame : \(isReGame)")
        }
    }
    
    init(gameConfig: HangManGameConfig){
        self.gameConfig = gameConfig
        gameStatusObservable.value = .initing
    }
    
    func loadQuestion() {
        self.gameStatusObservable.value = .requestQuestions
        let urlString = Constant.getURLString(.GET_WORD)
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            AppManager.useAPIService().requestGet(urlString: urlString, type: WordAPIModel.self) { data, apiError in
                if(apiError == nil) {
                    if let data = data  {
                        let items = data.wordList
                        self.questions = items.map { element in return element.convertModel() }
                        self.pickQuestion()
                        self.gameStatusObservable.value = .sucessOfRequestQuestions
                    }
                    else {
                        self.gameStatusObservable.value = .serverErrorOfRequestQuestions
                        // 메시지 형식 및 디코더 에러
                    }
                }
                else {
                    self.gameStatusObservable.value = .networkErrorOfRequestQuestions
                    // 네트워크에러
                }
            }
        }
    }
    
    func pickQuestion() {

        if(questions.count == 0) {
            loadQuestion()
        }
        else {
            question = questions.popLast()
            //self.questions = questions
        }
        self.gameStatusObservable.value = .processingOfGame
    }
    
    func getInputLength() -> Int {
        return inputs.count
    }
    
    func input(word: String) {
        inputs.append(word)
    }
    
    func answer() -> CheckMessage {
        var checkResult: [InputWordInfo.InputStatus] = []
        
        var messageType: CheckMessage.CheckType
        if(checkIsInput()) {
            checkResult = checkOfInputsUnit()
            messageType = checkOfInputsResult(checkResult)
            useChance()
            
        } else {
            messageType = .notFull
        }
        return CheckMessage(messageType: messageType, checkResult: checkResult)
    }
    
    func checkIsInput() -> Bool {
        if(inputs.count == gameConfig.wordCount) {
            return true
        } else {
            return false
        }
    }
    
    private func checkOfInputsUnit() -> [InputWordInfo.InputStatus] {
        var checkResult: [InputWordInfo.InputStatus] = []
        guard let question = question else {
            return checkResult
        }
        
        inputs.enumerated().forEach{ (index, input) in
            if(question.spell[index] == input) {
                checkResult.append(.match)
            } else if(question.spell.contains(input)) {
                checkResult.append(.contain)
            } else {
                checkResult.append(.miss)
            }
        }
        
        return checkResult
    }
    
    private func checkOfInputsResult(_ infoStatus: [InputWordInfo.InputStatus]) -> CheckMessage.CheckType {
        var checkType = CheckMessage.CheckType.check
        var isSuccess = false
        
        let matchCount = infoStatus.filter{ status in
            return status == .match
        }.count
        if(matchCount == gameConfig.wordCount){
            isSuccess = true
            checkType = .succuess
            
            gameStatusObservable.value = .sucessOfGameClear
        }
        if(isSuccess == false){
            if(chanceCount + 1 == gameConfig.chance){
                checkType = .fail
                gameStatusObservable.value = .failOfGameClear
            }
        }
        
        return checkType
    }
    
    func reGame(_ isReGame: Bool) {
        self.chanceCount = 0
        self.isReGame = isReGame
        self.totalInputs = []
    }
    
    private func useChance() {
        chanceCount += 1
        inputs = []
    }
    
    func isRemainedChance() -> Bool {
        let maxChance = gameConfig.chance
        
        return chanceCount != maxChance
    }
    
}

// MARK: Object
struct HangManGameConfig {
    enum GameLevel {
        case beginner, intermediate, advanced
    }
    let gameLevel: GameLevel
    
    var chance: Int {
        switch gameLevel {
        case .beginner:
            return 6
        case .intermediate:
            return 6
        case .advanced:
            return 6
        }
    }
    
    var wordCount: Int {
        switch gameLevel {
        case .beginner:
            return 5
        case .intermediate:
            return 5
        case .advanced:
            return 5
        }
    }
}


struct Word{
    let word: String
    let mean: String
    let spell: [String]
}

struct InputWordInfo{
    enum InputStatus {
        case none, empty, input, contain, match, miss
    }
    var position: Position
    var status: InputStatus
    var word: String
}

struct Position{
    var rowIndex = 0 {
        didSet(oldValue) {
            print("Chnage Point (\(oldValue), \(columnIndex)) -> (\(rowIndex), \(columnIndex))")
        }
    }
    var columnIndex = 0 {
        didSet(oldValue) {
            print("Chnage Point (\(rowIndex), \(oldValue)) -> (\(rowIndex), \(columnIndex))")
        }
    }
    
    mutating func moveToRow(_ move: Int) {
        rowIndex += move
    }
    
    mutating func moveToColumn(_ move: Int) {
        columnIndex += move
    }
}

struct CheckMessage{
    enum CheckType {
        case succuess, fail, check, notFull
    }
    let messageType: CheckType
    let checkResult: [InputWordInfo.InputStatus]
}

