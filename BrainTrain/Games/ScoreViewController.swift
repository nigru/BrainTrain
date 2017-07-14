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
    
    private let score: Int
    
    init(score: Int) {
        self.score = score
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
        
        self.labelScore.format = "%d Punkte"
        
        self.labelScore.countFromZero(to: CGFloat(self.score))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func btnClick() {
        self.dismiss(animated: true, completion: nil)
    }

}
