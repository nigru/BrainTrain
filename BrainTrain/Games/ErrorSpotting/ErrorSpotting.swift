//
//  ErrorSpotting.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 05.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import SwiftRandom

class ErrorSpotting: GameProtocol {
    
    private static let PLAY_TIME: Int = 15
    private static let ORIGINAL_IMAGE_INTERVAL: TimeInterval = 3
    private static let BLANK_IMAGE_INTERVAL: TimeInterval = 3
    
    private var viewController: ErrorSpottingViewController
    let name: String = "ErrorSpotting"
    let description: String = "Dir werden nacheinander zwei Bilder gezeigt. Im zweiten Bild sind Fehler eingebaut, die du finden sollst. Tippe auf die vermeindlich fehlerhaften Stellen im Bild.\nJeder nicht gefundene Fehler kostet dich Punkte, genauso wie eine angetippte, nicht fehlerhafte Stelle.\nDu hast \(Int(ErrorSpotting.ORIGINAL_IMAGE_INTERVAL)) Sekunden Zeit dir das Original einzuprägen. Danach musst du innerhalbt von \(ErrorSpotting.PLAY_TIME) Sekunden alle Fehler finden."
    var didEndGame: ((Int) -> ())?
    
    var score: Int = 0
    var playTime: Int = 0
    
    var fileName: String?
    var imageNumber: Int?
    var imageMask: UIImage?
    let errorAmount: [Int: Int] =  [1: 3, 2: 4, 3: 3]
    var colorIdentity: [Int] = [0, -1, -1, -1, -1, -1, -1, -1]
    var timer: Timer?
    var gameTimer: Timer?
    
    init() {
        self.viewController = ErrorSpottingViewController(nibName: "ErrorSpottingViewController", bundle: nil)
    }
    
    func getViewController() -> UIViewController {
        return self.viewController
    }
    
    func start(level: GameLevel) {
        self.score = 0
        self.playTime = ErrorSpotting.PLAY_TIME
        self.colorIdentity = [0, -1, -1, -1, -1, -1, -1, -1]
        
        self.viewController.tapClosure = nil
        self.viewController.show(playTime: nil)
        self.selectRandomImage()
        self.showOriginalImage()
    }
    
    func pause() {
        // nothing
    }
    
    func resume() {
        
    }
    
    func endGame() {
        self.gameTimer?.invalidate()
        self.imageMask = nil
        self.end()
    }
    
    func selectRandomImage() {
        self.imageNumber = Int.random(1, self.errorAmount.count)
        for index in 1...self.errorAmount[self.imageNumber!]! {
            self.colorIdentity[index] = 0
        }
    }
    
    func showOriginalImage() {
        self.fileName = "\(self.imageNumber!)"
        let image = UIImage(named: self.fileName!, in: Bundle(identifier: "ErrorSpotting"), compatibleWith: nil)
        self.viewController.show(image: image)
        
        self.showErrorImage(afterSeconds: ErrorSpotting.ORIGINAL_IMAGE_INTERVAL)
    }
    
    func showBlankImage(forSeconds seconds: TimeInterval, completion: @escaping () -> ()) {
        self.viewController.show(image: UIImage(named: "black"))
        self.timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { timer in
            self.timer?.invalidate()
            self.timer = nil
            completion()
        }
    }
    
    func showErrorImage(afterSeconds seconds: TimeInterval) {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { timer in
            self.showBlankImage(forSeconds: ErrorSpotting.BLANK_IMAGE_INTERVAL) {
                self.viewController.show(image: UIImage(named: "\(self.fileName!)b"))
                self.startGameTimerAndEnableTap()
            }
        }
    }
    
    func startGameTimerAndEnableTap() {
        self.gameTimer?.invalidate()
        self.viewController.show(playTime: self.playTime)
        self.viewController.tapClosure = self.handleTap
        self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        playTime -= 1
        self.viewController.show(playTime: self.playTime)
        if playTime <= 0 {
            self.gameTimer?.invalidate()
            var score = 100
            score += colorIdentity[0] * -10
            for index in 1...errorAmount[imageNumber!]! {
                if colorIdentity[index] == 0 {
                    score -= 100/errorAmount[imageNumber!]!
                }
            }
            self.score = score
            self.end()
        }
    }
    
    private func handleTap(location: CGPoint) {
        if self.imageMask == nil {
            self.imageMask = UIImage(named: "\(self.fileName!)m", in: Bundle(identifier: "ErrorSpotting"), compatibleWith: nil)
            self.viewController.maskView.image = self.imageMask
//            self.viewController.show(image: self.imageMask)
        }
        
//        let colorRGB = imageMask?.getPixelColor(pos: CGPoint(x: location.x * 2, y: location.y * 2))
        let colorRGB = self.viewController.maskView.getPixelColorAt(point: location)
        
        var errorIndex: Int = 0
        print(self.imageMask!.size, location.x, location.y)
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
}

struct RGB {
    let r: CGFloat
    let g: CGFloat
    let b: CGFloat
}

extension UIImageView {
    func getPixelColorAt(point:CGPoint) -> RGB? {
        
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point.x, y: -point.y)
        layer.render(in: context!)
        let colorRGB = RGB(r: CGFloat(pixel[0]),
                           g: CGFloat(pixel[1]),
                           b: CGFloat(pixel[2]))
        
        pixel.deallocate(capacity: 4)
        return colorRGB
    }
}

//extension UIImage {
//    func getPixelColor(pos: CGPoint) -> RGB? {
//        
//        guard let cgImage = self.cgImage, let dataProvider = cgImage.dataProvider else {
//            return nil
//        }
//        
//        print(cgImage.width, cgImage.height)
//        
//        let pixelData = dataProvider.data
//        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
//        
//        let pixelInfo: Int = ((Int(cgImage.width) * Int(pos.y)) + Int(pos.x)) * 4
//        
//        let r = CGFloat(data[pixelInfo])
//        let g = CGFloat(data[pixelInfo+1])
//        let b = CGFloat(data[pixelInfo+2])
//        
//        return RGB(r: r, g: g, b: b)
//    }
//}

//extension UIImage {
//    func getPixelColor(pos: CGPoint) -> RGB? {
//        
//        let x = Int(self.size.width / pos.x)
//        let y = Int(self.size.height / pos.y)
//        
//        guard let cgImage = self.cgImage, let dataProvider = cgImage.dataProvider else {
//            return nil
//        }
//        
//        print(cgImage.width, cgImage.height)
//        
//        let pixelData = dataProvider.data
//        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
//        
//        print(Int(cgImage.height) * y, Int(cgImage.width) * x)
//        
//        let pixelInfo: Int = ((Int(cgImage.width) * Int(cgImage.height) * y) + Int(cgImage.width) * x) * 4
//        
//        let r = CGFloat(data[pixelInfo])
//        let g = CGFloat(data[pixelInfo+1])
//        let b = CGFloat(data[pixelInfo+2])
//        
//        return RGB(r: r, g: g, b: b)
//    }
//}
