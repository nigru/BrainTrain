//
//  GameViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 05.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import CoreData
import UICountingLabel
import SwiftChart

class GameViewController: UIViewController {
    
    private var isStartView: Bool = true {
        didSet {
            if isStartView {
                self.txtView.isHidden = false
                self.lblScore.isHidden = true
                self.segmentedControlLevel.isHidden = false
                self.btn.setTitle("Start", for: UIControlState.normal)
            } else {
                self.txtView.isHidden = true
                self.lblScore.isHidden = false
                self.segmentedControlLevel.isHidden = true
                self.btn.setTitle("Fertig", for: UIControlState.normal)
            }
        }
    }
    
    @IBOutlet weak var lblScore: UICountingLabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var viewChart: Chart!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var segmentedControlLevel: UISegmentedControl!
    
    var game: GameProtocol
    
    init(game: GameProtocol) {
        self.game = game
        super.init(nibName: "GameViewController", bundle: nil)
        self.game.didEndGame = self.didEndGame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblScore.format = "%d Punkte"
        self.isStartView = true
        self.btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
        self.title = self.game.name
        self.txtView.text = self.game.description
        
        self.viewChart.minY = 0
        self.viewChart.xLabelsFormatter = { _,_ in "" }
        self.viewChart.yLabelsFormatter = { _,_ in "" }
        let scores = Array(GameScoreHelper.fetch(forGame: self.game).suffix(10))
        if scores.count != 0 {
            let series = ChartSeries(scores)
            series.color = ChartColors.greenColor()
            self.viewChart.add(series)
        }
        
        self.segmentedControlLevel.setTitle("Easy", forSegmentAt: 0)
        self.segmentedControlLevel.setTitle("Medium", forSegmentAt: 1)
        self.segmentedControlLevel.setTitle("Hard", forSegmentAt: 2)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appWillResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appWillResignActive() {
        self.game.pause()
    }
    
    func appDidBecomeActive() {
        self.game.resume()
    }
    
    @objc func btnClick() {
        if self.isStartView {
            self.present(self.game.getViewController(), animated: true, completion: {
                self.isStartView = false
            })
            
            let level: GameLevel
            switch self.segmentedControlLevel.selectedSegmentIndex {
            case 0:
                level = .easy
                break
            case 1:
                level = .medium
                break
            case 2:
                level = .hard
                break
            default:
                level = .easy
            }
            
            self.game.start(level: level)   
        } else {
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func didEndGame(score: Int) {
        self.saveScore()
        self.game.getViewController().dismiss(animated: true, completion: {
            self.lblScore.completionBlock = {
                let scores = Array(GameScoreHelper.fetch(forGame: self.game).suffix(10))
                let series = ChartSeries(scores)
                series.color = ChartColors.greenColor()
                self.viewChart.removeAllSeries()
                self.viewChart.add(series)
            }
            self.lblScore.countFromZero(to: CGFloat(self.game.score))
        })
    }

    private func saveScore() {
        GameScoreHelper.insert(game: self.game.name, score: self.game.score, date: Date())
    }
}
