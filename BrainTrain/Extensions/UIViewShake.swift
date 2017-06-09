//
//  UIViewShake.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 09.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

extension UIView {
    func shake(intensity: Float = 20.0, duration: CFTimeInterval = 0.6) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = duration
        animation.values = [-intensity, intensity, -intensity, intensity, -(intensity/2), intensity/2, intensity/4, intensity/4, 0.0 ]
        self.layer.add(animation, forKey: "shake")
    }
}
