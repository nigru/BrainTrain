//
//  GameTableTableViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 04.06.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit

class GameTableViewController: UITableViewController {
    
    let gameManager : GameManager = GameManager.getInstance()
    
    override func viewDidLoad() {
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
//        let navController = UINavigationController(rootViewController: gameVC)
//        self.present(navController, animated: true, completion: nil)
        self.navigationController?.pushViewController(gameVC, animated: true
        )
        
    }
    
}
