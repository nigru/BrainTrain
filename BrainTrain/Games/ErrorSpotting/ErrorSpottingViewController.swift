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
    @IBOutlet weak var timeLabel: UILabel!
    
    var game: GameProtocol?
    var fileName: String?
    var playTime: Int = 15
    var imageNumber: Int?
    
    var imageMask: UIImage?
    var errorAmount: [Int: Int] =  [1: 4, 2: 3]
    var colorIdentity: [Int] = [0, -1, -1, -1, -1, -1, -1, -1]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.game?.start()
        
        imageNumber = generateRandomNumber(min: 1, max: 2)
        for index in 1...errorAmount[imageNumber!]! {
            colorIdentity[index] = 0
        }
        fileName = "iPhone7pic\(imageNumber!)"
        let image = UIImage(named: fileName!)
        
        imageView.image = image
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { timer in
            self.imageView.image = UIImage(named: "black")
            Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.replaceImage), userInfo: nil, repeats: false)
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    @objc private func replaceImage () {
        self.imageView.image = UIImage(named: "\(self.fileName!)b")
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        imageView.addGestureRecognizer(recognizer)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func updateTime(timer: Timer) {
        playTime -= 1
        timeLabel.text = String(playTime)
        if playTime <= 0 {
            timer.invalidate()
            var score = 100
            score += colorIdentity[0] * -10
            for index in 1...errorAmount[imageNumber!]! {
                if colorIdentity[index] == 0 {
                    score -= 100/errorAmount[imageNumber!]!
                }
            }
            self.game?.score = score
            self.game?.end()
        }
    }
    
    
    @objc private func handleTap(recognizer: UITapGestureRecognizer) {
        if self.imageMask == nil {
            self.imageMask = UIImage(named: "\(self.fileName!)m")
        }
        
        let location = recognizer.location(in: imageView)
        
        let colorRGB = imageMask?.getPixelColor(pos: CGPoint(x: location.x * 2, y: location.y * 2))
        
        var errorIndex: Int = 0
        print(location.x, location.y)
        if let color = colorRGB {
            print(color.r, color.g, color.b)
            if color.r > 200 {
                errorIndex = errorIndex ^ 0b001
            }
            if color.g > 200 {
                errorIndex = errorIndex ^ 0b010
            }
            if color.b > 200 {
                errorIndex = errorIndex ^ 0b100
            }
            
            self.colorIdentity[errorIndex] += 1
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

struct RGB {
    let r: CGFloat
    let g: CGFloat
    let b: CGFloat
}

extension UIImage {
    func getPixelColor(pos: CGPoint) -> RGB? {
        
        guard let cgImage = self.cgImage, let dataProvider = cgImage.dataProvider else {
            return nil
        }
        
        let pixelData = dataProvider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo])
        let g = CGFloat(data[pixelInfo+1])
        let b = CGFloat(data[pixelInfo+2])
        
        return RGB(r: r, g: g, b: b)
    }  
}
