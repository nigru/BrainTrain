//
//  GameViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 05.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import UICountingLabel
import SwiftChart

class GameViewController: UIViewController, HasGame {
    
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var viewChart: Chart!
    @IBOutlet weak var segmentedControlLevel: UISegmentedControl!

    var game: GameProtocol? {
        didSet {
            self.updateGame()
        }
    }

    private func initChart() {
        self.viewChart.minY = 0
        self.viewChart.xLabelsFormatter = { _,_ in "" }
        self.viewChart.yLabelsFormatter = { _,_ in "" }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initChart()
        
        self.segmentedControlLevel.setTitle(GameLevel.easy.description.capitalized, forSegmentAt: 0)
        self.segmentedControlLevel.setTitle(GameLevel.medium.description.capitalized, forSegmentAt: 1)
        self.segmentedControlLevel.setTitle(GameLevel.hard.description.capitalized, forSegmentAt: 2)

        self.segmentedControlLevel.selectedSegmentIndex = self.game?.level.rawValue ?? 0

        self.updateGame()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(appWillResignActive),
                                       name: Notification.Name.UIApplicationWillResignActive,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(appDidBecomeActive),
                                       name: Notification.Name.UIApplicationDidBecomeActive,
                                       object: nil)

        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        notificationCenter.addObserver(self,
                                       selector: #selector(contextSaved(_:)),
                                       name: .NSManagedObjectContextDidSave,
                                       object: managedContext)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc private func contextSaved(_ notification: Notification) {
        self.updateChart()
    }
    
    private func updateGame() {
        guard self.isViewLoaded else { return }
        guard let game = self.game else { return }
        
        self.title = game.name
        self.txtView.text = game.description
        
        self.updateChart()
    }
    
    @objc private func appWillResignActive() {
        self.game?.pause()
    }
    
    @objc private func appDidBecomeActive() {
        self.game?.resume()
    }
    
    private func updateChart() {
        guard let game = self.game else { return }

        let scores = game.fetchScore(limit: 10)
        guard !scores.isEmpty else { return }

        let series = ChartSeries(scores)
        series.color = ChartColors.greenColor()
        self.viewChart.removeAllSeries()
        self.viewChart.add(series)
    }

    @IBAction func btnClick() {
        guard var game = self.game else { return }
        
        self.present(game.getViewController(), animated: true, completion: nil)
        
        let index = self.segmentedControlLevel.selectedSegmentIndex
        let level = GameLevel(rawValue: index) ?? .easy
        game.level = level
        game.start()
    }
    
 }
