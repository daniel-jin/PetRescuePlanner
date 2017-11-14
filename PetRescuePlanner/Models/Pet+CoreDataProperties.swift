//
//  Pet+CoreDataProperties.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/14/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//
//

import Foundation
import CoreData


extension Pet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pet> {
        return NSFetchRequest<Pet>(entityName: "Pet")
    }

    @NSManaged public var age: String?
    @NSManaged public var animal: String?
    @NSManaged public var breeds: String?
    @NSManaged public var contactInfo: NSData?
    @NSManaged public var id: String?
    @NSManaged public var imageIdCount: String?
    @NSManaged public var lastUpdate: String?
    @NSManaged public var media: NSData?
    @NSManaged public var mix: String?
    @NSManaged public var name: String?
    @NSManaged public var options: NSData?
    @NSManaged public var petDescription: String?
    @NSManaged public var recordIDString: String?
    @NSManaged public var sex: String?
    @NSManaged public var shelterID: String?
    @NSManaged public var size: String?
    @NSManaged public var status: String?
    @NSManaged public var dateAdded: NSDate?

}
