//
//  ColoredWordsGame.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 11.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import SwiftRandom

class ColoredWordsGame: GameProtocol {
    private var viewController: ColoredWordsViewController
    let name: String = "ColoredWords"
    let description: String = "..."
    var didEndGame: ((Int) -> ())?
    var playTime = 10
    
    
    var score: Int = 0
    private var gameTimer: Timer?
    var randomNumberInstructor = 0
    var level: GameLevel = .easy
    
    let farbe: [(String, UIColor)] = [("blau", .blue), ("grün", .green), ("rot", .red)]
    
    init() {
        self.viewController = ColoredWordsViewController(nibName: "ColoredWordsViewController", bundle: nil)
    }
    
    func start(level: GameLevel) {
        self.level = level
        self.viewController.leftButton.addTarget(self, action: #selector(leftButtonClick), for: UIControlEvents.touchUpInside)
        self.viewController.rightButton.addTarget(self, action: #selector(rightButtonClick), for: UIControlEvents.touchUpInside)
        
        gameTimer?.invalidate()
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        score = 0
        playTime = 10
        self.viewController.timeLabel.text = "\(playTime)"
        
        if level == .easy {
            randomNumberInstructor = 0
        }
        else if level == .medium {
            randomNumberInstructor = 1
        }
        
        play()
    }
    
    func play () {
        
        let randomNumberFarbbeschriftung = Int.random(0, farbe.count - 1)
        var randomNumberFarbe = Int.random(0, farbe.count - 1)
        
        while randomNumberFarbbeschriftung == randomNumberFarbe  {
            randomNumberFarbe = Int.random(0, farbe.count - 1)
        }
        let randomNumberAnordnung = Int.random(0, 1)
        
        
        if level == .hard {
           randomNumberInstructor = Int.random(0, 1)
        }
        
        if randomNumberInstructor == 0 {
            viewController.instructor.text = "Color"
        }
        else {
            viewController.instructor.text = "Text"
        }
        
        
        viewController.middleLabel.text = farbe[randomNumberFarbbeschriftung].0
        viewController.middleLabel.textColor = farbe[randomNumberFarbe].1
       
        if randomNumberAnordnung == 0 {
            viewController.leftButton.setTitle(farbe[randomNumberFarbbeschriftung].0, for: .normal)
            viewController.rightButton.setTitle(farbe[randomNumberFarbe].0, for: .normal)
            viewController.leftButton.backgroundColor = farbe[randomNumberFarbbeschriftung].1
            viewController.rightButton.backgroundColor = farbe[randomNumberFarbe].1
        }
        else {
            viewController.rightButton.setTitle(farbe[randomNumberFarbbeschriftung].0, for: .normal)
            viewController.leftButton.setTitle(farbe[randomNumberFarbe].0, for: .normal)
            viewController.rightButton.backgroundColor = farbe[randomNumberFarbbeschriftung].1
            viewController.leftButton.backgroundColor = farbe[randomNumberFarbe].1
        }
        
        if viewController.leftButton.backgroundColor == .blue {
            viewController.leftButton.tintColor = .red
        } else {
            viewController.leftButton.tintColor = .blue
        }
        
        if viewController.rightButton.backgroundColor == .blue {
            viewController.rightButton.tintColor = .red
        } else {
            viewController.rightButton.tintColor = .blue
        }
        
        
    }
    
    
    @objc func updateTime(timer: Timer) {
        self.playTime -= 1
        self.viewController.timeLabel.text = "\(playTime)"
        if (playTime <= 0) {
            self.end()
        }
    }
    
    
    func pause() {
        
    }
    
    func resume() {
        
    }
    
    @objc func leftButtonClick() {
        if randomNumberInstructor == 0 {
            if self.viewController.middleLabel.textColor == self.viewController.leftButton.backgroundColor  {
                score += 10
            }
            else {
                score -= 10
            }
        } else {
            if self.viewController.middleLabel.textColor == self.viewController.leftButton.backgroundColor  {
                score -= 10
            }
            else {
                score += 10
            }

        }
        play()
    }
    
    @objc func rightButtonClick() {
        if randomNumberInstructor == 0 {
            if self.viewController.middleLabel.textColor == self.viewController.rightButton.backgroundColor  {
                score += 10
            }
            else {
                score -= 10
            }
        } else {
            if self.viewController.middleLabel.textColor == self.viewController.rightButton.backgroundColor  {
                score -= 10
            }
            else {
                score += 10
            }
        }
        play()
    }
    
    func getViewController() -> UIViewController {
        return self.viewController
    }
    
    
}
