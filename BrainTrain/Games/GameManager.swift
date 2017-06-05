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
    
//    public static func registerGame(game: GameProtocol) -> Bool {
//        GameManager.getInstance().add(game: game)
//        return true
//    }
    
    init() {
        self.add(game: TestGame())
        self.add(game: TestGame())
        self.add(game: TestGame())
        self.add(game: TestGame())
    }
    
    var games: [GameProtocol] = []
    
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
