//
//  GameTabBarController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 12.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class GameTabBarController: UITabBarController, HasGame {
    
    var game: GameProtocol? {
        didSet {
            guard var game = self.game else { return }

            game.didEndGame = self.didEndGame
            if self.isViewLoaded {
                self.setGameForChildViewController()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGameForChildViewController()
    }
    
    private func setGameForChildViewController() {
        guard let game = self.game else { return }
        
        for viewController in self.childViewControllers {
            if var hasGame = viewController as? HasGame {
                hasGame.game = game
            }
        }
    }
    
    private func didEndGame() {
        guard let game = self.game else { return }

        game.saveScore()
        game.getViewController().dismiss(animated: false, completion: nil)

        self.present(ScoreViewController(score: game.score), animated: false, completion: nil)
    }

}
