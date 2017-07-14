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

class GameViewController: UIViewController, HasGame {
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var viewChart: Chart!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var segmentedControlLevel: UISegmentedControl!
    
    var game: GameProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
        
        self.viewChart.minY = 0
        self.viewChart.xLabelsFormatter = { _,_ in "" }
        self.viewChart.yLabelsFormatter = { _,_ in "" }
        
        self.segmentedControlLevel.setTitle("Easy", forSegmentAt: 0)
        self.segmentedControlLevel.setTitle("Medium", forSegmentAt: 1)
        self.segmentedControlLevel.setTitle("Hard", forSegmentAt: 2)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appWillResignActive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appDidBecomeActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        self.updateGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGame(_ game: GameProtocol) {
        self.game = game
        
        self.updateGame()
    }
    
    private func updateGame() {
        guard self.isViewLoaded, let game = self.game else {
            return
        }
        
        self.title = game.name
        self.txtView.text = game.description
        
        self.updateChart()
    }
    
    func appWillResignActive() {
        self.game?.pause()
    }
    
    func appDidBecomeActive() {
        self.game?.resume()
    }
    
    func updateChart() {
        guard let game = self.game else {
            return
        }
        
        let scores = Array(GameScoreHelper.fetch(forGame: game).suffix(10))
        
        if scores.count > 0 {
            let series = ChartSeries(scores)
            series.color = ChartColors.greenColor()
            self.viewChart.removeAllSeries()
            self.viewChart.add(series)
        }
    }
    
    @objc func btnClick() {
        guard let game = self.game else {
            return
        }
        self.present(game.getViewController(), animated: true, completion: nil)
        
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
        
        game.start(level: level)
    }
    
 }
