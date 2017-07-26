//
//  HighscoreViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 26.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import CoreData

class HighscoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, HasGame {

    @IBOutlet weak var segmentedControlLevel: UISegmentedControl!
    @IBOutlet weak var segmentedControlProfile: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    var fetchedResultsController: NSFetchedResultsController<Score>!
    var game: GameProtocol? {
        didSet {
            initFetchedResultsController()
        }
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }

        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func initFetchedResultsController(allProfiles: Bool = false, limit: Int = 15) {
        guard let game = self.game else { return }

        let request: NSFetchRequest<Score>
        if allProfiles {
            request = game.fetchScoreRequest(withProfile: nil, withLimit: limit)
        } else {
            request = game.fetchScoreRequest(withProfile: AppDelegate.shared.profile, withLimit: limit)
        }
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.segmentedControlProfile.setTitle(AppDelegate.shared.profile?.name, forSegmentAt: 0)
        self.segmentedControlProfile.setTitle("All", forSegmentAt: 1)

        self.segmentedControlLevel.setTitle("All", forSegmentAt: 0)
        self.segmentedControlLevel.setTitle("Easy", forSegmentAt: 1)
        self.segmentedControlLevel.setTitle("Medium", forSegmentAt: 2)
        self.segmentedControlLevel.setTitle("Hard", forSegmentAt: 3)
    }

    @IBAction func indexChanged(_ sender: Any) {
        var profile: Profile? = nil
        if self.segmentedControlProfile.selectedSegmentIndex == 0 {
            profile = AppDelegate.shared.profile
        }

        var level: GameLevel? = nil
        if self.segmentedControlLevel.selectedSegmentIndex != 0 {
            level = GameLevel(rawValue: self.segmentedControlLevel.selectedSegmentIndex - 1)
        }

        let _ = self.game?.setScorePredicate(forRequest: self.fetchedResultsController.fetchRequest, withProfile: profile, forLevel: level, withLimit: 15)
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to init FetchResultsController: \(error)")
        }

        self.tableView.reloadData()
    }

}
