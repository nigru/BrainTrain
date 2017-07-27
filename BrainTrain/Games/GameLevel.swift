//
//  GameLevel.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 28.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import Foundation

public enum GameLevel: Int, CustomStringConvertible {

    public var description: String {
        get {
            switch self {
            case .easy:
                return "easy"
            case .medium:
                return "medium"
            case .hard:
                return "hard"
            }
        }
    }

    case easy
    case medium
    case hard

}
