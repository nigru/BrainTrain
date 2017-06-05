//
//  TestGame.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 04.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class TestGame: GameProtocol {
    
    private let viewController: UIViewController
    var name: String = "Test"
    var description: String = "Ein Testspiel zu Demonstrationszwecken.\nZiel ist es den Button zu drücken."
    var score: Int = 0
    var didEndGame: ((Int) -> ())?
    
    init() {
        let vc = TestGameViewController(nibName: "TestGameViewController", bundle: nil)
        self.viewController = vc
        vc.game = self
    }
    
    func getViewController() -> UIViewController {
        return self.viewController
    }
    
    func start() {
        self.score = 0
    }
    
    func pause() {
        // nothing
    }
    
}
