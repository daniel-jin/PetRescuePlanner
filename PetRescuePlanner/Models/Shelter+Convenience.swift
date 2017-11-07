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
    
    @discardableResult convenience init(address: String,
                                        name: String,
                                        state: String,
                                        city: String,
                                        email: String,
                                        phone: String,
                                        zip: String,
                                        context: NSManagedObjectContext = CoreDataStack.context) {
        
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
