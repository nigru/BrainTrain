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
            self.title = game.name
            if self.isViewLoaded {
                self.setGameForChildViewController()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setGameForChildViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(appDidBecomeActive),
                                       name: Notification.Name.UIApplicationDidBecomeActive,
                                       object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }

    @objc private func appDidBecomeActive() {
        if let _ = AppDelegate.shared.urlGame {
            self.navigationController?.popViewController(animated: true)
        }
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

        self.present(ScoreViewController(game: game), animated: false, completion: nil)
    }

}
