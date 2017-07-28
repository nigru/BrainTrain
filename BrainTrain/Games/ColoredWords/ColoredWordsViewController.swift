//
//  ColoredWordsViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 11.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class ColoredWordsViewController: UIViewController {

    @IBOutlet weak var instructor: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        rightSwipe.direction = .right
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector (handleSwipe))
        downSwipe.direction = .down
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(downSwipe)
    }
    
    func handleSwipe (sender: UISwipeGestureRecognizer){
        
        switch (sender.direction) {
        case UISwipeGestureRecognizerDirection.left :
            leftButton.sendActions(for: .touchUpInside)
            leftButton.shake()
            break
        case UISwipeGestureRecognizerDirection.right :
            rightButton.sendActions(for: .touchUpInside)
            rightButton.shake()
            break
        case UISwipeGestureRecognizerDirection.down :
            bottomButton.sendActions(for: .touchUpInside)
            bottomButton.shake()
            break
        default :
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
