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
    
    @discardableResult convenience init(dictionary: [String: Any],
                                        context: NSManagedObjectContext? = CoreDataStack.context) {
        // Init with context first
        if let context = context {
            self.init(context: context)
        } else {
            self.init(entity: Shelter.entity(), insertInto: nil)
        }
        
        // Check for dictionary keys and values
        guard let address = dictionary[ShelterKeys.addressKey] as? String,
            let name = dictionary[ShelterKeys.nameKey] as? String,
            let state = dictionary[ShelterKeys.stateKey] as? String,
            let city = dictionary[ShelterKeys.cityKey] as? String,
            let email = dictionary[ShelterKeys.emailKey] as? String,
            let phone = dictionary[ShelterKeys.phoneKey] as? String,
            let zip = dictionary[ShelterKeys.phoneKey] as? String else { return }
        
        // Initialize rest of properties
        self.address = address
        self.name = name
        self.state = state
        self.city = city
        self.email = email
        self.phone = phone
        self.zip = zip
        self.recordIDString = UUID().uuidString
    }
}
