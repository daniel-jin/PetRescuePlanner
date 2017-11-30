//
//  Pet+CoreDataClass.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/8/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Pet)
class Pet: NSManagedObject, CloudKitSyncable {
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        print("New pet: \(self)")
    }
    
    var cloudKitRecordID: CKRecordID?
    
    // MARK: - Computed Properties
    
    private var apiKeys = API.Keys()

    // MARK: - Failable initializer (convert a Pet CKRecord into a Pet object)
    @discardableResult convenience required init?(cloudKitRecord: CKRecord, context: NSManagedObjectContext? = CoreDataStack.context) {
        
        if let context = context {
            self.init(context: context)
        } else {
            self.init(entity: Pet.entity(), insertInto: CoreDataStack.tempContext)
        }
        
        // Check for CKRecord's values and record type
        guard let age = cloudKitRecord[apiKeys.ageKey] as? String,
            let animal = cloudKitRecord[apiKeys.animalKey] as? String,
            let breeds = cloudKitRecord[apiKeys.breedsKey] as? String,
            let contactInfo = cloudKitRecord[apiKeys.contactInfoKey] as? NSData,
            let description = cloudKitRecord[apiKeys.descriptionKey] as? String,
            let id = cloudKitRecord[apiKeys.idKey] as? String,
            let lastUpdate = cloudKitRecord[apiKeys.lastUpdatKey] as? String,
            let media = cloudKitRecord[apiKeys.mediaKey] as? NSData,
            let mix = cloudKitRecord[apiKeys.mixKey] as? String,
            let name = cloudKitRecord[apiKeys.nameKey] as? String,
            let options = cloudKitRecord[apiKeys.optionsKey] as? NSData,
            let sex = cloudKitRecord[apiKeys.sexKey] as? String,
            let shelterId = cloudKitRecord[apiKeys.shelterIdKey] as? String,
            let size = cloudKitRecord[apiKeys.sizeKey] as? String,
            let status = cloudKitRecord[apiKeys.statusKey] as? String,
            let recordIDString = cloudKitRecord["recordIDString"] as? String,
            let dateAdded = cloudKitRecord["dateAdded"] as? NSDate,
            let imageIdCount = cloudKitRecord["imageIdCount"] as? String else {
                return nil
        }
        
        self.age = age
        self.animal = animal
        self.breeds = breeds
        self.contactInfo = contactInfo
        self.petDescription = description
        self.id = id
        self.lastUpdate = lastUpdate
        self.media = media
        self.mix = mix
        self.name = name
        self.options = options
        self.sex = sex
        self.shelterID = shelterId
        self.size = size
        self.status = status
        self.recordIDString = recordIDString
        self.dateAdded = dateAdded
        self.imageIdCount = imageIdCount
        self.cloudKitRecordID = cloudKitRecord.recordID
    }
}

// MARK: - Extension on CKRecord to convert a Pet into CKRecord
extension CKRecord {
    convenience init?(pet: Pet) {
        
        let apiKeys = API.Keys()
        
        // Init CKRecord
        let recordID = pet.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        self.init(recordType: CloudKit.petRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(pet.age, forKey: apiKeys.ageKey)
        self.setValue(pet.animal, forKey: apiKeys.animalKey)
        self.setValue(pet.breeds, forKey: apiKeys.breedsKey)
        self.setValue(pet.contactInfo, forKey: apiKeys.contactInfoKey)
        self.setValue(pet.petDescription, forKey: apiKeys.descriptionKey)
        self.setValue(pet.id, forKey: apiKeys.idKey)
        self.setValue(pet.lastUpdate, forKey: apiKeys.lastUpdatKey)
        self.setValue(pet.media, forKey: apiKeys.mediaKey)
        self.setValue(pet.mix, forKey: apiKeys.mixKey)
        self.setValue(pet.name, forKey: apiKeys.nameKey)
        self.setValue(pet.options, forKey: apiKeys.optionsKey)
        self.setValue(pet.sex, forKey: apiKeys.sexKey)
        self.setValue(pet.shelterID, forKey: apiKeys.shelterIdKey)
        self.setValue(pet.size, forKey: apiKeys.sizeKey)
        self.setValue(pet.status, forKey: apiKeys.statusKey)
        self.setValue(pet.recordIDString, forKey: "recordIDString")
        self.setValue(pet.dateAdded, forKey: "dateAdded")
        self.setValue(pet.imageIdCount, forKey: "imageIdCount")
        
        pet.cloudKitRecordID = recordID
    }
}
