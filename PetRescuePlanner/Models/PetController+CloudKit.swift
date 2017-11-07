//
//  PetController+CloudKit.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit

extension PetController {
    
    // CloudKit Manager instance
    private var cloudKitManager: CloudKitManager {
        get {
            return CloudKitManager()
        }
    }
    
    // MARK: - Save function
    func saveToCK(pet: Pet, completion: @escaping (_ success: Bool) -> Void) {
        
        // Get CK record of the pet to save to CK
        let petCKRecord = CKRecord(pet: pet)
        
        // Save to CloudKit
        self.cloudKitManager.save(petCKRecord) { (error) in
            
            // Handle error
            if error != nil {
                NSLog("Error saving pet to CloudKit")
                completion(false)
                return
            }
            // If no errors, complete with success as true
            completion(true)
        }
    }
    
    
    
}
