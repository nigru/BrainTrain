//
//  GameTableTableViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 04.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import CoreData

class GameTableViewController: UITableViewController {
    
    let gameManager : GameManager = GameManager.getInstance()
    
    override func viewDidLoad() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.profile == nil {
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
            do {
                let profiles = try managedContext.fetch(fetchRequest)
                if profiles.count == 0 {
                    let profile = Profile(context: managedContext)
                    profile.name = "Test"
                    
                    do {
                        try managedContext.save()
                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    
                    appDelegate.profile = profile
                } else if profiles.count == 1 {
                    appDelegate.profile = profiles[0]
                } else {
                    // TODO
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameManager.getGamesCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
        
        let game: GameProtocol = self.gameManager.getGame(index: indexPath.row)
        
        cell.textLabel?.text = game.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = self.gameManager.getGame(index: indexPath.row)
        let gameVC = GameViewController(game: game)
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
}
