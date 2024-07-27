//
//  KeyboardView.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2022/12/26.
//

import UIKit
import SnapKit

struct KeyCap: Hashable {
    enum ShiftOnOff {
        case off, on
    }
    enum KeyType {
        case noneKey, wordKey, shiftKey, backspaceKey, enterKey
    }
    
    let capWord: String
    let shiftWord: String
    let capLength: Double
    
    var shiftStatus: ShiftOnOff

    init(){
        self.capWord = ""
        self.shiftWord = ""
        self.capLength = 0
        self.shiftStatus = .off
    }
    
    init(capWord: String, shiftWord: String, capLength:Double ){
        self.capWord = capWord
        self.shiftWord = shiftWord
        self.capLength = capLength
        self.shiftStatus = .off
    }
    
    mutating func applyShift() -> String {
        switch shiftStatus {
        case .off:
            shiftStatus = .on
            return getWord()
        case .on:
            shiftStatus = .off
            return getWord()
        }
    }
    
    func getWord() -> String {
        switch shiftStatus {
        case .off:
            return capWord
        case .on:
            return shiftWord
        }
    }
    
    func getKeyType() -> KeyType {
        switch capWord.uppercased() {
        case "":
            return .noneKey
        case "SHIFT":
            return .shiftKey
        case "ENTER":
            return .enterKey
        case "←":
            return .backspaceKey
        default:
            return .wordKey
        }
    }
}

class KeyCapButton: UIButton {

    var keyCap: KeyCap

    override init(frame: CGRect) {
        self.keyCap = KeyCap()
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(keyCap: KeyCap) {
        self.keyCap = keyCap
        super.init(frame: .zero)
        configureButton()
    }

    func convertShiftVersion() {
        self.setTitle(keyCap.applyShift(), for: .normal)
    }
    
    private func configureButton() {
        self.titleLabel?.numberOfLines = 1
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleLabel?.lineBreakMode = .byClipping
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 5
        self.setTitle(keyCap.getWord(), for: .normal)
    }
    
    func setInit() {
        self.backgroundColor = .darkGray
        if(keyCap.shiftStatus == .on) {
            self.setTitle(keyCap.applyShift(), for: .normal)
        }
    }
}

class KeyCapButtonView: UIView {
    
    enum Position {
        case none, top, middle, bottom
    }
    
    let keyCapButton: KeyCapButton
    let position: Position
    let index: Int
    
    var isUpdate: Bool = false

    override init(frame: CGRect) {
        self.keyCapButton = KeyCapButton()
        self.position = .none
        self.index = 0
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(keyCap: KeyCap, position: Position, index: Int) {
        self.keyCapButton = KeyCapButton(keyCap: keyCap)
        self.position = position
        self.index = index
        super.init(frame: .zero)
        configureView()
    }
    
    func convertShiftVersion() {
        keyCapButton.convertShiftVersion()
    }
    
    func getKeyCap() -> KeyCap {
        return keyCapButton.keyCap
    }
    
    private func configureView() {
        self.addSubview(keyCapButton)
        keyCapButton.snp.makeConstraints{ make in
            make.edges.equalTo(UIEdgeInsets(top: 2.5, left: 1, bottom: 2.5, right: 1))
        }
    }
}

protocol KeyboardViewDelegate {
    func touchKeyboard(keyCap: KeyCap)
}

class KeyboardView: UIStackView {
    
    var keyboardViewDelegate: KeyboardViewDelegate?
    
    let containerTopView: UIStackView = {
       let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let containerMiddleView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let containerBottomView: UIStackView = {
       let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .horizontal
        
        return stackView
    }()
    
    let keyCapButtonDictionarys: [String: KeyCapButtonView] = ["ㅂ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅂ", shiftWord: "ㅃ", capLength: 1), position: .top, index: 0), "ㅈ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅈ", shiftWord: "ㅉ", capLength: 1), position: .top, index: 1), "ㄷ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㄷ", shiftWord: "ㄸ", capLength: 1), position: .top, index: 2), "ㄱ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㄱ", shiftWord: "ㄲ", capLength: 1), position: .top, index: 3), "ㅅ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅅ", shiftWord: "ㅆ", capLength: 1), position: .top, index: 4), "ㅛ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅛ", shiftWord: "ㅛ", capLength: 1), position: .top, index: 5), "ㅕ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅕ", shiftWord: "ㅕ", capLength: 1), position: .top, index: 6), "ㅑ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅑ", shiftWord: "ㅑ", capLength: 1), position: .top, index: 7), "ㅐ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅐ", shiftWord: "ㅒ", capLength: 1), position: .top, index: 8), "ㅔ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅔ", shiftWord: "ㅖ", capLength: 1), position: .top, index: 9), "←":  KeyCapButtonView(keyCap: KeyCap(capWord: "←", shiftWord: "←", capLength: 1), position: .top, index: 10), "leftBlank": KeyCapButtonView(keyCap: KeyCap(capWord: "", shiftWord: "", capLength: 0.5), position: .middle, index: 0), "ㅁ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅁ", shiftWord: "ㅁ", capLength: 1), position: .middle, index: 1),  "ㄴ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㄴ", shiftWord: "ㄴ", capLength: 1), position: .middle, index: 2), "ㅇ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅇ", shiftWord: "ㅇ", capLength: 1), position: .middle, index: 3), "ㄹ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㄹ", shiftWord: "ㄹ", capLength: 1), position: .middle, index: 4), "ㅎ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅎ", shiftWord: "ㅎ", capLength: 1), position: .middle, index: 5), "ㅗ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅗ", shiftWord: "ㅗ", capLength: 1), position: .middle, index: 6), "ㅓ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅓ", shiftWord: "ㅓ", capLength: 1), position: .middle, index: 7), "ㅏ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅏ", shiftWord: "ㅏ", capLength: 1), position: .middle, index: 8), "ㅣ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅣ", shiftWord: "ㅣ", capLength: 1), position: .middle, index: 9), "rightBlank": KeyCapButtonView(keyCap: KeyCap(capWord: "", shiftWord: "", capLength: 0.5), position: .middle, index: 10),"Shift": KeyCapButtonView(keyCap: KeyCap(capWord: "Shift", shiftWord: "Shift", capLength: 2), position: .bottom, index: 0), "ㅋ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅋ", shiftWord: "ㅋ", capLength: 1), position: .bottom, index: 1), "ㅌ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅌ", shiftWord: "ㅌ", capLength: 1), position: .bottom, index: 2), "ㅊ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅊ", shiftWord: "ㅊ", capLength: 1), position: .bottom, index: 3), "ㅍ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅍ", shiftWord: "ㅍ", capLength: 1), position: .bottom, index: 4), "ㅠ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅠ", shiftWord: "ㅠ", capLength: 1), position: .bottom, index: 5), "ㅜ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅜ", shiftWord: "ㅜ", capLength: 1), position: .bottom, index: 6), "ㅡ": KeyCapButtonView(keyCap: KeyCap(capWord: "ㅡ", shiftWord: "ㅡ", capLength: 1), position: .bottom, index: 7), "Enter": KeyCapButtonView(keyCap: KeyCap(capWord: "Enter", shiftWord: "Enter", capLength: 2), position: .bottom, index: 8)]
    
    var topRowKeyCapButtons: [KeyCapButtonView] = []
    
    var middelRowCapButtons: [KeyCapButtonView] = []
    
    var bottomRowCapButtons: [KeyCapButtonView] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.distribution = .fillEqually
        self.axis = .vertical
        configureButtons()
        drawKeyboard()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureButtons() {
        keyCapButtonDictionarys.values.forEach{ [weak self] buttonView in
            let position = buttonView.position
            switch position {
            case .top:
                topRowKeyCapButtons.append(buttonView)
            case .middle:
                middelRowCapButtons.append(buttonView)
            case .bottom:
                bottomRowCapButtons.append(buttonView)
            default:
                break
            }
            
            topRowKeyCapButtons = topRowKeyCapButtons.sorted(by: {$0.index < $1.index})
            middelRowCapButtons = middelRowCapButtons.sorted(by: {$0.index < $1.index})
            bottomRowCapButtons = bottomRowCapButtons.sorted(by: {$0.index < $1.index})

            buttonView.keyCapButton.addTarget(self, action: #selector(touchKeyCapButton(_:)), for: .touchDown)
        }
    }
    
    func drawKeyboard() {
        drawRowKeyboard(rowKeyCaps: topRowKeyCapButtons, containerView: containerTopView)
        drawRowKeyboard(rowKeyCaps: middelRowCapButtons, containerView: containerMiddleView)
        drawRowKeyboard(rowKeyCaps: bottomRowCapButtons, containerView: containerBottomView)

    }
    
    func drawRowKeyboard(rowKeyCaps: [KeyCapButtonView], containerView: UIStackView){
        self.addArrangedSubview(containerView)
        containerView.snp.makeConstraints{ make in
            make.width.equalToSuperview()
        }
        let rowCapLengthSum = rowKeyCaps.reduce(into: 0.0, { preResult , capButton in
            let keyCap = capButton.getKeyCap()
            return preResult += keyCap.capLength
        })
        
        rowKeyCaps.forEach{ keyCapButton in
            containerView.addArrangedSubview(keyCapButton)
            let keyCap = keyCapButton.getKeyCap()
            let capLength = keyCap.capLength
            keyCapButton.snp.makeConstraints{ make in
                make.width.equalToSuperview().multipliedBy(capLength / rowCapLengthSum)
            }
        }
    }
    
    
}

// View Function
extension KeyboardView {
    func convertShiftVersion() {
        
        topRowKeyCapButtons.forEach{ keycapButton in
            keycapButton.convertShiftVersion()
        }
        
        middelRowCapButtons.forEach{ keycapButton in
            keycapButton.convertShiftVersion()
        }
        
        bottomRowCapButtons.forEach{ keycapButton in
            keycapButton.convertShiftVersion()
        }
    }
    
    func drawUpdate(wordKey: String, status: InputWordInfo.InputStatus) {
        guard let buttonView = keyCapButtonDictionarys[wordKey] else {
            return
        }
        
        if(!buttonView.isUpdate) {
            switch status {
            case .contain:
                buttonView.keyCapButton.backgroundColor = UIService.UIPropertyOfStatus.contain.backgroundColor
                break
            case .match:
                buttonView.keyCapButton.backgroundColor = UIService.UIPropertyOfStatus.match.backgroundColor
                buttonView.isUpdate = true
                break
            case .miss:
                buttonView.keyCapButton.backgroundColor = UIService.UIPropertyOfStatus.miss.backgroundColor
                buttonView.isUpdate = true
                break
            default:
                break
            }
        }
    }
    
    func getWordKey(word: String) -> String{
        switch word {
        case "ㅃ":
            return "ㅂ"
        case "ㅉ":
            return "ㅈ"
        case "ㄸ":
            return "ㄷ"
        case "ㄲ":
            return "ㄱ"
        case "ㅆ":
            return "ㅅ"
        case "ㅒ":
            return "ㅐ"
        case "ㅖ":
            return "ㅔ"
        default :
            return word
        }
    }
}

// UI Event
extension KeyboardView {
    @objc func touchKeyCapButton(_ sender: KeyCapButton) {
        if let keyboardViewDelegate = keyboardViewDelegate {
            let keyCap = sender.keyCap
            keyboardViewDelegate.touchKeyboard(keyCap: keyCap)
        }
    }
}
