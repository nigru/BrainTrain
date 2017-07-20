//
//  GameManager.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 04.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import Foundation

class GameManager {

    static func getInstance() -> GameManager {
        return instance
    }

    private static let instance = GameManager()

    private var games: [GameProtocol] = []
    
    init() {
        self.games.append(ErrorSpotting())
        self.games.append(SpeedMathGame())
        self.games.append(ColoredWordsGame())
        self.games.append(TestGame())
    }
    
    public func getGame(index: Int) -> GameProtocol {
        return self.games[index]
    }
    
    public func getGamesCount() -> Int {
        return self.games.count
    }
}
