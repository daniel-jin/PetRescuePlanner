//
//  Pet+Convenience.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CoreData
import CloudKit
import UIKit

extension Pet {
            
    @discardableResult convenience init(dictionary: [String: Any],
                                        context: NSManagedObjectContext? = CoreDataStack.context) {
        // Init with context first
        
        if let context = context {
            self.init(context: context)
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Pet", in: CoreDataStack.context)!
            self.init(entity: entity, insertInto: nil)
        }
        
        let apiKeys = API.Keys()
    
        // MARK: - Failable init
        guard let ageDictionary = dictionary[apiKeys.ageKey] as? [String:Any],
            let age = ageDictionary[apiKeys.itemKey] as? String,
            let animalDictionary = dictionary[apiKeys.animalKey] as? [String:Any],
            let animal = animalDictionary[apiKeys.itemKey] as? String,
            let breedsDictionary = dictionary[apiKeys.breedsKey] as? [String:[String:Any]],
            let breedDictionary = breedsDictionary[apiKeys.breedKey],
            let breed = breedDictionary[apiKeys.itemKey] as? String,
            let contactDictionary = dictionary[apiKeys.contactInfoKey] as? [String:[String:Any]],
            let phoneDictionary = contactDictionary[apiKeys.phoneKey],
            let phoneNumber = phoneDictionary[apiKeys.itemKey] as? String,
            let stateDictionary = contactDictionary[apiKeys.stateKey],
            let state = stateDictionary[apiKeys.itemKey] as? String,
            let emailDictionary = contactDictionary[apiKeys.emailKey],
            let email = emailDictionary[apiKeys.itemKey] as? String,
            let cityDictionary = contactDictionary[apiKeys.cityKey],
            let city = cityDictionary[apiKeys.itemKey] as? String,
            let zipDictionary = contactDictionary[apiKeys.zipKey],
            let zip = zipDictionary[apiKeys.itemKey] as? String,
            let addressDictionary = contactDictionary[apiKeys.addressKey],
            let address = addressDictionary[apiKeys.itemKey] as? String,
            let descriptionDictionary = dictionary[apiKeys.descriptionKey] as? [String:Any],
            let description = descriptionDictionary[apiKeys.itemKey] as? String,
            let idDictionary = dictionary[apiKeys.descriptionKey] as? [String:Any],
            let id = idDictionary[apiKeys.itemKey] as? String,
            let lastUpdateDictionary = dictionary[apiKeys.lastUpdatKey] as? [String:Any],
            let lastUpdate = lastUpdateDictionary[apiKeys.itemKey] as? String,
            let mediaDictionary = dictionary[apiKeys.mediaKey] as? [String:[String:Any]],
            let photosDictionary = mediaDictionary[apiKeys.photosKey],
            let photosArray = photosDictionary[apiKeys.photoKey] as? [[String: Any]],
            let lastImageDictionary = photosArray.last,
            let lastId = lastImageDictionary[apiKeys.imageId] as? String,
            let mixDictionary = dictionary[apiKeys.mixKey] as? [String:Any],
            let mix = mixDictionary[apiKeys.itemKey] as? String,
            let nameDictionary = dictionary[apiKeys.nameKey] as? [String:Any],
            let name = nameDictionary[apiKeys.itemKey] as? String,
            let optionsDictionary = dictionary[apiKeys.optionsKey] as? [String:Any],
            let optionArray = optionsDictionary[apiKeys.optionKey] as? [[String: Any]],
            let sexDictionary = dictionary[apiKeys.sexKey] as? [String:Any],
            let sex = sexDictionary[apiKeys.itemKey] as? String,
            let shelterIdDictionary = dictionary[apiKeys.shelterIdKey] as? [String:Any],
            let shelterId = shelterIdDictionary[apiKeys.itemKey] as? String,
            let sizeDictionary = dictionary[apiKeys.sizeKey] as? [String:Any],
            let size = sizeDictionary[apiKeys.itemKey] as? String,
            let statusDictionary = dictionary[apiKeys.statusKey] as? [String:Any],
            let status = statusDictionary[apiKeys.itemKey] as? String else { return }
        
        var photoEndpoints: [String] = []
        for photoDictionary in photosArray {
            guard let imageEndPoint = photoDictionary[apiKeys.itemKey] as? String else { return }
            photoEndpoints.append(imageEndPoint)
        }
        
        var optionsArray: [String] = []
        for optionsDictionary in optionArray {
            guard let option = optionsDictionary[apiKeys.itemKey] as? String else { return }
            optionsArray.append(option)
        }
        
        var contactDictionaryTemp: [String:String] = [:]
        contactDictionaryTemp[apiKeys.phoneKey] = phoneNumber
        contactDictionaryTemp[apiKeys.stateKey] = state
        contactDictionaryTemp[apiKeys.emailKey] = email
        contactDictionaryTemp[apiKeys.cityKey] = city
        contactDictionaryTemp[apiKeys.zipKey] = zip
        contactDictionaryTemp[apiKeys.addressKey] = address
        
        // Initialize rest of properties
        self.age = age
        self.animal = animal
        self.breeds = breed
        self.contactInfo = try? JSONSerialization.data(withJSONObject: contactDictionaryTemp, options: .prettyPrinted) as NSData
        self.petDescription = description
        self.id = id
        self.lastUpdate = lastUpdate
        self.media = try? JSONSerialization.data(withJSONObject: photoEndpoints, options: .prettyPrinted) as NSData
        self.mix = mix
        self.name = name
        self.options = try? JSONSerialization.data(withJSONObject: optionsArray, options: .prettyPrinted) as NSData
        self.sex = sex
        self.shelterID = shelterId
        self.size = size
        self.status = status
        self.recordIDString = UUID().uuidString
        self.imageIdCount = lastId
    }
}
