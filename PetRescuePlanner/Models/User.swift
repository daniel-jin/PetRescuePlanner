//
//  User.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/9/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit

struct User {
    
    let appleUserRef: CKReference
    var savedPets: [CKReference]
    var cloudKitRecordID: CKRecordID?
    
    init(appleUserRef: CKReference, savedPets: [CKReference]) {
        self.appleUserRef = appleUserRef
        self.savedPets = savedPets
    }
    
}

extension User {
    
    // MARK: - Failable initializer (convert a User CKRecord into a User object)
    init?(cloudKitRecord: CKRecord) {
        
        // Check for CKRecord's values and record type
        guard let appleUserRef = cloudKitRecord[CloudKit.appleUserRefKey] as? CKReference else { return nil }
        
        let savedPetsRef = cloudKitRecord[CloudKit.savedPetsRefKey] as? [CKReference] ?? []
        
        self.cloudKitRecordID = cloudKitRecord.recordID
        self.appleUserRef = appleUserRef
        self.savedPets = savedPetsRef

    }
}

extension CKRecord {
    // MARK: - Failable initializer (convert a User Object into a User CKRecord)
    convenience init?(user: User) {
        // Init CKRecord
        let recordID = user.cloudKitRecordID ?? CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: CloudKit.userRecordType, recordID: recordID)
        
        // Set values for the initialized CKRecord
        self.setValue(user.appleUserRef, forKey: CloudKit.appleUserRefKey)
        
        if user.savedPets.count > 0 {
            self.setValue(user.savedPets, forKey: CloudKit.savedPetsRefKey)
        } else {
            self.setValue([], forKey: CloudKit.savedPetsRefKey)
        }
    }
}
