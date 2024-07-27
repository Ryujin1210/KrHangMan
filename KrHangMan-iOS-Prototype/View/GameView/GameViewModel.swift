import Foundation

/*
 Game Status : 게임 상태를 나타냄
 initing :
 loading : apiService를 통해 데이터 load하는 상태
 proceeding : 게임 진행 상태
 */

/*
 GameViewModel - ViewModel 영역
 GameView의 로직 및 데이터를 포함
 */


class GameViewModel {
    
    enum GameViewModelEvent {
        case showLoadingPopup, dismissLoadingPopup, showSucessPopup, showFailPopup, showNotFullPopup, shiftKeyBoard, showNetworkErrorPopup, showAppErrorPopup, showHelpPopup, completeEvent
    }
    // MARK: Preperties
    let gameViewEventObservable = ObservableObject<GameViewModelEvent>(nil)
    //let isLoad = ObservableObject<Bool>(true)
    
    let usedChanceObservable = ObservableObject<Int>(0)
    var inputWordInfos: [[ObservableObject<InputWordInfo>]] = []
    
    var keyBoardPosition = Position()
    var hangmanGame: HangManGame
        
    
    init(gameConfig: HangManGameConfig) {
    
        self.hangmanGame = HangManGame(gameConfig: gameConfig)
        configureViewModel()
    }
    
    // MARK: Configure Function
    private func configureViewModel(){
        configureHangManGame()
        configureBindHangManGame()
    }
    
    private func configureHangManGame(){
        let chance = hangmanGame.gameConfig.chance
        let wordCount = hangmanGame.gameConfig.wordCount
        
        for rowIndex in 0..<chance {
            var rowArray: [ObservableObject<InputWordInfo>] = []
            for columnIndex in 0..<wordCount {
                let inputWordInfo = ObservableObject<InputWordInfo>(InputWordInfo(position: Position(rowIndex: rowIndex, columnIndex: columnIndex), status: .empty, word: ""))
                rowArray.append(inputWordInfo)
            }
            inputWordInfos.append(rowArray)
        }
    }
    
    func resetHangManGame(_ isNextQuestion: Bool) {
        resetInputWordInfos()
        if(isNextQuestion) {
            nextQuestion()
        }
        resetKeyboardCursor()
        resetChance(isReGame: !isNextQuestion)
        backupIsReGame(!isNextQuestion)
    }
    
    private func resetInputWordInfos() {
        inputWordInfos.flatMap{ element in
            return element
        }.forEach{ inputWordInfoObservable in
            guard let observable = inputWordInfoObservable.value else {
                return
            }
            inputWordInfoObservable.value = InputWordInfo(position: observable.position, status: .empty, word: "")
        }
    }
    
    private func resetChance(isReGame: Bool) {
        hangmanGame.reGame(isReGame)
        
        usedChanceObservable.value = 0
    }
    
    private func configureBindHangManGame(){
        hangmanGame.gameStatusObservable.bind{ [weak self] gameStatus in
            guard let self = self, let gameStatus = gameStatus else {
                return
            }
            switch(gameStatus) {
            case .initing:
                break
            case .requestQuestions:
                self.gameViewEventObservable.value = .showLoadingPopup
            case .sucessOfRequestQuestions:
                self.gameViewEventObservable.value = .dismissLoadingPopup
            case .networkErrorOfRequestQuestions:
                self.gameViewEventObservable.value = .showNetworkErrorPopup
            case .serverErrorOfRequestQuestions:
                self.gameViewEventObservable.value = .showAppErrorPopup
            case .processingOfGame:
                self.backupAnswer()
                break
            case .sucessOfGameClear:
                self.backupUpdateScore()
                self.gameViewEventObservable.value = .showSucessPopup
            case .failOfGameClear:
                self.gameViewEventObservable.value = .showFailPopup
            }
            self.gameViewEventObservable.value = .completeEvent
        }
        
//        hangmanGame.questionsObservable.bind{ [weak self] questions in
//            print(questions)
//            guard let self = self else {
//                return
//            }
//            if let questions = questions {
//                if(questions.count == 0 && self.hangmanGame.question == nil){
//                    self.loadQuestion()
//                }
//                else if(self.hangmanGame.question == nil){
//                    self.pickQuestion()
//                }
//            } else {
//                self.loadQuestion()
//                // 최초 configure 바인딩
//            }
//        }
    }
}

// MARK: Fucntion - Input
extension GameViewModel {
    // keyboardView에서 눌린 keyCap
    func inputKey(keyCap: KeyCap){
        if(hangmanGame.isRemainedChance()){
            let type = keyCap.getKeyType()
            switch type {
            case .wordKey:
                inputWordKey(key: keyCap)
            case .backspaceKey:
                inputBackspaceKey(key: keyCap)
            case .enterKey:
                inputEnterKey()
            case .shiftKey:
                inputShiftKey()
            default:
                print("")
            }
        }
    }
    
    func getAnswer() -> Word? {
        return hangmanGame.question
    }
    
    // word 버튼 입력 된 경우
    private func inputWordKey(key: KeyCap){
        cellInputWordInfo(keyCap: key)
        moveKeyboardCursor(moveRow: 0, moveColumn: 1)
    }
    
    // Backspace 버튼 입력 된 경우
    private func inputBackspaceKey(key: KeyCap){
        moveKeyboardCursor(moveRow: 0, moveColumn: -1)
        cellInputWordInfo(keyCap: key)
    }
    
    // Enter 버튼 입력 된 경우
    private func inputEnterKey(){
        if(answerCheck() != .notFull) {
            moveKeyboardCursor(moveRow: 1)
            backupInputWord()
           
        } else {
            gameViewEventObservable.value = .showNotFullPopup
        }
    }
    
    // Shift 버튼 입력 된 경우
    private func inputShiftKey(){
        gameViewEventObservable.value = .shiftKeyBoard
    }
}

// MARK: Function - Logic
extension GameViewModel {
    // 문제를 요청
    func loadQuestion() {
        print("loadQuestion start")
//        DispatchQueue.global().async { [weak self ] in
//            guard let self = self else { return }
//            self.hangmanGame.loadQuestion()
//        }
        if(isExistProcessingBackupGame()) {
            applyProcessingBackupGame()
        }
        else {
            hangmanGame.loadQuestion()
        }
        print("loadQuestion end")
    }
    
    private func nextQuestion() {
        hangmanGame.pickQuestion()
        backupAnswer()
    }
//    private func loadQuestion() {
//        gameStatusObservable.value = .loading
//        DispatchQueue.main.async {
//            self.hangmanGame.loadQuestion()
//        }
//    }
    
    // Load 된 문제들을 통해 한 문제를 Pick
//    private func pickQuestion() {
//        gameStatusObservable.value = .loadComplete
//        hangmanGame.pickQuestion()
//    }
    private func resetKeyboardCursor(){
        keyBoardPosition = Position()
    }
    // KeyboardView Keyboard가 눌릴 때마다 cursor position 이동
    private func moveKeyboardCursor(moveRow: Int = 0, moveColumn: Int = 0){
        let gameConfig = hangmanGame.gameConfig
        
        let cursorRow = keyBoardPosition.rowIndex
        let cursorColumn = keyBoardPosition.columnIndex

        let willMoveRow = cursorRow + moveRow
        let willMoveColumn = cursorColumn + moveColumn
        if(moveRow != 0 && willMoveRow >= 0 && willMoveRow < gameConfig.chance){
            keyBoardPosition.moveToRow(moveRow)
            keyBoardPosition.moveToColumn(-cursorColumn)
        }

        if(moveColumn != 0 && willMoveColumn >= 0 && willMoveColumn <= gameConfig.wordCount){
            keyBoardPosition.moveToColumn(moveColumn)
        }
    }
    
    // 
    private func cellIsUpdate(keyType: KeyCap.KeyType) -> Bool{
        let gameConfig = hangmanGame.gameConfig

        let cursorRow = keyBoardPosition.rowIndex
        let cursorColumn = keyBoardPosition.columnIndex

        switch keyType {
        case .wordKey :
            if( hangmanGame.getInputLength() == gameConfig.wordCount){
                return false
            }
        case .backspaceKey :
            if(cursorColumn < 0) {
                return false
            }
        default :
                return true
        }
        
        if(cursorRow == gameConfig.chance){
            return false
        }
        
        return true
    }
    
    private func cellInputWordInfo(keyCap: KeyCap){
        let cursorPosition = keyBoardPosition
        var wordStatus = InputWordInfo.InputStatus.none
        var word = ""
        
        let keyType = keyCap.getKeyType()
        if(cellIsUpdate(keyType: keyType)) {
            if(keyType == .wordKey) {
                word = keyCap.getWord()
                wordStatus = .input
                hangmanGame.input(word: word)
            }
            else if(keyType == .backspaceKey) {
                wordStatus = .empty
                hangmanGame.inputs.popLast()
            }
            inputWordInfos[cursorPosition.rowIndex][cursorPosition.columnIndex].value = InputWordInfo(position: cursorPosition, status: wordStatus, word: word)
        }
    }
 
    func getPositionWord(rowIndex: Int, columnIndex: Int) -> InputWordInfo? {
        guard let wordInfo = inputWordInfos[rowIndex][columnIndex].value else {
            return nil
        }
        return wordInfo
    }
    
    func updatePositionWord(inputWord: InputWordInfo) {
        let rowIndex = inputWord.position.rowIndex
        let columnIndex = inputWord.position.columnIndex
        inputWordInfos[rowIndex][columnIndex].value = inputWord
    }
    
    func answerCheck() -> CheckMessage.CheckType {
        let checkMessage =  hangmanGame.answer()
        
        switch checkMessage.messageType {
        case .notFull:
            // input에 단어가 다 채워지지 않음
            break
        case .check, .succuess, .fail:
            // input에 단어가 다 채워졌으며 기회가 남아있어 체크 결과를 받음
            applyCheckResult(checkMessage.checkResult)
            checkRemainChance()
        }
        return checkMessage.messageType
    }
    
    private func applyCheckResult(_ checkResult: [InputWordInfo.InputStatus]) {
        let cursorRow = keyBoardPosition.rowIndex

        checkResult.enumerated().forEach{ (index, status) in
            if var inputWord = getPositionWord(rowIndex: cursorRow, columnIndex: index){
                inputWord.status = status
                updatePositionWord(inputWord: inputWord)
            }
        }
    }
    
    private func checkRemainChance() {
        guard let preChance = usedChanceObservable.value else {
            return
        }
        let curChance = hangmanGame.chanceCount
        
        if(preChance != curChance && hangmanGame.isRemainedChance()) {
            usedChanceObservable.value = curChance
        }
    }
    
    // 문제 최초 성공 시 스코어 증가
    private func backupUpdateScore() {
//        guard var score = AppManager.useAppDataService().getData(dataName: .score) as? Int16 else {
//            return
//        }
//
//        score += 1
//        AppManager.useAppDataService().setData(dataName: .score, data: score)
//        AppManager.useAppDataService().setData(dataName: .isUpdateRank, data: true)
        if(hangmanGame.isReGame == false) {
            guard var score = AppManager.useUserDataService().getUserScore() else{
                return
            }
            backupUserData(score: score + 1, isRankUpdate: true)
        }
    }
    
    private func backupAnswer() {
        if let word = hangmanGame.question {
            let answer = "\(word.word)|\(word.mean)|\(word.spell.joined(separator: ","))"
            backupUserData(answer: answer)
            backupInputWord()
        }
    }
    
    private func backupIsReGame(_ isReGame: Bool) {
        backupUserData(isRemGame: isReGame)
        backupAnswer()
        backupInputWord()
    }
    
    private func backupInputWord() {
        backupUserData(inputWord: hangmanGame.totalInputs.joined(separator: ","))
    }
    
    private func backupUserData(userName: String? = nil , score: Int? = nil, isRankUpdate: Bool? = nil, isRemGame: Bool? = nil, answer:String? = nil, inputWord: String? = nil ,processingGameViewModel: GameViewModel? = nil) {
        AppManager.useUserDataService().setData(userName: userName, score: score, isRankUpdate: isRankUpdate, isReGame: isRemGame, answer: answer, inputWord: inputWord, processingGameViewModel: processingGameViewModel)
    }
    
    private func isExistProcessingBackupGame() -> Bool {
        guard let answer = AppManager.useUserDataService().getAnswer() else {
            return false
        }
        guard let inputWord = AppManager.useUserDataService().getInputWord() else {
            return false
        }
        return true
    }
    
    private func applyProcessingBackupGame() {
        guard let answer = AppManager.useUserDataService().getAnswer() else {
            return
        }
        guard let inputWord = AppManager.useUserDataService().getInputWord() else {
            return
        }
        guard let isReGame = AppManager.useUserDataService().getIsReGame() else {
            return
        }
        
        let backupWord = String(answer.split(separator: "|")[0])
        let backupMean = String(answer.split(separator: "|")[1])
        let backupSpell = String(answer.split(separator: "|")[2]).split(separator: ",").map{
            return String($0)
        }
        
        let backupInputs = inputWord.split(separator: ",").map{
            return String($0)
        }
        
        hangmanGame.question = Word(word: backupWord, mean: backupMean, spell: backupSpell)
        hangmanGame.isReGame = isReGame
        
        if(backupInputs.isEmpty == false) {
            for index in 0..<backupInputs.count {
                let cursorPosition = keyBoardPosition
                let inputWord = backupInputs[index]
                moveKeyboardCursor(moveRow: 0, moveColumn: 1)
                hangmanGame.input(word: backupInputs[index])
                inputWordInfos[cursorPosition.rowIndex][cursorPosition.columnIndex].value = InputWordInfo(position: cursorPosition, status: .input, word: inputWord)
                if((index + 1) % hangmanGame.gameConfig.wordCount == 0) {
                    inputEnterKey()
                }

            }
        }
    }
}
