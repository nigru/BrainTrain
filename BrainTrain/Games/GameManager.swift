//
//  GameManager.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 04.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import Foundation

class GameManager {
    private static let instance: GameManager = GameManager()
    
    public static func getInstance() -> GameManager {
        return GameManager.instance
    }
    
    private var games: [GameProtocol] = []
    
    init() {
        self.add(game: ErrorSpotting())
        self.add(game: SpeedMathGame())
        self.add(game: TestGame())
    }
    
    private func add(game: GameProtocol) {
        self.games.append(game)
    }
    
    public func getGame(index: Int) -> GameProtocol {
        return self.games[index]
    }
    
    public func getGamesCount() -> Int {
        return self.games.count
    }
}
