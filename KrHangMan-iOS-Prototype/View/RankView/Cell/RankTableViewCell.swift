//
//  RankTableViewCell.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 유원근 on 2022/12/29.
//

import UIKit

class RankTableViewCell: UITableViewCell {
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var Rank: UILabel!
    @IBOutlet weak var correct_answer: UILabel!
    @IBOutlet weak var background: UIView!
    
    var rank: AddRank!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // setEnabled 설정 해 두었음
    }
    
    func setupLayout() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = false
        background.backgroundColor = UIColor.clear
    }
    
}
