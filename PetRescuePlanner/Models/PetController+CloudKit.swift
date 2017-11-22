//
//  PetController+CloudKit.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit

extension PetController {
    
    // MARK: - Properties
    var isSyncing: Bool {
        get {
            return false
        }
        set {}
    }
    
    // Fetch function to check if a user's swiped animal is already in their favorites list
    func fetchPet(pet: Pet, completion: @escaping (_ petRec: CKRecord?) -> Void) {
        
        guard let id = pet.id else {
            completion(nil)
            return
        }
        
        let predicate = NSPredicate(format: "id == %@", id)
        
        cloudKitManager.fetchRecordsWithType(CloudKit.petRecordType, predicate: predicate, recordFetchedBlock: nil) { (records, error) in
            if let error = error {
                NSLog("Error fetching record with the Pet's Record ID \(error.localizedDescription)" )
                completion(nil)
                return
            }
            guard let record = records?.first else { completion(nil);return }
            
            completion(record)
            
            return
        }
    }
    
    // MARK: - Delete
    func deleteFromCK(pet: Pet, completion: @escaping (_ success: Bool) -> Void) {
        
        // Get CKRecordID of the pet
        guard let petCKRecordID = pet.cloudKitRecordID else {
            NSLog("Error deleting pet from CloudKit - no CK Record ID")
            completion(false)
            return
        }
        
        // Delete from CloudKit
        self.cloudKitManager.deleteRecordWithID(petCKRecordID) { (recordID, error) in
            
            // Handle error
            if error != nil {
                NSLog("Error deleting pet record from CloudKit")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // MARK: - Helper Fetches
    private func recordsOf(type: String) -> [CloudKitSyncable] {
        switch type {
        case "Pet":
            return savedPets.flatMap{ $0 as CloudKitSyncable }
        default:
            return []
        }
    }
    
    func syncedRecordsOf(type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { $0.isSynced }
    }
    
    func unsyncedRecordsOf(type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { !$0.isSynced }
    }
    
    // MARK: - Sync
    func performFullSync(completion: @escaping (() -> Void) = { }) {
        
        if UserController.shared.isUserLoggedIntoiCloud {
            
            guard !isSyncing else {
                completion()
                return
            }
            
            isSyncing = true
            
            UserController.shared.fetchCurrentUser(completion: { (success) in
                self.pushChangesToCloudKit { (success, error) in
                    
                    self.fetchNewPetRecordsOf(type: "Pet") {
                        self.isSyncing = false
                        completion()
                    }
                }
            })
        }
    }
    
    func fetchNewPetRecordsOf(type: String, completion: @escaping (() -> Void) = { }) {
        
        var referencesToExclude = [CKReference]()
        referencesToExclude = self.syncedRecordsOf(type: type).flatMap { $0.cloudKitReference }
        
        //        var predicate: NSPredicate!
        //        predicate = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: [referencesToExclude])
        
        //        if referencesToExclude.isEmpty {
        //            predicate = NSPredicate(value: true)
        //        }
        
        guard let currUser = UserController.shared.currentUser,
            let currUserRec = CKRecord(user: currUser) else { return }
        
        cloudKitManager.fetchRecord(withID: currUserRec.recordID) { (record, error) in
            if let error = error {
                NSLog("Unable to fetch current user's record in CloudKit: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let record = record,
                let user = User(cloudKitRecord: record) else { completion(); return }
            
            let petRefs = user.savedPets
            let petRefsFiltered = petRefs.filter { !referencesToExclude.contains($0) }
            
            let group = DispatchGroup()
            
            for ref in petRefsFiltered {
                
                group.enter()
                
                self.cloudKitManager.fetchRecord(withID: ref.recordID, completion: { (record, error) in
                    if let error = error {
                        NSLog("Unable to fetch record with the reference for the pet: \(error.localizedDescription)")
                        group.leave()
                        return
                    }
                    
                    guard let record = record,
                        let pet = Pet(cloudKitRecord: record, context: nil) else {
                            group.leave()
                            return
                    }
                    
                    PetController.shared.add(pet: pet, shouldSaveContext: false)
                    
                    group.leave()
                })
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                self.saveToPersistantStore()
                completion()
            })
            
        }
        
        /*
         cloudKitManager.fetchRecordsWithType(CloudKit.petRecordType, predicate: predicate, sortDescriptors: nil) { (records, error) in
         
         defer { completion() }
         if let error = error {
         NSLog("Error fetching Pet CloudKit records: \(error)")
         return
         }
         guard let records = records else { return }
         
         let pets = records.flatMap { Pet(cloudKitRecord: $0, context: nil) }
         
         pets.forEach({ self.add(pet: $0) })
         
         print(self.savedPets.count)
         }
         */
    }
    
    func pushChangesToCloudKit(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
        
        // Pets that are unsynced (have not been saved to CloudKit)
        let unsavedPets = unsyncedRecordsOf(type: CloudKit.petRecordType) as? [Pet] ?? []
        
        var unsavedObjectsByRecord = [CKRecord: CloudKitSyncable]()
        
        UserController.shared.fetchCurrentUser()
        
        guard let unsavedUser = UserController.shared.currentUser,
            let userRec = CKRecord(user: unsavedUser) else {
                completion(false, nil)
                return
        }
        
        var petReferences = (syncedRecordsOf(type: CloudKit.petRecordType) as? [Pet] ?? []).flatMap({$0.cloudKitReference})
        
        let group = DispatchGroup()
        
        for pet in unsavedPets {
            
            group.enter()
            
            fetchPet(pet: pet, completion: { (existingRecord) in
                if let existingRecord = existingRecord {
                    
                    // If the pet exists, we just add its reference to the array of references for the User record.
                    let existingRecordReference = CKReference(record: existingRecord, action: .none)
                    petReferences.append(existingRecordReference)
                    
                    pet.cloudKitRecordID = existingRecord.recordID
                    
                    self.saveToPersistantStore()
                    
                    group.leave()
                } else {
                    
                    // If it doesn't exist, we need to save it to CloudKit and also add it to the array of references for the user.
                    guard let record = CKRecord(pet: pet) else {
                        NSLog("Error getting CK Record of the pet")
                        group.leave()
                        return
                    }
                    unsavedObjectsByRecord[record] = pet
                    group.leave()
                }
            })
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            for reference in unsavedUser.savedPets {
                if !petReferences.contains(reference) {
                    petReferences.append(reference)
                }
            }
            
            var unsavedRecords = Array(unsavedObjectsByRecord.keys)
            
            // CK References that have not been saved to CloudKit
            let unsavedPetReferences = unsavedRecords.flatMap({ CKReference(record: $0, action: .none)})
            
            petReferences.append(contentsOf: unsavedPetReferences)
            
            userRec.setValue(petReferences, forKey: CloudKit.savedPetsRefKey)
            
            unsavedRecords.append(userRec)
            
            self.cloudKitManager.saveRecords(unsavedRecords, perRecordCompletion: { (record, error) in
                guard let record = record else { return }
                unsavedObjectsByRecord[record]?.cloudKitRecordID = record.recordID
                
            }) { (records, error) in
                let success = records != nil
                completion(success, error)
            }
        }
    }
}
