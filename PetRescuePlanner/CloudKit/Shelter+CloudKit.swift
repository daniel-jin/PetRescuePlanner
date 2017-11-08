//
//  Shelter+CloudKit.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

extension Shelter {
    
    private var shelterKeys: ShelterKeys {
        get {
            return ShelterKeys()
        }
    }
    
    // MARK: - Failable initializer (convert a Shelter CKRecord into a Shelter object)
    convenience init?(cloudKitRecord: CKRecord, context: NSManagedObjectContext? = CoreDataStack.context) {
        
        // Init with context first
        if let context = context {
            self.init(context: context)
        } else {
            self.init(entity: Shelter.entity(), insertInto: nil)
        }
     
        // Check for CKRecord's values
        guard let address = cloudKitRecord[shelterKeys.addressKey] as? String,
            let name = cloudKitRecord[shelterKeys.nameKey] as? String,
            let state = cloudKitRecord[shelterKeys.stateKey] as? String,
            let city = cloudKitRecord[shelterKeys.cityKey] as? String,
            let email = cloudKitRecord[shelterKeys.emailKey] as? String,
            let phone = cloudKitRecord[shelterKeys.phoneKey] as? String,
            let zip = cloudKitRecord[shelterKeys.phoneKey] as? String,
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
        
        let shelterKeys = ShelterKeys()
        
        // Init CKRecord
        guard let recordIDString = shelter.recordIDString else { return nil }
        let recordID = CKRecordID(recordName: recordIDString)
        self.init(recordType: CloudKit.petRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(shelter.address, forKey: shelterKeys.addressKey)
        self.setValue(shelter.city, forKey: shelterKeys.cityKey)
        self.setValue(shelter.email, forKey: shelterKeys.emailKey)
        self.setValue(shelter.name, forKey: shelterKeys.nameKey)
        self.setValue(shelter.phone, forKey: shelterKeys.phoneKey)
        self.setValue(shelter.state, forKey: shelterKeys.stateKey)
        self.setValue(shelter.zip, forKey: shelterKeys.zipKey)
        self.setValue(shelter.recordIDString, forKey: "recordIDString")
    }
}
