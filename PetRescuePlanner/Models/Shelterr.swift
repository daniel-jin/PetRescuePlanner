//
//  Shelterr.swift
//  PetRescuePlanner
//
//  Created by Brian Licea on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

struct Shelterr {
    let apiKey = ShelterKeys()
    
    // Mark: - Properties
    let address: String
    let name: String
    let state: String
    let city: String
    let email: String
    let phone: String
    let zip: String
    
    // Mark: - Failable
    init?(dictionary: [String: Any]) {
        guard let address = dictionary[apiKey.addressKey] as? String,
            let name = dictionary[apiKey.nameKey] as? String,
        let state = dictionary[apiKey.stateKey] as? String,
        let city = dictionary[apiKey.cityKey] as? String,
        let email = dictionary[apiKey.emailKey] as? String,
        let phone = dictionary[apiKey.phoneKey] as? String,
            let zip = dictionary[apiKey.phoneKey] as? String else { return nil }
        
        self.address = address
        self.name = name
        self.state = state
        self.city = city
        self.email = email
        self.phone = phone
        self.zip = zip
        
        
        
        
    }
}
