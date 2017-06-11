//
//  ColoredWordsGame.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 11.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class ColoredWordsGame: GameProtocol {
    private var viewController: ColoredWordsViewController
    let name: String = "ColoredWords"
    let description: String = "..."
    var didEndGame: ((Int) -> ())?
    var playTime = 10
    
    
    var score: Int = 0
    private var gameTimer: Timer?
    
    let farbe: [(String, UIColor)] = [("blau", .blue), ("grün", .green), ("rot", .red)]
    
    init() {
        self.viewController = ColoredWordsViewController(nibName: "ColoredWordsViewController", bundle: nil)
    }
    
    func start() {
        self.viewController.leftButton.addTarget(self, action: #selector(leftButtonClick), for: UIControlEvents.touchUpInside)
        self.viewController.rightButton.addTarget(self, action: #selector(rightButtonClick), for: UIControlEvents.touchUpInside)
        
        gameTimer?.invalidate()
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        score = 0
        playTime = 10
        self.viewController.timeLabel.text = "\(playTime)"
        play()
    }
    
    func play () {
        
        let randomNumber1 = generateRandomNumber(min: 0, max: farbe.count-1)
        var randomNumber2 = generateRandomNumber(min: 0, max: farbe.count-1)
        
        while randomNumber1 == randomNumber2  {
            randomNumber2 = generateRandomNumber(min: 0, max: farbe.count-1)
        }
        let randomNumber3 = generateRandomNumber(min: 0, max: 1)
        
        viewController.leftButton.backgroundColor = farbe[randomNumber2].1
        viewController.middleLabel.text = farbe[randomNumber1].0
        viewController.middleLabel.textColor = farbe[randomNumber2].1
       
        if randomNumber3 == 0 {
            viewController.leftButton.setTitle(farbe[randomNumber1].0, for: .normal)
            viewController.rightButton.setTitle(farbe[randomNumber2].0, for: .normal)
            viewController.leftButton.backgroundColor = farbe[randomNumber1].1
            viewController.rightButton.backgroundColor = farbe[randomNumber2].1
        }
        else {
            viewController.rightButton.setTitle(farbe[randomNumber1].0, for: .normal)
            viewController.leftButton.setTitle(farbe[randomNumber2].0, for: .normal)
            viewController.rightButton.backgroundColor = farbe[randomNumber1].1
            viewController.leftButton.backgroundColor = farbe[randomNumber2].1
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
    
    @objc func leftButtonClick() {
        if self.viewController.middleLabel.textColor == self.viewController.leftButton.backgroundColor  {
            score += 10
        }
        else {
            score -= 10
        }
        play()
    }
    
    @objc func rightButtonClick() {
        if self.viewController.middleLabel.textColor == self.viewController.rightButton.backgroundColor  {
            score += 10
        }
        else {
            score -= 10
        }
        play()
    }
    
    func getViewController() -> UIViewController {
        return self.viewController
    }
}
