//
//  GameViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 05.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var viewStart: UIView!
    @IBOutlet weak var lblStartTitle: UILabel!
    @IBOutlet weak var txtViewDescription: UITextView!
    
    @IBOutlet weak var viewScore: UIView!
    @IBOutlet weak var lblScore: UILabel!
    
    var game: GameProtocol
    
    init(game: GameProtocol) {
        self.game = game
        super.init(nibName: "GameViewController", bundle: nil)
        
        self.game.didEndGame = self.didEndGame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewStart.isHidden = false
        self.viewScore.isHidden = true

        self.lblStartTitle.text = self.game.name
        self.txtViewDescription.text = self.game.description
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGame(_ sender: Any) {
        self.present(self.game.getViewController(), animated: true, completion: nil)
        self.game.start()
    }
    
    @IBAction func closeScoreView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func didEndGame(score: Int) {
        self.lblScore.text = "\(self.game.score) Punkte"
        self.viewStart.isHidden = true
        self.viewScore.isHidden = false
        self.game.getViewController().dismiss(animated: true, completion: nil)
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
