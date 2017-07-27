//
//  SpeedMath.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 09.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class SpeedMathGame: GameProtocol {

    private static let PLAY_TIME: Int = 30
    private static let SCORE_FOR_MATH: Int = 10
    private static let SCORE_FOR_ERROR: Int = -1
    
    let name: String = "SpeedMath"
    let description: String = "Ziel ist es die angezeigten Rechenaufgaben so schnell wie möglich zu lösen. Jede richtige Lösung gibt Punkte, Fehlversuche führen zu Punktabzug.\nDu hast \(PLAY_TIME) Sekunden Zeit."
    var didEndGame: (() -> ())?
    let viewController: SpeedMathViewController
    
    var score: Int = 0
    var level: GameLevel = .easy
    private var playTime: Int = 0
    private var gameTimer: Timer?
    
    private var currentMath: Math? {
        didSet {
            self.viewController.show(math: self.currentMath)
        }
    }
    private var operators: [MathOperator] = []
    private var min: Int = 0
    private var max: Int = 0
    
    init() {
        self.viewController = SpeedMathViewController(nibName: "SpeedMathViewController", bundle: nil)
        self.viewController.checkMathClosure = self.checkMath
    }

    func start(level: GameLevel) {
        switch level {
            case .easy:
                self.operators = [MathOperator.add, MathOperator.sub]
                self.min = 0
                self.max = 10
            case .medium:
                self.operators = [MathOperator.add, MathOperator.sub]
                self.min = -10
                self.max = 10
            case .hard:
                self.operators = [MathOperator.add, MathOperator.sub, MathOperator.mult, MathOperator.div]
                self.min = -10
                self.max = 10
        }
        
        self.resetGame()
        self.currentMath = Math.random(min: self.min, max: self.max, operators: self.operators)
        self.viewController.showKeyboard()
        self.startTimer()
    }

    private func resetGame() {
        self.score = 0
        self.playTime = SpeedMathGame.PLAY_TIME
        self.viewController.show(playTime: self.playTime)
    }
    
    private func startTimer() {
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func pause() {
        self.gameTimer?.invalidate()
    }
    
    func resume() {
        guard let timer = self.gameTimer, !timer.isValid else { return }

        self.startTimer()
    }
    
    private func endGame() {
        self.gameTimer?.invalidate()
        self.end()
    }
    
    func getViewController() -> UIViewController {
        return self.viewController
    }
    
    @objc func updateTime(timer: Timer) {
        self.playTime -= 1
        self.viewController.show(playTime: self.playTime)
        if (self.playTime <= 0) {
            self.endGame()
        }
    }
    
    private func checkMath(input: String?) -> Bool {
        if let currentMath = self.currentMath {
            if let input = input?.replacingOccurrences(of: ",", with: "."), let inputFloat = Float(input) {
                if currentMath == inputFloat {
                    self.score += SpeedMathGame.SCORE_FOR_MATH
                } else {
                    self.score += SpeedMathGame.SCORE_FOR_ERROR
                    return false
                }
            } else {
                return false
            }
        }
        
        self.currentMath = Math.random(min: self.min, max: self.max, operators: self.operators)
        return true
    }
}
