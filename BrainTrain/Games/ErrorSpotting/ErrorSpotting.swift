//
//  ErrorSpotting.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 05.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class ErrorSpotting: GameProtocol {
    
    private var viewController: ErrorSpottingViewController
    var name: String = "ErrorSpotting"
    var description: String = "sdfklsld,.fgc"
    var score: Int = 0
    var didEndGame: ((Int) -> ())?
    
    init() {
        let vc = ErrorSpottingViewController(nibName: "ErrorSpottingViewController", bundle: nil)
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
