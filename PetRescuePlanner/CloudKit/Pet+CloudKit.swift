//
//  Pet+CloudKit.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit

//extension Pet {
//    
//    // MARK: - Failable initializer (convert a Pet CKRecord into a Pet object)
//    init?(cloudKitRecord: CKRecord) {
//        // Check for CKRecord's values and record type
//        guard let age = cloudKitRecord[apiKeys.ageKey] as? String,
//            let animal = cloudKitRecord[apiKeys.animalKey] as? String,
//            let breeds = cloudKitRecord[apiKeys.breedKey] as? [String],
//            let contactInfo = cloudKitRecord[apiKeys.contactInfoKey] as? [String],
//            let description = cloudKitRecord[apiKeys.descriptionKey] as? String,
//            let id = cloudKitRecord[apiKeys.idKey] as? String,
//            let lastUpdate = cloudKitRecord[apiKeys.lastUpdatKey] as? String,
//            let media = cloudKitRecord[apiKeys.mediaKey] as? [String],
//            let mix = cloudKitRecord[apiKeys.mediaKey] as? String,
//            let name = cloudKitRecord[apiKeys.nameKey] as? String,
//            let options = cloudKitRecord[apiKeys.optionsKey] as? [String],
//            let sex = cloudKitRecord[apiKeys.sexKey] as? String,
//            let shelterId = cloudKitRecord[apiKeys.shelterIdKey] as? String,
//            let size = cloudKitRecord[apiKeys.sizeKey] as? String,
//            let status = cloudKitRecord[apiKeys.statusKey] as? String else { return nil }
//        
//        self.age = age
//        self.animal = animal
//        self.breeds = breeds
//        self.contactInfo = contactInfo
//        self.description = description
//        self.id = id
//        self.lastUpdate = lastUpdate
//        self.media = media
//        self.mix = mix
//        self.name = name
//        self.options = options
//        self.sex = sex
//        self.shelterId = shelterId
//        self.size = size
//        self.status = status
//
//        cloudKitRecordID = cloudKitRecord.recordID
//    }
//}

// MARK: - Extension on CKRecord to convert a Pet into CKRecord
extension CKRecord {
    convenience init(pet: Pet) {
        
        let apiKeys = API.Keys()
        
        let recordID = pet.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        // Init CKRecord
        self.init(recordType: CloudKit.petRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(pet.age, forKey: apiKeys.ageKey)
        self.setValue(pet.animal, forKey: apiKeys.animalKey)
        self.setValue(pet.breeds, forKey: apiKeys.breedsKey)
        self.setValue(pet.contactInfo, forKey: apiKeys.contactInfoKey)
        self.setValue(pet.description, forKey: apiKeys.descriptionKey)
        self.setValue(pet.id, forKey: apiKeys.idKey)
        self.setValue(pet.lastUpdate, forKey: apiKeys.lastUpdatKey)
        self.setValue(pet.media, forKey: apiKeys.mediaKey)
        self.setValue(pet.mix, forKey: apiKeys.mixKey)
        self.setValue(pet.name, forKey: apiKeys.nameKey)
        self.setValue(pet.options, forKey: apiKeys.optionsKey)
        self.setValue(pet.sex, forKey: apiKeys.sexKey)
        self.setValue(pet.shelterId, forKey: apiKeys.shelterIdKey)
        self.setValue(pet.size, forKey: apiKeys.sizeKey)
        self.setValue(pet.status, forKey: apiKeys.statusKey)
        
    }
}