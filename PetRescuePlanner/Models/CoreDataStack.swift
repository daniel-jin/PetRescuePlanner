//
//  CoreDataStack.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "PetRescuePlanner")
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static var context: NSManagedObjectContext { return container.viewContext }
    let pet: Pet = context.insertObject()
    let shelter: Shelter = context.insertObject()
}

extension NSManagedObjectContext {
    
    public func insertObject<T: NSManagedObject>() -> T {
        guard let object = NSEntityDescription.insertNewObject(forEntityName: T.entity().name!, into: self) as? T
            else { fatalError("Invalid Core Data Model.") }
        return object;
    }
}
