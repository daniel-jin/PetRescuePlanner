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
    var isSyncing: Bool = false
    
    // CloudKit Manager instance
    private var cloudKitManager: CloudKitManager {
        get {
            return CloudKitManager()
        }
    }
    
    // MARK: - Save
    func saveToCK(pet: Pet, completion: @escaping (_ success: Bool) -> Void) {
        
        // Get CK record of the pet to save to CK
        let petCKRecord = CKRecord(pet: pet)
        
        // Save to CloudKit
        self.cloudKitManager.save(petCKRecord) { (error) in
            
            // Handle error
            if error != nil {
                NSLog("Error saving pet to CloudKit")
                completion(false)
                return
            }
            // If no errors, complete with success as true
            completion(true)
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
    private func petRecords() -> [CloudKitSyncable] {
        return pets.flatMap { $0 as CloudKitSyncable }
    }
    
    func syncedRecords() -> [CloudKitSyncable] {
        return petRecords().filter { $0.isSynced }
    }
    
    func unsyncedRecords() -> [CloudKitSyncable] {
        return petRecords().filter { !$0.isSynced }
    }
    
    // MARK: - Sync
    func performFullSync(completion: @escaping (() -> Void) = { }) {
        
        guard !isSyncing else {
            completion()
            return
        }
        
        isSyncing = true
        
        pushChangesToCloudKit { (success, error) in
            
            self.fetchNewPetRecords() {
                self.isSyncing = false
                completion()
            }
        }
    }
    
    func fetchNewPetRecords(completion: @escaping (() -> Void) = { }) {
        
        var referencesToExclude = [CKReference]()
        var predicate: NSPredicate!
        referencesToExclude = self.syncedRecords().flatMap { $0.cloudKitReference }
        predicate = NSPredicate(format: "NOT(recordID IN $@)", argumentArray: [referencesToExclude])
        
        if referencesToExclude.isEmpty {
            predicate = NSPredicate(value: true)
        }
        
        // TODO: Code sortdescriptors to order by most recently saved/favorited
        /*
        let sortDescriptors: [NSSortDescriptor]?
        let sortDescriptor = NSSortDescriptor(key: "savedDateTime", ascending: true)
        sortDescriptors = [sortDescriptor]
         */
        
        cloudKitManager.fetchRecordsWithType(CloudKit.petRecordType, predicate: predicate, sortDescriptors: nil) { (records, error) in
            
            defer { completion() }
            if let error = error {
                NSLog("Error fetching Pet CloudKit records: \(error)")
                return
            }
            guard let records = records else { return }
            
            let petsToAdd = records.flatMap { Pet.init(cloudKitRecord: $0) }
            self.pets.append(contentsOf: petsToAdd)
        }
    }
    
    func pushChangesToCloudKit(completion: @escaping ((_ success: Bool, _ error: Error?) -> Void) = { _,_ in }) {
        
        let unsavedPets = unsyncedRecords() as? [Pet] ?? []
        var unsavedObjectsByRecord = [CKRecord: CloudKitSyncable]()
        for pet in unsavedPets {
            let record = CKRecord(pet: pet)
            unsavedObjectsByRecord[record] = pet
        }
        let unsavedRecords = Array(unsavedObjectsByRecord.keys)
        
        cloudKitManager.saveRecords(unsavedRecords, perRecordCompletion: { (record, error) in
            guard let record = record else { return }
            unsavedObjectsByRecord[record]?.cloudKitRecordID = record.recordID
            
        }) { (records, error) in
            
            let success = records != nil
            completion(success, error)
        }
    }
    
    
}
