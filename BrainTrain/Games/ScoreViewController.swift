//
//  ScoreViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 12.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import UICountingLabel

class ScoreViewController: UIViewController {

    @IBOutlet weak var labelScore: UICountingLabel!
    @IBOutlet weak var doneButton: UIButton!

    private let game: GameProtocol
    
    init(game: GameProtocol) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelScore.format = "%d Punkte"
        self.labelScore.countFromZero(to: CGFloat(self.game.score))

        self.doneButton.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
    }
    
    @objc func btnClick() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func shareBtnClick(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [GameActivityItemSource(game: self.game)], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop, .print]
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }


}
