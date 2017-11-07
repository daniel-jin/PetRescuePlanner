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
                                        context: NSManagedObjectContext = CoreDataStack.context) {
        
        // Check for dictionary keys and values
        guard let address = dictionary[Shelter] as? String,
            let name = dictionary[apiKey.nameKey] as? String,
            let state = dictionary[apiKey.stateKey] as? String,
            let city = dictionary[apiKey.cityKey] as? String,
            let email = dictionary[apiKey.emailKey] as? String,
            let phone = dictionary[apiKey.phoneKey] as? String,
            let zip = dictionary[apiKey.phoneKey] as? String else { return nil }
        
        // Init with context first
        self.init(context: context)
        
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
