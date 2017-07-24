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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as! HighscoreTableViewCell

        let score = self.fetchedResultsController.object(at: indexPath)
        cell.scoreLabel.text = "\(score.score)"

        let level = GameLevel(rawValue: Int(score.level)) ?? .easy
        switch level {
        case .easy:
            cell.levelLabel.text = "easy"
        case .medium:
            cell.levelLabel.text = "medium"
        case .hard:
            cell.levelLabel.text = "hard"
        }

        if let date = score.date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm:ss"
            cell.dateLabel.text = dateFormatter.string(from: date as Date)
        }

        cell.usernameLabel.text = score.profile?.name ?? ""

        return cell
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        }
    }

}
