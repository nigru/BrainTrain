//
//  GameScore.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 09.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import CoreData

struct GameScore {
    let game: String
    let score: Int
    let date: Date
    
    static func from(managedObject: NSManagedObject) -> GameScore? {
        guard let scoreAny = managedObject.value(forKey: "score"), let score = scoreAny as? Int, let gameAny = managedObject.value(forKey: "game"), let game = gameAny as? String, let dateAny = managedObject.value(forKey: "date"), let date = dateAny as? Date else {
            return nil
        }
        return GameScore(game: game, score: score, date: date)
    }
    
    static func fetch(forGame game: GameProtocol) -> [GameScore] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Score")
        fetchRequest.predicate = NSPredicate(format: "game == %@", game.name)
        var result: [GameScore] = []
        
        do {
            let entries = try managedContext.fetch(fetchRequest)
            for entry in entries {
                if let gameScore = GameScore.from(managedObject: entry) {
                    result.append(gameScore)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return result
    }
    
    func save() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Score", in: managedContext)!
        let score = NSManagedObject(entity: entity, insertInto: managedContext)
        score.setValue(self.game, forKeyPath: "game")
        score.setValue(self.score, forKeyPath: "score")
        score.setValue(self.date, forKeyPath: "date")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
