//
//  Math.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 09.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import Foundation
import SwiftRandom

struct MathOperator: Equatable {
    let str: String
    let op: ((Int, Int) -> Int)
    
    static let add = MathOperator(str: "+", op: (+))
    static let sub = MathOperator(str: "-", op: (-))
    static let mult = MathOperator(str: "*", op: (*))
    static let div = MathOperator(str: "/", op: (/))
}

func ==(a: MathOperator, b: MathOperator) -> Bool {
    return a.str == b.str
}

struct Math: Equatable {
    let a, b: Int
    let op: MathOperator
    
    var stringRepresentation: String {
        var str = "\(self.a)"
        if self.a < 0 {
            str = "(\(str))"
        }
        str += " \(self.op.str) "
        
        if self.b < 0 {
            str += "(\(self.b))"
        } else {
            str += "\(self.b)"
        }
        
        return str
    }
    
    var result: Int {
        return self.op.op(self.a, self.b)
    }
    
    static func random(min: Int, max: Int, operators: [MathOperator]) -> Math {
        var randomNum1: Int
        var randomNum2: Int
        var randomOperator: MathOperator
        
        repeat {
            randomNum1 = Int.random(min, max)
            randomNum2 = Int.random(min, max)
            randomOperator = operators.randomItem()!
        } while randomOperator == MathOperator.div && randomNum2 == 0 || randomOperator == MathOperator.mult && randomNum1 == 0 && randomNum2 == -1
    
        return Math(a: randomNum1, b: randomNum2, op: randomOperator)
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
