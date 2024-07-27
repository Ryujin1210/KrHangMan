//
//  RankViewController.swift
//  KrHangMan-iOS-Prototype
//
//  Created by 김태성 on 2022/12/24.
//

import Foundation
import UIKit

class RankViewController: UIViewController, ViewSetAble {
    
    @IBOutlet weak var MyRank: UILabel!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    var user = [UserEntity]()
    
    
    lazy var datamanager: RankViewDataManager = RankViewDataManager()
    
    var ranks: [AddRank] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //setbackground()
        setBackGround()
        
        tableview.dataSource = self
        tableview.delegate = self
        
        // cell 연결
        let rankNib = UINib(nibName: "RankTableViewCell", bundle: nil)
        tableview.register(rankNib, forCellReuseIdentifier: "RankTableViewCell")
        tableview.backgroundColor = .clear
        // 서버 통신 대기
        self.showIndicator()
        // 랭킹 조회
        datamanager.searchMyRanking(delegate: self)
        datamanager.searchRankingList(delegate: self)
        
        //core
        user = CoreDataManager.share.fetchUser()
        // print(String(user[0].username!))
    }
    
    func configureView() {
        titleLabel.adjustsFontSizeToFitWidth = true
        MyRank.adjustsFontSizeToFitWidth = true
    }
    
    func configureEvent() {
        
    }
    
    func configureBind() {
        
    }
    
    func configureBackground() {
        tableview.backgroundColor = UIColor.clear
        
        let backgroundImage = AppManager.useUIService().getBackgroundImg(backgroundView)
        backgroundView.backgroundColor = UIColor(patternImage: backgroundImage)
    }
    
    // 배경설정
    
    func setbackground() {
        let background = UIImage(named: "background")
        
        var imageView: UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        
        //self.tableview.backgroundView = imageView
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
    // 태성님 배경으로
    func setBackGround() {
        let backgroundImage = AppManager.useUIService().getBackgroundImg(backgroundView)
        backgroundView.backgroundColor = UIColor(patternImage: backgroundImage)
    }
    
    // 뒤로가기
    @IBAction func TapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension RankViewController {
    
    // 서버로부터 가져온 데이터 저장
    func didRetrieveRanks(result: ResRank) {
        self.dismissIndicator()
        ranks = result.addRank
        tableview.reloadData()
    }
    
    // 실패 alert
    func failedToRequest(message: String) {
        self.presentAlert(title: message)
    }
    
    func didRetrieveMyRanks(result: ResMyRank) {
        //var name = result.username
        let rank = result.ranking
        MyRank.text = "👑  나는 \(rank)등 입니다 "
    }
    
}

extension RankViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankTableViewCell", for: indexPath) as! RankTableViewCell
        let rank = ranks[indexPath.row]
        cell.Rank.text = String("\(rank.ranking) 등")
        cell.username.text = rank.username
        cell.correct_answer.text = String("\(rank.correctCnt) 문제 성공!")
        
     
        return cell
    }
}

