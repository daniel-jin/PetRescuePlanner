//
//  Shelter+Convenience.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CoreData

extension Shelter {
    
    private var shelterKeys: ShelterKeys {
        get {
            return ShelterKeys()
        }
    }
    
    @discardableResult convenience init(dictionary: [String: Any],
                                        context: NSManagedObjectContext = CoreDataStack.context) {
        
        // Init with context first
        self.init(context: context)
        
        // Check for dictionary keys and values
        guard let address = dictionary[shelterKeys.addressKey] as? String,
            let name = dictionary[shelterKeys.nameKey] as? String,
            let state = dictionary[shelterKeys.stateKey] as? String,
            let city = dictionary[shelterKeys.cityKey] as? String,
            let email = dictionary[shelterKeys.emailKey] as? String,
            let phone = dictionary[shelterKeys.phoneKey] as? String,
            let zip = dictionary[shelterKeys.phoneKey] as? String else { return }
        
        // Initialize rest of properties
        self.address = address
        self.name = name
        self.state = state
        self.city = city
        self.email = email
        self.phone = phone
        self.zip = zip
    }
}
