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
    func add(pet: Pet, shouldSaveContext: Bool = true) {
        
        guard let petID = pet.id else { return }
        
        DispatchQueue.main.async {
            
            if PetController.shared.savedPets.filter({ $0.id == petID}).count == 0 {
                // There is no duplicate - create Pet object for Core Data saving
                let petToSave = Pet(context: CoreDataStack.context)
                
                petToSave.age = pet.age
                petToSave.animal = pet.animal
                petToSave.breeds = pet.breeds
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
                petToSave.cloudKitRecordID = pet.cloudKitRecordID
                
                guard shouldSaveContext else { return }
                self.saveToPersistantStore()
                
                PetController.shared.sortedPetArray.append(petID)
                PetController.shared.saveToiCloud()
            }
        }
    }
    
    
    // Delete from Core Data and update user's CKRef array
    func delete(pet: Pet, completion: @escaping () -> Void = {}) {
        
        if let petRecordID = pet.cloudKitRecordID,
            let petRef = UserController.shared.currentUser?.savedPets.filter({$0.recordID == petRecordID}).first {
            
            guard let index = UserController.shared.currentUser?.savedPets.index(of: petRef) else {
                completion()
                return
            }
            UserController.shared.currentUser?.savedPets.remove(at: index)
            
            
            if let currentUser = UserController.shared.currentUser,
                let userRecord = CKRecord(user: currentUser) {
                
                self.cloudKitManager.modifyRecords([userRecord], perRecordCompletion: nil) { (records, error) in
                    if let error = error {
                        NSLog("Error updating user record with saved pet \(error.localizedDescription)")
                        completion()
                        return
                    }
                    // Delete from MOC
                    
                    DispatchQueue.main.async {
                        
                        guard let moc = pet.managedObjectContext else {
                            completion()
                            return
                        }
                        moc.delete(pet)
                        
                        // Then save changes
                        self.saveToPersistantStore()
                        completion()
                    }
                }
            }
        }
    }
    
    // Delete Core Data object only
    func deleteCoreData(pet: Pet, completion: @escaping () -> Void = {}) {
        
        // Delete from MOC
        
        DispatchQueue.main.async {
            
            guard let moc = pet.managedObjectContext else {
                return
            }
            moc.delete(pet)
            
            // Then save changes
            self.saveToPersistantStore()
            completion()
        }
    }
    
    func clearPersistentStore() {
        PetController.shared.savedPets.forEach({ delete(pet: $0) })
    }
    
    
}
