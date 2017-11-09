//
//  Shelter+CoreDataProperties.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/8/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//
//

import Foundation
import CoreData


extension Shelter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shelter> {
        return NSFetchRequest<Shelter>(entityName: "Shelter")
    }

    @NSManaged public var address: String?
    @NSManaged public var city: String?
    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var recordIDString: String?
    @NSManaged public var state: String?
    @NSManaged public var zip: String?

}
