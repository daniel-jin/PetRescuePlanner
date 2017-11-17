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
        
        guard let petID = pet.id else { return }
        
        if let duplicatePet = PetController.shared.savedPets.filter({ $0.id == petID}).first {
            // There is a duplicate
            duplicatePet.dateAdded = NSDate()
            saveToPersistantStore()
            return
        } else {
        
        // There is no duplicat - create Pet object for Core Data saving
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
