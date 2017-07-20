//
//  GameProtocol.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 04.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

protocol GameProtocol: ScoreController {
    
    var name: String { get }
    var description: String { get }
    var score: Int { get set }
    var didEndGame: (() -> ())? { get set }
    
    func start(level: GameLevel)
    func pause()
    func resume()
    func getViewController() -> UIViewController
}

extension GameProtocol {
    func end() {
        self.didEndGame?()
    }
}

