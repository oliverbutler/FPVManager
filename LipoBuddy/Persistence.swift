//
//  Persistence.swift
//  LipoBuddy
//
//  Created by Oliver Butler on 02/02/2021.
//

import Foundation
import CoreData

struct PersistenceController {
    // Singleton for the whole app
    static let shared = PersistenceController()
    
    // Storage for Core Data
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }
    
}
