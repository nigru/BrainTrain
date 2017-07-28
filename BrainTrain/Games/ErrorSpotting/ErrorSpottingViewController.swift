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
            self.errorLabel.attributedText  = NSAttributedString(string: "", attributes: nil)
            return
        }
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(errorRemaining)")
        attributeString.addAttribute(NSStrokeColorAttributeName, value: UIColor.white, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSStrokeWidthAttributeName, value: -5.0, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0, attributeString.length))

        self.errorLabel.attributedText = attributeString
    }
    
    func show(playTime: Int?) {
        guard let playTime = playTime else {
            self.timeLabel.attributedText = NSAttributedString(string: "", attributes: nil)
            return
        }

        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(playTime)")
        attributeString.addAttribute(NSStrokeColorAttributeName, value: UIColor.white, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSStrokeWidthAttributeName, value: -5.0, range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSMakeRange(0, attributeString.length))

        self.timeLabel.attributedText = attributeString
    }
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: self.imageView)
        self.tapClosure?(location)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
