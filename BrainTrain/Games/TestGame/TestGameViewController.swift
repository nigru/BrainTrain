//
//  TestGameViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 01.06.17.
//  Copyright © 2017 Nikolai Gruschke. All rights reserved.
//

import UIKit

class TestGameViewController: UIViewController {

    var game: GameProtocol?
    
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func btnClick() {
        self.game?.score = 100
        self.game?.end()
    }

}
