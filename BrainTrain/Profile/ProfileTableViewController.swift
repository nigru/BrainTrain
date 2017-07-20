//
//  ProfileTableViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 06.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import CoreData

class ProfileTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, ProfileController {

    var fetchedResultsController: NSFetchedResultsController<Profile>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Profile"

        initFetchedResultsController()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        let profile = self.fetchedResultsController.object(at: indexPath)
        let name = profile.name
        cell.textLabel?.text = name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let profile = self.fetchedResultsController.object(at: indexPath)
            self.delete(profile: profile) { (succes: Bool) in
                if succes {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = AppDelegate.shared
        appDelegate.profile = self.fetchedResultsController.object(at: indexPath)

        self.performSegue(withIdentifier: "showGames", sender: self)
    }
    
    func initFetchedResultsController() {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            break
        }
    }
    
    @IBAction func addProfile(_ sender: Any) {
        let alert = UIAlertController(title: "Neues Profil", message: "Profilnamen eingeben", preferredStyle: .alert)
            alert.addTextField { (textField) in
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] (_) in
            guard let `self` = self else { return }
            guard let textField = alert.textFields?[0] else { return }
            guard let name = textField.text else { return }
            guard !name.characters.isEmpty else { return }

            guard !self.exists(profileWithName: name) else {
                let errorAlert = UIAlertController(title: "Neues Profil", message: "Name existiert schon", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                return
            }

            self.create(profileWithName: name)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}
