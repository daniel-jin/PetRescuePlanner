//
//  Pet+CloudKit.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit

extension Pet {
    
    // MARK: - Failable initializer (convert a Pet CKRecord into a Pet object)
    init?(cloudKitRecord: CKRecord) {
        // Check for CKRecord's values and record type
        guard let age = cloudKitRecord[apiKeys.ageKey] as? String,
            let animal = cloudKitRecord[apiKeys.animalKey] as? String,
            let breeds = cloudKitRecord[apiKeys.breedKey] as? [String],
            let contactInfo = cloudKitRecord[apiKeys.contactInfoKey] as? [String],
            let description = cloudKitRecord[apiKeys.descriptionKey] as? String,
            let id = cloudKitRecord[apiKeys.idKey] as? String,
            let lastUpdate = cloudKitRecord[apiKeys.lastUpdatKey] as? String,
            let media = cloudKitRecord[apiKeys.mediaKey] as? [String],
            let mix = cloudKitRecord[apiKeys.mediaKey] as? String,
            let name = cloudKitRecord[apiKeys.nameKey] as? String,
            let options = cloudKitRecord[apiKeys.optionsKey] as? [String],
            let sex = cloudKitRecord[apiKeys.sexKey] as? String,
            let shelterId = cloudKitRecord[apiKeys.shelterIdKey] as? String,
            let size = cloudKitRecord[apiKeys.sizeKey] as? String,
            let status = cloudKitRecord[apiKeys.statusKey] as? String else { return nil }
        
        
        
        cloudKitRecordID = cloudKitRecord.recordID
    }
}

// MARK: - Extension on CKRecord to convert a Pet into CKRecord
extension CKRecord {
    convenience init(pet: Pet) {
        
        let recordID = pet.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        // Init CKRecord
        self.init(recordType: CloudKit.petRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(pet.age, forKey: API.Keys.)
        self.setValue(user.appleUserRef, forKey: Keys.appleUserRefKey)
        
        if user.chatGroupsRef.count > 0 {
            self.setValue(user.chatGroupsRef, forKey: Keys.chatGroupsRefKey)
        }
        
        let asset = CKAsset(fileURL: user.temporaryPhotoURL)
        self.setValue(asset, forKey: Keys.userPhotoKey)
    }
}
