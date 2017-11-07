//
//  Pet.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit

struct Pet: CloudKitSyncable {
    
    let apiKeys = API.Keys()
    
    // MARK: - Properties
    let age: String
    let animal: String
    let breeds: [String]
    let contactInfo: [String]
    let description: String
    let id: String
    let lastUpdate: String
    let media: [String]
    let mix: String
    let name: String
    let options: [String]
    let sex: String
    let shelterId: String
    let size: String
    let status: String
    
    var cloudKitRecordID: CKRecordID?
    
    // MARK: - Failable init
    init?(dictionary: [String: Any]) {
        guard let age = dictionary[apiKeys.ageKey] as? String,
            let animal = dictionary[apiKeys.animalKey] as? String,
            let breeds = dictionary[apiKeys.breedKey] as? [String],
            let contactInfo = dictionary[apiKeys.contactInfoKey] as? [String],
            let description = dictionary[apiKeys.descriptionKey] as? String,
            let id = dictionary[apiKeys.idKey] as? String,
            let lastUpdate = dictionary[apiKeys.lastUpdatKey] as? String,
            let media = dictionary[apiKeys.mediaKey] as? [String],
            let mix = dictionary[apiKeys.mediaKey] as? String,
            let name = dictionary[apiKeys.nameKey] as? String,
            let options = dictionary[apiKeys.optionsKey] as? [String],
            let sex = dictionary[apiKeys.sexKey] as? String,
            let shelterId = dictionary[apiKeys.shelterIdKey] as? String,
            let size = dictionary[apiKeys.sizeKey] as? String,
            let status = dictionary[apiKeys.statusKey] as? String else { return nil }
        
        self.age = age
        self.animal = animal
        self.breeds = breeds
        self.contactInfo = contactInfo
        self.description = description
        self.id = id
        self.lastUpdate = lastUpdate
        self.media = media
        self.mix = mix
        self.name = name
        self.options = options
        self.sex = sex
        self.shelterId = shelterId
        self.size = size
        self.status = status
    }
    
}

