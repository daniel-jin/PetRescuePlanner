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
            
    @discardableResult convenience init?(dictionary: [String: Any],
                                        context: NSManagedObjectContext? = CoreDataStack.context) {
        // Init with context first
        
        if let context = context {
            self.init(context: context)
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Pet", in: CoreDataStack.tempContext)!
            self.init(entity: entity, insertInto: nil)
        }
        
        let apiKeys = API.Keys()
        
        var contactDictionaryTemp: [String:String] = [:]

    
        // MARK: - Failable init
        if let ageDictionary = dictionary[apiKeys.ageKey] as? [String:Any] {
            if let age = ageDictionary[apiKeys.itemKey] as? String {
                self.age = age
            } else {
                self.age = "No age available"
            }
        }
        if let nameDictionary = dictionary[apiKeys.nameKey] as? [String:Any] {
            if let name = nameDictionary[apiKeys.itemKey] as? String {
                self.name = name
            } else {
                self.name = "No name availabel"
            }
        }
        
        if let animalDictionary = dictionary[apiKeys.animalKey] as? [String:Any] {
            if let animal = animalDictionary[apiKeys.itemKey] as? String {
                self.animal = animal
            } else {
                self.animal = "No animal available"
            }
        }
        
        if let breedsDictionary = dictionary[apiKeys.breedsKey] as? [String:[String:Any]] {
            if let breedDictionary = breedsDictionary[apiKeys.breedKey] {
                if let breed = breedDictionary[apiKeys.itemKey] as? String {
                    self.breeds = breed
                } else {
                    self.breeds = "No breed available"
                }
            }
        } else {
            if let breedsDictionary = dictionary[apiKeys.breedsKey] as? [String: Any] {
                if let breedsArray = breedsDictionary[apiKeys.breedKey] as? [[String: Any]]{
                    var tempBreed = ""
                    for breed in breedsArray {
                        tempBreed += "\(breed[apiKeys.itemKey]!), "
                    }
                    // FIXME: - remove last comma
                    self.breeds = tempBreed
                }
            }
        }
        ////////////////////////////////////////////////////////////////////////////////////
        if let contactDictionary = dictionary[apiKeys.contactInfoKey] as? [String:[String:Any]] {
            if let phoneDictionary = contactDictionary[apiKeys.phoneKey] {
                if let phoneNumber = phoneDictionary[apiKeys.itemKey] as? String {
                    contactDictionaryTemp[apiKeys.phoneKey] = phoneNumber
                   
                }
            }
            if let stateDictionary = contactDictionary[apiKeys.stateKey] {
                if let state = stateDictionary[apiKeys.itemKey] as? String {
                    contactDictionaryTemp[apiKeys.stateKey] = state

                }
            }
            if let emailDictionary = contactDictionary[apiKeys.emailKey] {
                if let email = emailDictionary[apiKeys.itemKey] as? String {
                    contactDictionaryTemp[apiKeys.emailKey] = email
              
                }
            }
            if let cityDictionary = contactDictionary[apiKeys.cityKey] {
                if let city = cityDictionary[apiKeys.itemKey] as? String {
                    contactDictionaryTemp[apiKeys.cityKey] = city
              
                }
            }
            if let zipDictionary = contactDictionary[apiKeys.zipKey] {
                if let zip = zipDictionary[apiKeys.itemKey] as? String {
                    contactDictionaryTemp[apiKeys.zipKey] = zip
                    
                }
            }
            if let addressDictionary = contactDictionary[apiKeys.addressKey] {
                if let address = addressDictionary[apiKeys.itemKey] as? String {
                    contactDictionaryTemp[apiKeys.addressKey] = address
                }
            }
            self.contactInfo = try! JSONSerialization.data(withJSONObject: contactDictionaryTemp, options: .prettyPrinted) as NSData
        }
        ////////////////////////////////////////////////////////////////////////////////////
        if let descriptionDictionary = dictionary[apiKeys.descriptionKey] as? [String:Any] {
            if let description = descriptionDictionary[apiKeys.itemKey] as? String {
                self.petDescription = description
            } else {
                self.petDescription = "No description available"
            }
        }
        if let idDictionary = dictionary[apiKeys.idKey] as? [String:Any] {
            if let id = idDictionary[apiKeys.itemKey] as? String {
                self.id = id
            } else {
                self.id = "No id available"
            }
        }
        if let lastUpdateDictionary = dictionary[apiKeys.lastUpdatKey] as? [String:Any] {
            if let lastUpdate = lastUpdateDictionary[apiKeys.itemKey] as? String {
                self.lastUpdate = lastUpdate
            } else {
                self.lastUpdate = "Last update not available"
            }
        }
        ////////////////////////////////////////////////////////////////////////////////////
        if let mediaDictionary = dictionary[apiKeys.mediaKey] as? [String:[String:Any]] {
            if let photosDictionary = mediaDictionary[apiKeys.photosKey] {
                if let photosArray = photosDictionary[apiKeys.photoKey] as? [[String: Any]] {
                    var photoEndpoints: [String] = []
                    for photoDictionary in photosArray {
                        guard let imageEndPoint = photoDictionary[apiKeys.itemKey] as? String else { return }
                        photoEndpoints.append(imageEndPoint)
                    }
                    if let lastImageDictionary = photosArray.last {
                        if let lastId = lastImageDictionary[apiKeys.imageId] as? String {
                            self.imageIdCount = lastId
                        }
                    }
                    self.media = try! JSONSerialization.data(withJSONObject: photoEndpoints, options: .prettyPrinted) as NSData
                }
            }
        }
        ////////////////////////////////////////////////////////////////////////////////////
        if let mixDictionary = dictionary[apiKeys.mixKey] as? [String:Any] {
            if let mix = mixDictionary[apiKeys.itemKey] as? String {
                self.mix = mix
            } else {
                self.mix = "No mix available"
            }
        }
        if let optionsDictionary = dictionary[apiKeys.optionsKey] as? [String:Any] {
            var optionsArray: [String] = []
            if !optionsDictionary.isEmpty {
                if let optionArray = optionsDictionary[apiKeys.optionKey] as? [[String: Any]] {
                    for optionsDictionary in optionArray {
                        guard let option = optionsDictionary[apiKeys.itemKey] as? String else { return }
                        optionsArray.append(option)
                    }
                }
            }
            self.options = try! JSONSerialization.data(withJSONObject: optionsArray, options: .prettyPrinted) as NSData
        }
        if let sexDictionary = dictionary[apiKeys.sexKey] as? [String:Any] {
            if let sex = sexDictionary[apiKeys.itemKey] as? String {
                self.sex = sex
            } else {
                self.sex = "No sex available"
            }
        }
        if let shelterIdDictionary = dictionary[apiKeys.shelterIdKey] as? [String:Any] {
            if let shelterId = shelterIdDictionary[apiKeys.itemKey] as? String {
                self.shelterID = shelterId
            } else {
                self.shelterID = "No shelter ID available"
            }
        }
        if let sizeDictionary = dictionary[apiKeys.sizeKey] as? [String:Any] {
            if let size = sizeDictionary[apiKeys.itemKey] as? String {
                self.size = size
            } else {
                self.size = "No size available"
            }
        }
        if let statusDictionary = dictionary[apiKeys.statusKey] as? [String:Any] {
            if let status = statusDictionary[apiKeys.itemKey] as? String {
                self.status = status
            } else {
                self.status = "No status available"
            }
        }
        
        self.dateAdded = NSDate()
        self.recordIDString = UUID().uuidString

    }
}
