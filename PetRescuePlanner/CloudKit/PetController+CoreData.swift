//
//  PetController+CoreData.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/8/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CoreData

extension PetController {
    
    convenience init() {
        
        // MARK: - Fetched REsults Controller configuration
        // set up request
        let request: NSFetchRequest<Pet> = Pet.fetchRequest()
        
        // Set up sort descriptors for the request
        request.sortDescriptors = [NSSortDescriptor(key: "recordIDString", ascending: true)]
        
        // Fetched results controller
        let fetchedResultsController: NSFetchedResultsController<Pet> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
        // Perform fetch - handle errors
        do {
            try fetchedResultsController.performFetch()
        } catch {
            NSLog("There was an error configuring the fetched results. \(error.localizedDescription)")
        }
    }
    
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
    func add(
    
    
    // Delete
    func delete(pet: Pet) {
        
        // Delete from MOC
        guard let moc = pet.managedObjectContext else { return }
        moc.delete(pet)
        
        // Then save changes
        saveToPersistantStore()
    }
    
    
    
}
