//
//  Math.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 09.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import Foundation
import SwiftRandom

struct MathOperator {
    let str: String
    let op: ((Int, Int) -> Int)
}

struct Math: Equatable {
    let a, b: Int
    let op: MathOperator
    
    var stringRepresentation: String {
        return "\(self.a) \(self.op.str) \(self.b)"
    }
    
    var result: Int {
        return self.op.op(self.a, self.b)
    }
    
    static func random(min: Int, max: Int, operators: [MathOperator]) -> Math {
        let randomNum1 = Int.random(min, max)
        let randomNum2 = Int.random(min, max)
        let randomOperator = operators.randomItem()
    
        return Math(a: randomNum1, b: randomNum2, op: randomOperator!)
    }
}

func ==(a: Math, b: Math) -> Bool {
    return a.result == b.result
}

func ==(a: Int, b: Math) -> Bool {
    return a == b.result
}

func ==(a: Math, b: Int) -> Bool {
    return a.result == b
}
