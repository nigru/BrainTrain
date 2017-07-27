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
        super.viewDidLoad()
        
        let button = UIBarButtonItem()
        button.title = "Back"
        self.navigationItem.backBarButtonItem = button
        
        let appDelegate = AppDelegate.shared
        
        guard let profile = appDelegate.profile else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.navigationItem.title = profile.name
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let _ = AppDelegate.shared.urlGame {
            self.performSegue(withIdentifier: "urlGame", sender: self)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(viewDidAppear),
                                       name: Notification.Name.UIApplicationDidBecomeActive,
                                       object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameManager.getGamesCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)
        
        let game: GameProtocol = self.gameManager.getGame(index: indexPath.row)
        
        cell.textLabel?.text = game.name
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? GameTabBarController {
            var game: GameProtocol? = nil
            if segue.identifier == "Game" {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    game = self.gameManager.getGame(index: indexPath.row)
                }
            } else if segue.identifier == "urlGame" {
                game = AppDelegate.shared.urlGame
                AppDelegate.shared.urlGame = nil
            }

            destinationVC.game = game
        }
    }
    
}
