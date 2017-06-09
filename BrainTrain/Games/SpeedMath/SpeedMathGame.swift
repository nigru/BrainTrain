//
//  SpeedMath.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 09.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class SpeedMathGame: GameProtocol {

    private static let PLAY_TIME: Int = 10
    private static let SCORE_FOR_MATH: Int = 10
    private static let SCORE_FOR_ERROR: Int = -1
    
    let name: String = "SpeedMath"
    let description: String = "..."
    var didEndGame: ((Int) -> ())?
    let viewController: SpeedMathViewController
    
    var score: Int = 0
    private var playTime: Int = 0
    private var gameTimer: Timer?
    
    private var currentMath: Math? {
        didSet {
            self.viewController.show(math: self.currentMath)
        }
    }
    let operators: [MathOperator]
    let min, max: Int
    
    init() {
//        self.operators = [MathOperator(str: "+", op: (+)), MathOperator(str: "-", op: (-)), MathOperator(str: "*", op: (*)), MathOperator(str: "/", op: (/))]
        self.operators = [MathOperator(str: "+", op: (+)), MathOperator(str: "-", op: (-))]
        self.min = 0
        self.max = 10
        self.viewController = SpeedMathViewController(nibName: "SpeedMathViewController", bundle: nil)
        self.viewController.checkMathClosure = self.checkMath
    }

    func start() {
        self.score = 0
        self.playTime = SpeedMathGame.PLAY_TIME
        self.viewController.show(playTime: self.playTime)
        self.viewController.showKeyboard()
        self.generateMath()
        self.gameTimer?.invalidate()
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    func pause() {
        
    }
    
    func endGame() {
        self.end()
    }
    
    func getViewController() -> UIViewController {
        return self.viewController
    }
    
    @objc func updateTime(timer: Timer) {
        self.playTime -= 1
        self.viewController.show(playTime: self.playTime)
        if (playTime <= 0) {
            self.endGame()
        }
    }
    
    private func generateMath() {
        let randomNum1 = generateRandomNumber(min: self.min, max: self.max)
        let randomNum2 = generateRandomNumber(min: self.min, max: self.max)
        let randomOperator = generateRandomNumber(min: 0, max: self.operators.count - 1)
        
        self.currentMath = Math(a: randomNum1, b: randomNum2, op: operators[randomOperator])
    }
    
    private func checkMath(input: String?) -> Bool {
        if let currentMath = self.currentMath {
            if let input = input, let inputInt = Int(input) {
                if currentMath == inputInt {
                    self.score += SpeedMathGame.SCORE_FOR_MATH
                    self.generateMath()
                    return true
                } else {
                    self.score += SpeedMathGame.SCORE_FOR_ERROR
                    return false
                }
            }
            return false
        } else {
            self.generateMath()
            return true
        }
    }
}
