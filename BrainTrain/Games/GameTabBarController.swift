//
//  GameTabBarController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 12.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class GameTabBarController: UITabBarController {
    
    private var game: GameProtocol
    private let gameVC: GameViewController
    
    init(game: GameProtocol) {
        self.game = game
        self.gameVC = GameViewController(game: self.game)
        super.init(nibName: nil, bundle: nil)
        
        self.game.didEndGame = self.didEndGame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(self.gameVC)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func didEndGame(score: Int) {
        self.saveScore()
        self.game.getViewController().dismiss(animated: false, completion: nil)
        self.present(ScoreViewController(score: score), animated: false, completion: {
            self.gameVC.updateChart()
        })
    }
    
    private func saveScore() {
        GameScoreHelper.insert(game: self.game.name, score: self.game.score, date: Date())
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
