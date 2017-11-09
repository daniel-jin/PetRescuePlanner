//
//  Shelter+CoreDataClass.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/8/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Shelter)
class Shelter: NSManagedObject, CloudKitSyncable {

    var cloudKitRecordID: CKRecordID? {
        guard let recordIDString = self.recordIDString else { return nil }
        return CKRecordID(recordName: recordIDString)
    }
    
    // MARK: - Failable initializer (convert a Shelter CKRecord into a Shelter object)
    convenience required init?(cloudKitRecord: CKRecord, context: NSManagedObjectContext? = CoreDataStack.context) {
        
        // Init with context first
        if let context = context {
            self.init(context: context)
        } else {
            self.init(entity: Shelter.entity(), insertInto: nil)
        }
        
        // Check for CKRecord's values
        guard let address = cloudKitRecord[ShelterKeys.addressKey] as? String,
            let name = cloudKitRecord[ShelterKeys.nameKey] as? String,
            let state = cloudKitRecord[ShelterKeys.stateKey] as? String,
            let city = cloudKitRecord[ShelterKeys.cityKey] as? String,
            let email = cloudKitRecord[ShelterKeys.emailKey] as? String,
            let phone = cloudKitRecord[ShelterKeys.phoneKey] as? String,
            let zip = cloudKitRecord[ShelterKeys.zipKey] as? String,
            let recordIDString = cloudKitRecord["recordIDString"] as? String else { return }
        
        // Initialize rest of properties
        self.address = address
        self.name = name
        self.state = state
        self.city = city
        self.email = email
        self.phone = phone
        self.zip = zip
        self.recordIDString = recordIDString
        
    }
}

// MARK: - Extension on CKRecord to convert a Shelter into CKRecord
extension CKRecord {
    convenience init?(shelter: Shelter) {
        
        // Init CKRecord
        guard let recordIDString = shelter.recordIDString else { return nil }
        let recordID = CKRecordID(recordName: recordIDString)
        self.init(recordType: CloudKit.petRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(shelter.address, forKey: ShelterKeys.addressKey)
        self.setValue(shelter.city, forKey: ShelterKeys.cityKey)
        self.setValue(shelter.email, forKey: ShelterKeys.emailKey)
        self.setValue(shelter.name, forKey: ShelterKeys.nameKey)
        self.setValue(shelter.phone, forKey: ShelterKeys.phoneKey)
        self.setValue(shelter.state, forKey: ShelterKeys.stateKey)
        self.setValue(shelter.zip, forKey: ShelterKeys.zipKey)
        self.setValue(shelter.recordIDString, forKey: "recordIDString")
    }
}
