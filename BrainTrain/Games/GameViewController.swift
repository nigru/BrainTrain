//
//  GameViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 05.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    private var isStartView: Bool = true {
        didSet {
            if isStartView {
                self.txtView.isHidden = false
                self.lblScore.isHidden = true
                self.btn.setTitle("Start", for: UIControlState.normal)
            } else {
                self.txtView.isHidden = true
                self.lblScore.isHidden = false
                self.btn.setTitle("Fertig", for: UIControlState.normal)
            }
        }
    }
    
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var btn: UIButton!
    
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

        self.isStartView = true
        self.btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
        self.title = self.game.name
        self.txtView.text = self.game.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func btnClick() {
        if self.isStartView {
            self.present(self.game.getViewController(), animated: true, completion: {
                self.isStartView = false
            })
            self.game.start()
        } else {
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func didEndGame(score: Int) {
        self.lblScore.text = "\(self.game.score) Punkte"
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
