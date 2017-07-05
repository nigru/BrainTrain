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
    
    static func insert(game: String, score: Int, date: Date) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let profile: Profile = appDelegate.profile!
        
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
