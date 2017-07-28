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
    let op: ((Float, Float) -> Float)
    
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

    var result: Float {
        let res = self.op.op(Float(self.a), Float(self.b))
        return res
    }

    func isValid() -> Bool {
        return !(self.op == MathOperator.div &&
            self.b == 0 ||
            self.op == MathOperator.mult &&
            self.a == 0 &&
            self.b < 0)
    }

    func isSolvable() -> Bool {
        let str = self.result.description
        let strComponents = str.components(separatedBy: ".")

        if (strComponents.count == 2) {
            return strComponents[1].characters.count <= 3
        }

        return true
    }

    static func random(min: Int, max: Int, operators: [MathOperator]) -> Math {
        var math: Math
        repeat {
            math = Math(a: Int.random(min, max), b: Int.random(min, max), op: operators.randomItem()!)
        } while !math.isValid() || !math.isSolvable()
    
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
        return a.result.distance(to: b.result) == 0.0
    }

    static func == (a: Float, b: Math) -> Bool {
        return a.distance(to: b.result) == 0.0
    }

    static func == (a: Math, b: Float) -> Bool {
        return a.result.distance(to: b) == 0.0
    }
}
