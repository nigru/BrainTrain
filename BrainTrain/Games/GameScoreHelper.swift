//
//  GameScore.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 09.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import CoreData

class GameScoreHelper {
    
    static func fetch(forGame game: GameProtocol) -> [Score] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "game == %@", game.name)
        
        do {
            let entries = try managedContext.fetch(fetchRequest)
            return entries
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
    
    static func insert(game: String, score: Int, date: Date, profileName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let profile: Profile?
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", profileName)
        do {
            let entries = try managedContext.fetch(fetchRequest)
            if entries.count >= 1 {
                profile = entries[0]
            } else {
                profile = nil
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            profile = nil
        }
        
        let s = Score(context: managedContext)
        s.game = game
        s.score = Int32(score)
        s.date = date as NSDate
        s.profile = profile
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
