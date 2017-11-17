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
        if let addressDictionary = dictionary[ShelterKeys.addressKey] as? [String: Any] {
            if let address = addressDictionary[apiKey.itemKey] as? String {
                self.address = address
            } else {
                self.address = ShelterKeys.noInfo
            }
        } else {
            self.address = ShelterKeys.noInfo
        }
        
        if let idDictionary = dictionary[ShelterKeys.idKey] as? [String: Any]{
            if let id = idDictionary[apiKey.itemKey] as? String {
                self.id = id
            } else {
                self.id = ShelterKeys.noInfo
            }
        } else {
            self.id = ShelterKeys.noInfo
        }
    
        if let nameDictionary = dictionary[ShelterKeys.nameKey] as? [String: Any] {
            if let name = nameDictionary[apiKey.itemKey] as? String {
                self.name = name
            } else {
                self.name = ShelterKeys.noInfo
            }
        } else {
            self.name = ShelterKeys.noInfo
        }
        
        if let stateDictionary = dictionary[ShelterKeys.stateKey] as? [String: Any] {
            if let state = stateDictionary[apiKey.itemKey] as? String {
                self.state = state
            } else {
                self.state = ShelterKeys.noInfo
            }
        } else {
            self.state = ShelterKeys.noInfo
        }
        
        if let cityDictionary = dictionary[ShelterKeys.cityKey] as? [String: Any] {
            if let city = cityDictionary[apiKey.itemKey] as? String {
                self.city = city
            } else {
                self.city = ShelterKeys.noInfo
            }
        } else {
            self.city = ShelterKeys.noInfo
        }
        
        if let emailDictionary = dictionary[ShelterKeys.emailKey] as? [String: Any] {
            if let email = emailDictionary[apiKey.itemKey] as? String {
                self.email = email
            } else {
                self.email = ShelterKeys.noInfo
            }
        } else {
            self.email = ShelterKeys.noInfo
        }
        
        if let phoneDictionary = dictionary[ShelterKeys.phoneKey] as? [String: Any] {
            if let phone = phoneDictionary[apiKey.itemKey] as? String {
                self.phone = phone
            } else {
                self.phone = ShelterKeys.noInfo
            }
        } else {
            self.phone = ShelterKeys.noInfo
        }
        
        if let zipDictionary = dictionary[ShelterKeys.zipKey] as? [String: Any] {
            if let zip = zipDictionary[apiKey.itemKey] as? String {
                self.zip = zip
            } else {
                self.zip = ShelterKeys.noInfo
            }
        } else {
            self.zip = ShelterKeys.noInfo
        }
        
        // Mark: - try to come back and change that value if we dont get a lon or lat and make it so itll send you a message telling you that we cant get the directions
        if let longitudeDictionary = dictionary[ShelterKeys.longitudeKey] as? [String: Any] {
            if let longitude = longitudeDictionary[apiKey.itemKey] as? String {
                self.longitude = Double(longitude)!
            } else {
                self.longitude = ShelterKeys.fakeLanLon
            }
        } else {
            self.longitude = ShelterKeys.fakeLanLon
        }
        
        if let latitudeDictionary = dictionary[ShelterKeys.latitudeKey] as? [String: Any] {
            if let latitude = latitudeDictionary[apiKey.itemKey] as? String {
                self.latitude = Double(latitude)!
            } else {
                self.latitude = ShelterKeys.fakeLanLon
            }
        } else {
            self.latitude = ShelterKeys.fakeLanLon
        }
        
        
    
    }
}

