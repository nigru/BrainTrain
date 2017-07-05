//
//  ErrorSpottingViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 05.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class ErrorSpottingViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var maskView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    var tapClosure: ((CGPoint) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.imageView.addGestureRecognizer(recognizer)
        self.imageView.isUserInteractionEnabled = true
    }
    
    func show(image: UIImage?) {
        self.imageView.image = image
    }
    
    func show(errorRemaining: Int?) {
        guard let errorRemaining = errorRemaining else {
            self.errorLabel.text = ""
            return
        }
        self.errorLabel.text = "\(errorRemaining)"
    }
    
    func show(playTime: Int?) {
        guard let playTime = playTime else {
            self.timeLabel.text = ""
            return
        }
        self.timeLabel.text = "\(playTime)"
    }
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self.imageView)
        self.tapClosure?(location)
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
