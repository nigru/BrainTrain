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

    private var games: [String: GameProtocol] = [:]
    
    init() {
        self.addGame(ErrorSpotting())
        self.addGame(SpeedMathGame())
        self.addGame(ColoredWordsGame())
        self.addGame(TestGame())
    }

    private func addGame(_ game: GameProtocol) {
        self.games[game.name] = game
    }

    public func getGame(byName name: String) -> GameProtocol? {
        return self.games[name]
    }
    
    public func getGame(index: Int) -> GameProtocol {
        return Array(self.games.values)[index]
    }
    
    public func getGamesCount() -> Int {
        return self.games.count
    }
}
