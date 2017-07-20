//
//  ProfileController.swift
//  BrainTrain
//
//  Created by Nikolai Gruschke on 15.07.17.
//  Copyright © 2017 Gruppe 4. All rights reserved.
//

import Foundation
import CoreData

protocol ProfileController {}

extension ProfileController {
    func delete(profile: Profile, block: ((Bool) -> (Void))? = nil) {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        managedContext.delete(profile)

        do {
            try managedContext.save()
            block?(true)
        } catch {
            print("Could not save delete: \(error)")
            block?(false)
        }
    }

    func exists(profileWithName name: String) -> Bool {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        let request: NSFetchRequest<Profile> = Profile.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        let count = try? managedContext.fetch(request).count
        return (count ?? 0) > 0
    }

    func create(profileWithName name: String, block: ((Bool) -> (Void))? = nil) {
        let managedContext = AppDelegate.shared.persistentContainer.viewContext
        let profile = Profile(context: managedContext)
        profile.name = name

        do {
            try managedContext.save()
            block?(true)
        } catch {
            print("Could not save: \(error)")
            block?(false)
        }
    }
}
