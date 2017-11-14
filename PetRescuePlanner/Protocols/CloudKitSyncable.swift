//
//  CloudKitSyncable.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

protocol CloudKitSyncable {
    
    init?(cloudKitRecord: CKRecord, context: NSManagedObjectContext?)
    
    var cloudKitRecordID: CKRecordID? { get set }
}

extension CloudKitSyncable {
    
    var isSynced: Bool {
        return cloudKitRecordID != nil
    }
    
    var cloudKitReference: CKReference? {
        guard let recordID = cloudKitRecordID else { return nil }
        return CKReference(recordID: recordID, action: .none)
    }
}
