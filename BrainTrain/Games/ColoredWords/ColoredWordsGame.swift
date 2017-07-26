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
    let description: String = "Finds selbst heraus :P"
    var didEndGame: (() -> ())?
    var playTime = 10
    
    
    var score: Int = 0
    private var gameTimer: Timer?
    var randomNumberInstructor = 0
    var relevantAnswer : (text : String, color: UIColor)?
    
    var level: GameLevel = .easy
    
    let farbe: [(text: String, color: UIColor)] = [(text: "blau", color: .blue), (text: "grün", color: .green), (text: "rot", color: .red), (text: "violet", color: .purple), (text: "orange", color: .orange)]
    
    init() {
        self.viewController = ColoredWordsViewController(nibName: "ColoredWordsViewController", bundle: nil)
    }
    
    func start(level: GameLevel) {
        self.level = level
        self.viewController.leftButton.addTarget(self, action: #selector(leftButtonClick), for: UIControlEvents.touchUpInside)
        self.viewController.rightButton.addTarget(self, action: #selector(rightButtonClick), for: UIControlEvents.touchUpInside)
        self.viewController.bottomButton.addTarget(self, action: #selector(bottomButtonClick), for: UIControlEvents.touchUpInside)
        
        gameTimer?.invalidate()
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        score = 0
        playTime = 10
        self.viewController.timeLabel.text = "\(playTime)"
        
        if level == .easy {
            randomNumberInstructor = 0
            viewController.bottomButton.isHidden = true
        }
        else if level == .medium {
            randomNumberInstructor = 1
            viewController.bottomButton.isHidden = true
        }
        else {
            viewController.bottomButton.isHidden = false
        }
        play()
    }
    
    func play () {
        
        let randomNumberFarbbeschriftung = Int.random(0, farbe.count - 1)
        var randomNumberFarbe = Int.random(0, farbe.count - 1)
        var randomNumberRahmen = Int.random(0, farbe.count - 1)
        
        while randomNumberFarbbeschriftung == randomNumberFarbe  {
            randomNumberFarbe = Int.random(0, farbe.count - 1)
        }
        while (randomNumberRahmen == randomNumberFarbe) || (randomNumberRahmen == randomNumberFarbbeschriftung) {
            randomNumberRahmen = Int.random(0, farbe.count - 1)
        }

        randomNumberInstructor = Int.random(0, level.rawValue)
        
        if randomNumberInstructor == 0 {
            viewController.instructor.text = "Text"
            self.relevantAnswer = farbe[randomNumberFarbbeschriftung]
        }
        else if randomNumberInstructor == 2 {
            viewController.instructor.text = "BorderColor"
            self.relevantAnswer = farbe[randomNumberRahmen]
        }
        else {
            viewController.instructor.text = "Color"
            self.relevantAnswer = farbe[randomNumberFarbe]
            
        }
        
        
        viewController.middleLabel.text = farbe[randomNumberFarbbeschriftung].text
        viewController.middleLabel.textColor = farbe[randomNumberFarbe].color
        
        if level == .hard {
            viewController.middleLabel.layer.borderColor = farbe[randomNumberRahmen].color.cgColor
            viewController.middleLabel.layer.borderWidth = 5
            viewController.middleLabel.layer.cornerRadius = 5
        } else {
            viewController.middleLabel.layer.borderColor = farbe[randomNumberFarbe].color.cgColor
            viewController.middleLabel.layer.borderWidth = 5
            viewController.middleLabel.layer.cornerRadius = 5
        }

        var buttons = [viewController.leftButton, viewController.rightButton]

        if level == .hard {
            buttons.append(viewController.bottomButton)
        }

        for colorIndex in [randomNumberFarbbeschriftung, randomNumberFarbe, randomNumberRahmen] {
            if buttons.isEmpty {
                break
            }

            let randomIndex = Int.random(0, buttons.count-1)
            let button = buttons[randomIndex]

            button?.setTitle(farbe[colorIndex].text, for: .normal)
            button?.backgroundColor = farbe[colorIndex].color

            buttons.remove(at: randomIndex)
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
            self.gameTimer?.invalidate()
            self.end()
        }
    }
    
    
    func pause() {
        
    }
    
    func resume() {
        
    }
    
    @objc func leftButtonClick() {
        
        if self.viewController.leftButton.backgroundColor == self.relevantAnswer?.color {
            score += 10
        } else {
            score -= 10
        }
        play()
        
    }
    
    @objc func rightButtonClick() {
        
        if self.viewController.rightButton.backgroundColor == self.relevantAnswer?.color {
            score += 10
        } else {
            score -= 10
        }
        play()
    }
    
    @objc func bottomButtonClick() {
        
        if self.viewController.bottomButton.backgroundColor == self.relevantAnswer?.color {
            score += 10
        } else {
            score -= 10
        }
        play()
    }
    
    func getViewController() -> UIViewController {
        return self.viewController
    }
    
    
}
