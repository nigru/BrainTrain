//
//  SpeedMathViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 09.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class SpeedMathViewController: UIViewController {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMath: UILabel!
    @IBOutlet weak var txtFieldAnswer: UITextField!
    
    var checkMathClosure: ((String?) -> Bool)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addToolBar()
    }
    
    private func addToolBar() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = .default
        
        let negate = UIBarButtonItem(title: "±", style: .plain, target: self, action: #selector(negateButtonAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        var items: [UIBarButtonItem] = []
        items.append(negate)
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.txtFieldAnswer.inputAccessoryView = doneToolbar
    }
    
    func negateButtonAction() {
        if let txt = self.txtFieldAnswer.text {
            if txt.hasPrefix("-") {
                let index = txt.index(txt.startIndex, offsetBy: 1)
                self.txtFieldAnswer.text = txt.substring(from: index)
            } else {
                self.txtFieldAnswer.text = "-" + txt
            }
        }
    }
    
    func doneButtonAction() {
        guard let checkMathClosure = self.checkMathClosure else { return }
        guard !checkMathClosure(self.txtFieldAnswer.text) else { return }

        self.lblMath.shake()
    }

    func show(playTime: Int?) {
        guard let playTime = playTime else {
            self.lblTime.text = ""
            return
        }
        self.lblTime.text = "\(playTime)"
    }
    
    func show(math: Math?) {
        self.txtFieldAnswer.text = ""
        
        guard let math = math else {
            self.lblMath.text = ""
            return
        }
        self.lblMath.text = "\(math)"
    }
    
    func showKeyboard() {
        self.txtFieldAnswer.becomeFirstResponder()
    }

}
