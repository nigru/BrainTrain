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
    
    static let add = MathOperator(str: "+", op: (+))
    static let sub = MathOperator(str: "-", op: (-))
    static let mult = MathOperator(str: "*", op: (*))
    static let div = MathOperator(str: "/", op: (/))
}

extension MathOperator: Equatable {
    static func == (a: MathOperator, b: MathOperator) -> Bool {
        return a.str == b.str
    }
}



struct Math {
    let a, b: Int
    let op: MathOperator

    var result: Int {
        return self.op.op(self.a, self.b)
    }

    func isValid() -> Bool {
        return !(self.op == MathOperator.div &&
            self.b == 0 ||
            self.op == MathOperator.mult &&
            self.a == 0 &&
            self.b < 0)
    }

    static func random(min: Int, max: Int, operators: [MathOperator]) -> Math {
        var math: Math
        repeat {
            math = Math(a: Int.random(min, max), b: Int.random(min, max), op: operators.randomItem()!)
        } while !math.isValid()
    
        return math
    }
}

extension Math: CustomStringConvertible {
    var description: String {
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
}

extension Math: Equatable {
    static func == (a: Math, b: Math) -> Bool {
        return a.result == b.result
    }

    static func == (a: Int, b: Math) -> Bool {
        return a == b.result
    }

    static func == (a: Math, b: Int) -> Bool {
        return a.result == b
    }
}


