//
//  Shelter.swift
//  PetRescuePlanner
//
//  Created by Brian Licea on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

struct Shelter {
    let apiKey = API.Keys()
    
    // Mark: - Properties
    let address: String
    let id: String
    let name: String
    let state: String
    let city: String
    let email: String
    let phone: String
    let zip: String
    
    // Mark: - Failable
    init?(dictionary: [String: Any]) {
        guard let petfinderDictionary = dictionary[ShelterKeys.petfinderKey] as? [String: Any],
            let shelterDictionary = petfinderDictionary[ShelterKeys.shelterKey] as? [String: Any],
            let addressDictionary = shelterDictionary[ShelterKeys.addressKey] as? [String: Any],
            let address = addressDictionary[apiKey.itemKey] as? String,
            let idDictionary = shelterDictionary[ShelterKeys.id] as? [String: Any],
            let id = idDictionary[apiKey.itemKey] as? String,
            let nameDictionary = shelterDictionary[ShelterKeys.nameKey] as? [String: Any],
            let name = nameDictionary[apiKey.itemKey] as? String,
            let stateDictionary = shelterDictionary[ShelterKeys.stateKey] as? [String: Any],
            let state = stateDictionary[apiKey.itemKey] as? String,
            let cityDictionary = shelterDictionary[ShelterKeys.cityKey] as? [String: Any],
            let city = cityDictionary[apiKey.itemKey] as? String,
            let emailDictionary = shelterDictionary[ShelterKeys.emailKey] as? [String: Any],
            let email = emailDictionary[apiKey.itemKey] as? String,
            let phoneDictionary = shelterDictionary[ShelterKeys.phoneKey] as? [String: Any],
            let phone = phoneDictionary[apiKey.itemKey] as? String,
            let zipDictionary = shelterDictionary[ShelterKeys.phoneKey] as? [String: Any],
            let zip = zipDictionary[apiKey.itemKey] as? String else { return nil }
        
        self.address = address//
        self.id = id 
        self.name = name//
        self.state = state//
        self.city = city//
        self.email = email
        self.phone = phone
        self.zip = zip
        
    }
}
