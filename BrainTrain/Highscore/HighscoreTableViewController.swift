//
//  HighscoreTableViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 13.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import CoreData

class HighscoreTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, HasGame {

    var fetchedResultsController: NSFetchedResultsController<Score>!
    var game: GameProtocol? {
        didSet {
            initFetchedResultsController()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }

        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func initFetchedResultsController() {
        guard let game = self.game else { return }

        let request = game.fetchScoreRequest(withProfile: nil, withLimit: 15)
        request.sortDescriptors = game.scoreSort(scoreAscending: false, dateAscending: false)

        let appDelegate = AppDelegate.shared
        let moc = appDelegate.persistentContainer.viewContext

        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to init FetchResultsController: \(error)")
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)

        let score = self.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = "\(score.score)"

        if let date = score.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm:ss"
            cell.detailTextLabel?.text = dateFormatter.string(from: date as Date)
        }

        return cell
    }

}
