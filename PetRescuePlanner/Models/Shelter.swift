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
    let longitude: Double
    let latitude: Double
    
    
    
    // Mark: - Failable
    init?(dictionary: [String: Any]) {
        guard let addressDictionary = dictionary[ShelterKeys.addressKey] as? [String: Any],
            let address = addressDictionary[apiKey.itemKey] as? String?,
            let idDictionary = dictionary[ShelterKeys.idKey] as? [String: Any],
            let id = idDictionary[apiKey.itemKey] as? String,
            let nameDictionary = dictionary[ShelterKeys.nameKey] as? [String: Any],
            let name = nameDictionary[apiKey.itemKey] as? String,
            let stateDictionary = dictionary[ShelterKeys.stateKey] as? [String: Any],
            let state = stateDictionary[apiKey.itemKey] as? String,
            let cityDictionary = dictionary[ShelterKeys.cityKey] as? [String: Any],
            let city = cityDictionary[apiKey.itemKey] as? String,
            let emailDictionary = dictionary[ShelterKeys.emailKey] as? [String: Any],
            let email = emailDictionary[apiKey.itemKey] as? String,
            let phoneDictionary = dictionary[ShelterKeys.phoneKey] as? [String: Any],
            let phone = phoneDictionary[apiKey.itemKey] as? String,
            let longitudeDictionary = dictionary[ShelterKeys.longitudeKey] as? [String: Any],
            let longitude = longitudeDictionary[apiKey.itemKey] as? String,
            let latitudeDictionary = dictionary[ShelterKeys.latitudeKey] as? [String: Any],
            let latitude = latitudeDictionary[apiKey.itemKey] as? String,
            let zipDictionary = dictionary[ShelterKeys.zipKey] as? [String: Any],
            let zip = zipDictionary[apiKey.itemKey] as? String else { return nil }
        
        if let address = address {
            self.address = address
        } else {
            self.address = ""
        }
        
        self.id = id 
        self.name = name
        self.state = state
        self.city = city
        self.email = email
        self.phone = phone
        self.longitude = Double(longitude)!
        self.latitude = Double(latitude)!
        self.zip = zip
    }
}
