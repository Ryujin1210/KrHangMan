import UIKit

/*
MainView - View 영역
앱 구동시 초기 화면
앱명을 나타내는 타이틀 라벨
게임시작 버튼을 통한 화면 전환
랭크확인 버튼을 통한 화면 전환
*/

class MainViewController: UIViewController, ViewSetAble {
  
    // MARK: View Component
    @IBOutlet weak var gameStartButton: UIButton!
    @IBOutlet weak var showRankButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: Properties
    // Page를 나타내는 enum
    enum ViewPage {
        case gameView, rankView
        // 화면 전환을 위함 , storyboard에서 설정과 일치해야한다.
        var viewControllerIdentifier: String {
            get {
                switch(self){
                case .gameView:
                    return "GameViewController"
                case .rankView:
                    return "RankViewController"
                }
            }
        }
    }
    
    enum MainViewEvent {
        case reViewDidLoad
    }
    
    var mainViewModel: MainViewModel? = nil
    
    // MARK: ViewController Cycle 재정의
    override func viewDidLoad() {
        print("MainView viewDidLod")
        super.viewDidLoad()
        configureView()
        configureEvent()
        configureBind()
        configureViewModel()
    }
    
    // MARK: Configure Function
    func configureView() {
        configureBackground()
        titleLabel.adjustsFontSizeToFitWidth = true
        gameStartButton.titleLabel?.adjustsFontSizeToFitWidth = true
        gameStartButton.layer.cornerRadius = 15
        showRankButton.titleLabel?.adjustsFontSizeToFitWidth = true
        showRankButton.layer.cornerRadius = 15
    }
    
    func configureEvent() {
      
    }
    
    func configureBind() {
        
    }
    
    func configureViewModel() {
        mainViewModel = MainViewModel()
    }
    
    // MARK: Configure Function - 내부
    private func configureBackground() {
        let backgroundImage = UIService.getBackgroundImg(backgroundView)
        backgroundView.backgroundColor = UIColor(patternImage: backgroundImage)
    }

}

extension MainViewController {
    // MARK: View Event?
    // storyboard segue를 통해 화면전환
    // segue 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGameViewSegue" {
            if let gameViewController = segue.destination as? GameViewController {
                gameViewController.gameConfig = HangManGameConfig(gameLevel: .beginner)
                gameViewController.gameViewExit = reViewDidLoad
            }
        }
    }
    
    func reViewDidLoad(isExit: Bool) {
        guard let mainViewModel = mainViewModel else {
            return
        }
        mainViewModel.receiveViewEvent(.reViewDidLoad)
    }
}


