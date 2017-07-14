//
//  ProfileTableViewController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 06.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import UIKit
import CoreData

class ProfileTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var fetchedResultsController: NSFetchedResultsController<Profile>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Profile"
        
        initFetchedResultsController()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections!.count
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
        
        // Configure the cell...
        let profile = self.fetchedResultsController.object(at: indexPath)
        let name = profile.name
        cell.textLabel?.text = name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let managedContext = self.fetchedResultsController.managedObjectContext
            let profile = self.fetchedResultsController.object(at: indexPath)
            managedContext.delete(profile)
            
            do {
                try managedContext.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Could not save delete: \(error)")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.profile = self.fetchedResultsController.object(at: indexPath)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "gameTableVC")
        
        self.performSegue(withIdentifier: "showGames", sender: self)
        
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func initFetchedResultsController() {
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [nameSort]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            guard let alert = alert, let textField = alert.textFields?[0], let name = textField.text, name.characters.count > 0 else {
                return
            }
            
            let managedContext = self.fetchedResultsController.managedObjectContext
            let profile = Profile(context: managedContext)
            profile.name = name
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}
