//
//  GameProtocol.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 04.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

protocol GameProtocol {
    
    var name: String { get }
    var description: String { get }
    var score: Int { get set }
    var didEndGame: ((Int) -> ())? { get set }
    
    func start()
    func pause()
    func getViewController() -> UIViewController
}

extension GameProtocol {
    func end() {
        if let didEndGame = self.didEndGame {
            didEndGame(self.score)
        }
    }
    
    func fetchScores() -> [GameScore] {
        return GameScore.fetch(forGame: self)
    }
}

