//
//  GameScoreFetcher.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 15.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import Foundation
import CoreData

protocol ScoreController {}

extension ScoreController where Self: GameProtocol {
    func fetchScoreRequest(withProfile profile: Profile?, withLimit limit: Int? = nil) -> NSFetchRequest<Score> {
        return self.fetchScoreRequest(forGame: self, withProfile: profile, withLimit: limit)
    }

    func fetchScore(withProfile profile: Profile?, limit: Int? = nil) -> [Score] {
        return self.fetchScore(forGame: self, withProfile: profile, limit: limit)
    }

    func fetchScore(limit: Int? = nil) -> [Score] {
        return self.fetchScore(forGame: self, limit: limit)
    }

    func saveScore() {
        self.save(score: self.score, forGame: self.name, withLevel: self.level, atDate: Date())
    }
}

extension ScoreController {

    func scoreSort(scoreAscending: Bool? = nil, dateAscending: Bool? = nil) -> [NSSortDescriptor] {
        var sort: [NSSortDescriptor] = []

        if let scoreAscending = scoreAscending {
            sort.append(NSSortDescriptor(key: "score", ascending: scoreAscending))
        }

        if let dateAscending = dateAscending {
            sort.append(NSSortDescriptor(key: "date", ascending: dateAscending))
        }

        return sort
    }

    fileprivate func fetchScoreRequest(forGame game: GameProtocol, withProfile profile: Profile?, withLimit limit: Int? = nil) -> NSFetchRequest<Score> {
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()

        if let profile = profile {
            fetchRequest.predicate = NSPredicate(format: "game == %@ AND profile == %@", game.name, profile)
        } else {
            fetchRequest.predicate = NSPredicate(format: "game == %@", game.name)
        }

        if let limit = limit {
            fetchRequest.fetchLimit = limit
        }

        return fetchRequest
    }

    fileprivate func fetchScore(forGame game: GameProtocol, withProfile profile: Profile?, limit: Int? = nil) -> [Score] {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        let fetchRequest = self.fetchScoreRequest(forGame: game, withProfile: profile, withLimit: limit)
        fetchRequest.sortDescriptors = self.scoreSort(dateAscending: false)

        do {
            return try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return []
    }

    fileprivate func fetchScore(forGame game: GameProtocol, limit: Int? = nil) -> [Score] {
        return self.fetchScore(forGame: game, withProfile: AppDelegate.shared.profile, limit: limit)
    }

    fileprivate func save(score: Int, forGame game: String, withLevel level: GameLevel, atDate date: Date) {

        let managedContext = AppDelegate.shared.persistentContainer.viewContext

        let profile: Profile = AppDelegate.shared.profile!

        let s = Score(context: managedContext)
        s.game = game
        s.score = Int32(score)
        s.date = date as NSDate
        s.profile = profile
        s.level = Int16(level.rawValue)

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
