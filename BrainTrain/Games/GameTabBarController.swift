//
//  GameTabBarController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 12.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class GameTabBarController: UITabBarController {
    
    private var game: GameProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGameForChildViewController()
        //        self.gameVC.tabBarItem.image =
//        self.addChildViewController(self.gameVC)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setGame(_ game: GameProtocol) {
        self.game = game
        self.game!.didEndGame = self.didEndGame
        
        if self.isViewLoaded {
            self.setGameForChildViewController()
        }
    }
    
    private func setGameForChildViewController() {
        guard let game = self.game else {
            return
        }
        
        for viewController in self.childViewControllers {
            if let hasGame = viewController as? HasGame {
                hasGame.setGame(game)
            }
        }
    }
    
    private func didEndGame(score: Int) {
        guard let game = self.game else {
            return
        }
        
        self.saveScore()
        game.getViewController().dismiss(animated: false, completion: nil)
        self.present(ScoreViewController(score: score), animated: false, completion: {
//            self.gameVC.updateChart()
        })
    }

    private func saveScore() {
        guard let game = self.game else {
            return
        }
        
        GameScoreHelper.insert(game: game.name, score: game.score, date: Date())
    }

}
