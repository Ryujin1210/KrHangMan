//
import Foundation
import UIKit

/*
 GameView - View 영역
 MainView 게임 시작버튼 클릭시 해당 화면 표출
 게임 진행 담당
*/


class GameViewController: UIViewController, ViewSetAble {
    
    // MARK: View Component
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var wordCollectionView: UICollectionView!
    @IBOutlet weak var keyboardCotainerView: UIView!
    
    
    
    let keyboardView: KeyboardView = {
        let view = KeyboardView()
        
        return view
    }()
    
    let helpPopupView: HelpPopupView = {
        let view = HelpPopupView()
        view.isHidden = true
        return view
    }()
    
    // MARK: Properties
    // Game Config 난이도 선택에 따른 설정
    var gameConfig: HangManGameConfig? = nil
    
    // GameView의 ViewModel
    var gameViewModel: GameViewModel? = nil    
    var gameViewExit: ((Bool) -> Void)? = nil
    // MARK: ViewController Cycle 재정의
    // 화면 표출 이전 configure 처리
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureEvent()
    }

    // 화면 표출 이후 configure 처리
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureGameViewModel()
        
    }
    
    // MARK: Configure Function
    // View에 관한 설정
    func configureView() {
        configureBackground()
        configureViewComponent()
        configureKeyboardView()
        configureHelpPopupView()
    }
    
    // View Event에 관한 설정
    func configureEvent() {
        backButton.addTarget(self, action: #selector(tappedBackButton), for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(tappedHelpButton), for: .touchUpInside)
    }
    
    // ViewModel 설정
    func configureGameViewModel() {
        guard let gameConfig = gameConfig else {
            return
        }
        guard let processingGameViewModel = AppManager.useUserDataService().processingGameViewModel else {
            gameViewModel = GameViewModel(gameConfig: gameConfig)
            configureBind()
            guard let gameViewModel = gameViewModel else {
                return
            }
            gameViewModel.loadQuestion()
            return
        }
        
        gameViewModel = processingGameViewModel
        configureBind()
    }
    
    
    // MARK: Configure Function - 내부
    // View 배경 설정
    func configureBackground() {
        let backgroundImage = AppManager.useUIService().getBackgroundImg(backgroundView)
        backgroundView.backgroundColor = UIColor(patternImage: backgroundImage)
    }
    
    // View 구성하는 Component 설정
    private func configureViewComponent() {
        backButton.setTitle("", for: .normal)
        helpButton.setTitle("", for: .normal)
        configureCollectionView()
    }
    
    // CollectionView 설정
    func configureCollectionView() {
        wordCollectionView.dataSource = self
        wordCollectionView.delegate = self
        wordCollectionView.backgroundColor = .clear
        
        let nibCell = UINib(nibName: "WordCollectionCell", bundle: nil)
        wordCollectionView.register(nibCell, forCellWithReuseIdentifier: "WordCollectionCell")
        
        let flowLayout: UICollectionViewFlowLayout
            flowLayout = UICollectionViewFlowLayout()
            flowLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 0, right: 5 )
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
        
        wordCollectionView.collectionViewLayout = flowLayout
    }
    
    // KeyboardView 설정
    func configureKeyboardView() {
        keyboardView.keyboardViewDelegate = self        
        keyboardCotainerView.addSubview(keyboardView)
        keyboardView.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // HelpPopupView 설정
    func configureHelpPopupView() {
        view.addSubview(helpPopupView)
        helpPopupView.snp.makeConstraints{ make in
           make.centerX.equalToSuperview()
           make.centerY.equalToSuperview()
           make.width.equalToSuperview()
           make.height.equalToSuperview()
       }
    }
    
    // MVVM 구현으로 인한 Bind 설정
    func configureBind() {
        print("GameViewController configureBind()")
        guard let gameViewModel = gameViewModel else {
            return
        }
        // GameView Event Bind : ShowPopupLoading, DismissPopupLoading ...
        gameViewModel.gameViewEventObservable.bind{ event in
            guard let event = event else {
                return
            }
            self.receiveGameViewModelEvent(event: event)
        }
        
        // InputWordInfos Bind : Keyboard 를 통한 입력 Word 정보
        gameViewModel.inputWordInfos
            .flatMap{ item in return item }
            .forEach{ inputWordInfo in
                inputWordInfo
                    .bind{ [weak self] info in
                    print("inputWordInfos bind()")
                    guard let info = info, let self = self else { return }
                        let position = info.position
                        let word = info.word
                        self.wordCollectionView.reloadItems(at: [IndexPath(item: position.columnIndex, section: position.rowIndex)])
                }
            }

        // usedChance Bind : 기회 사용
        gameViewModel.usedChanceObservable
            .bind{ [weak self] chance in
                guard let self = self, let chance = chance else { return }
                self.updateCollectionViewScroll(cursorRow: chance, cursorColumn: 0)
            }
    }
}

// MARK: View Event
extension GameViewController {
    @objc func tappedBackButton() {
        print("tappedBackButton")
        backToView()
    }
    
    @objc func tappedHelpButton() {
        print("tappedHelpButton")
        receiveGameViewModelEvent(event: .showHelpPopup)
        
    }
    
    private func backToView() {
        guard let gameViewExit = gameViewExit else {
            return
        }
        guard let gameViewModel = gameViewModel else {
            return
        }
        gameViewExit(true)
        AppManager.useUserDataService().setData(processingGameViewModel: gameViewModel)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func receiveGameViewModelEvent(event: GameViewModel.GameViewModelEvent) {
        print("GameView Event : \(event)")
        switch event {
        case .showLoadingPopup:
            showLoadingPopup()
        case .dismissLoadingPopup:
            unShownLoadingPopup()
        case .showSucessPopup:
            showSuccessPopup()
        case .showFailPopup:
            showFailPopup()
        case .shiftKeyBoard:
            keyboardView.convertShiftVersion()
        case .showNotFullPopup:
            showNotFullPopup()
        case .showAppErrorPopup:
            showAppErrorPopup()
        case .showNetworkErrorPopup:
            showNetworkErrorPopup()
        case .showHelpPopup:
            showHelpPopup()
        case . completeEvent:
            break
        }
    }
    
    private func showLoadingPopup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showIndicator()
        }
    }
    
    private func unShownLoadingPopup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dismissIndicator()
        }
    }
    
    private func showSuccessPopup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let gameViewModel = self.gameViewModel else { return }
            var message = ""
            if let word = gameViewModel.getAnswer() {
                message = "\(word.word) : \(word.mean)"
            }
            self.presentSucessAlert(title: "정답입니다!", message: message, preferredStyle: .alert
            ,homeHandler: { _ in
                gameViewModel.resetHangManGame(true)
                self.backToView()
            }, nextHandler: { _ in
                gameViewModel.resetHangManGame(true)
                self.keyboardView.keyCapButtonDictionarys.values.forEach{buttonView in
                    buttonView.keyCapButton.setInit()
                }
            })
        }
    }
    
    private func showFailPopup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let gameViewModel = self.gameViewModel else { return }
            self.presentFailAlsert(title: "실패입니다!",message: "다시 시도하는 경우 랭킹에 반영되지 않습니다.", preferredStyle: .alert
            , checkHandler: { _ in
                self.checkAnswerPopup()
            }, regameHandler: { _ in
                gameViewModel.resetHangManGame(false)
                self.keyboardView.keyCapButtonDictionarys.values.forEach{buttonView in
                    buttonView.keyCapButton.setInit()
                }
            })
        }
    }
    
    private func showNotFullPopup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presentAlert(title: "모든 칸을 채워주세요!")
        }
    }
    
    private func checkAnswerPopup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let gameViewModel = self.gameViewModel else { return }
            var message = ""
            if let word = gameViewModel.getAnswer() {
                message = "\(word.word) : \(word.mean)"
            }
            self.presentSucessAlert(title: "정답 확인!", message: message, preferredStyle: .alert
            ,homeHandler: { _ in
                self.backToView()
            }, nextHandler: { _ in
                gameViewModel.resetHangManGame(true)
                self.keyboardView.keyCapButtonDictionarys.values.forEach{buttonView in
                    buttonView.keyCapButton.setInit()
                }
            })
        }
    }
    
    private func showAppErrorPopup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presentAlert(title: "앱 오류! 게임 문의를 남겨주세요!", handler: { _ in
                self.backToView()
            })
        }
    }
    
    private func showNetworkErrorPopup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presentAlert(title: "네트워크 오류! 네트워크 상태를 확인해주세요!", handler: { _ in
                self.backToView()
            })
        }
    }
    
    private func showHelpPopup() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.helpPopupView.isHidden = false
            self.helpPopupView.configureBackground()
        }
    }
    
    private func updateCollectionViewScroll(cursorRow: Int, cursorColumn: Int) {
        var indexPath = IndexPath(item: cursorColumn, section: cursorRow)
        wordCollectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
}

// MARK: UICollection 요소 정의
extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let gameConfig = gameConfig else {
            return 0
        }
        return gameConfig.chance
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let gameConfig = gameConfig else {
            return 0
        }
        return gameConfig.wordCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let gameConfig = gameConfig else {
            return CGSize(width: 0, height: 0)
        }

        let frame = collectionView.frame
        let width: CGFloat = ( collectionView.frame.width / CGFloat(gameConfig.wordCount)) - 5
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WordCollectionCell", for: indexPath) as! WordCollectionCell
        let column = indexPath.item
        let row = indexPath.section
                
        if let gameViewModel = gameViewModel, let wordInfo = gameViewModel.getPositionWord(rowIndex: row, columnIndex: column){
            cell.uploadCell(wordInfo)
            keyboardView.drawUpdate(wordKey: wordInfo.word, status: wordInfo.status)
        }
        
        return cell
    }
}

// MARK: UIKeyboardView 요소 정의
extension GameViewController: KeyboardViewDelegate {
    func touchKeyboard(keyCap: KeyCap) {
        if let gameViewModel = gameViewModel {
            gameViewModel.inputKey(keyCap: keyCap)
        }
    }
}
