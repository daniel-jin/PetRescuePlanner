//
//  Pet+Convenience.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CoreData

extension Pet {
    
    @discardableResult convenience init(age: String,
                                        animal: String,
                                        breeds: String,
                                        contactInfo: [String],
                                        petDescription: String,
                                        id: String,
                                        lastUpdate: String,
                                        media: [String],
                                        mix: String,
                                        name: String,
                                        options: [String],
                                        sex: String,
                                        shelterID: String,
                                        size: String,
                                        status: String,
                                        context: NSManagedObjectContext = CoreDataStack.context) {
        
        // Init with context first
        self.init(context: context)
        
        // Initialize rest of properties
        
        
    }
    
}
