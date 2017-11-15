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
        
        
//        let container = CoreDataStack.container
//        container.performBackgroundTask { (context) in
//
//            do {
//                try moc.save()
//            } catch {
//                fatalError("BIG FAIL:\(error)")
//            }
//
//        }
        
    }
    
    // MARK: - CRUD Functions
    // Create
    func add(pet: Pet) {
        
        // Because we are going to save this pet to Core Data, need to insert into CoreDataStack.context
//        CoreDataStack.context.insert(pet)
        
        let petToSave = Pet(context: CoreDataStack.context)
        
        petToSave.age = pet.age
        petToSave.animal = pet.animal
        petToSave.breeds = pet.breeds
        petToSave.cloudKitRecordID = pet.cloudKitRecordID
        petToSave.contactInfo = pet.contactInfo
        petToSave.dateAdded = pet.dateAdded
        petToSave.id = pet.id
        petToSave.imageIdCount = pet.imageIdCount
        petToSave.lastUpdate = pet.lastUpdate
        petToSave.media = pet.media
        petToSave.mix = pet.mix
        petToSave.name = pet.name
        petToSave.options = pet.options
        petToSave.petDescription = pet.petDescription
        petToSave.recordIDString = pet.recordIDString
        petToSave.sex = pet.sex
        petToSave.shelterID = pet.shelterID
        petToSave.size = pet.size
        petToSave.status = pet.status
        
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
    
    
    func clearPersistentStore() {
        PetController.shared.savedPets.forEach({ delete(pet: $0) })
    }
    
    
}
