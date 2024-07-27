//
//  WordCollectionCell.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2022/12/26.
//

import UIKit


class WordCollectionCell: UICollectionViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureCell()
    }
    
    func configureCell() {
        self.layer.cornerRadius = 15
        setEmptyCell()
        
    }
    
    func uploadCell(_ inputWord: InputWordInfo) {
        wordLabel.text = inputWord.word
        let status = inputWord.status
        switch(status) {
        case .empty:
            setEmptyCell()
        case .input:
            setInputCell()
        case .match:
            setMatchCell()
        case .contain:
            setContainCell()
        case .miss:
            setMissCell()
        default:
            break
        }
    }
    
    private func setEmptyCell() {
        self.backgroundColor = UIService.UIPropertyOfStatus.empty.backgroundColor
        self.layer.borderColor = UIService.UIPropertyOfStatus.empty.boarderColor
        self.layer.borderWidth = 3.0
    }
    
    private func setInputCell() {
        self.backgroundColor = UIService.UIPropertyOfStatus.input.backgroundColor
        self.layer.borderColor = UIService.UIPropertyOfStatus.input.boarderColor
        self.layer.borderWidth = 3.0
    }
    
    private func setMatchCell() {
        self.backgroundColor = UIService.UIPropertyOfStatus.match.backgroundColor
        self.layer.borderColor = UIService.UIPropertyOfStatus.match.boarderColor
        self.layer.borderWidth = 3.0
    }
    
    private func setContainCell() {
        self.backgroundColor = UIService.UIPropertyOfStatus.contain.backgroundColor
        self.layer.borderColor = UIService.UIPropertyOfStatus.contain.boarderColor
        self.layer.borderWidth = 3.0
    }
    
    private func setMissCell() {
        self.backgroundColor = UIService.UIPropertyOfStatus.miss.backgroundColor
        self.layer.borderColor = UIService.UIPropertyOfStatus.miss.boarderColor
        self.layer.borderWidth = 3.0
    }

}
