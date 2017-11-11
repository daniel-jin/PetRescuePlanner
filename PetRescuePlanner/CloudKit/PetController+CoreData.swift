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

    func loadFromPersistantStore() {
        
        // Fetched results controller for Core Data
        let fetchedResultsController: NSFetchedResultsController<Pet>!
        
        //MARK: Fetched Results Controller configuration
        // Set up request
        let request: NSFetchRequest<Pet> = Pet.fetchRequest()
        
        // Set up sort descriptors for the request
        request.sortDescriptors = [NSSortDescriptor(key: "breed", ascending: true)]
        
        // Make the FRC using what we have now
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: nil, cacheName: nil)
        
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
    func add(pet: Pet) {
        
        // Because we are going to save this pet to Core Data, need to insert into CoreDataStack.context
        CoreDataStack.context.insert(pet)
        
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
