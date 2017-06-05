//
//  GameController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 05.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class GameController {
    
    var game: GameProtocol
    let parentViewController: UIViewController
    
    init(for game: GameProtocol, parentViewController: UIViewController) {
        self.game = game
        self.parentViewController = parentViewController
        
        self.game.didEndGame = self.didEndGame
    }
    
    private func didEndGame(score: Int) {
        self.game.getViewController().dismiss(animated: true, completion: nil)
    }
    
    public func getGameViewController() -> UIViewController {
        return self.game.getViewController()
    }
    
    public func presentGameViewController() {
        self.parentViewController.present(self.game.getViewController(), animated: true, completion: nil)
        self.game.start()
    }
    
}
