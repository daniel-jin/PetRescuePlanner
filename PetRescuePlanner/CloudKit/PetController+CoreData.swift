//
//  PetController+CoreData.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/8/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CoreData
import CloudKit


extension PetController {
    
    // MARK: - SaveToPersistantStore()
    func saveToPersistantStore() {
        
        let moc = CoreDataStack.context
        
        do {
            return try moc.save()
        } catch {
            NSLog("Error saving to persistant store. \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD Functions
    // Create
    func add(pet: Pet) {
//        CoreDataStack.context.insert(pet)
        pet.managedObjectContext = CoreDataStack.context
        
        saveToPersistantStore()
    }
    
    
    // Delete
    func delete(pet: Pet) {
        
        // Delete from MOC
        guard let moc = pet.managedObjectContext else { return }
        moc.delete(pet)
        
        // Then save changes
        saveToPersistantStore()
    }
    
    
    
}
