//
//  UserController.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/9/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    // MARK: - Properties
    static let shared = UserController()
    
    private let cloudKitManager = CloudKitManager()
    
    static var currentUser: User? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: CloudKit.CurrentUserWasSetNotification, object: nil)
            }
        }
    }
    
    // MARK: - CRUD
    // Create
    func createUser(completion: @escaping (_ success: Bool) -> Void) {
        // Fetch default Apple "user" recordID
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            guard let appleUserRecordID = appleUserRecordID else { return }
            
            let appleUserRef = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let user = User(appleUserRef: appleUserRef, savedPets: [])
            
            // Get the CKRecord of the user object
            guard let userRecord = CKRecord(user: user) else { return }
            
            // Then use CloudKitManager save function
            self.cloudKitManager.save(userRecord) { (error) in
            
                // Handle errors
                if let error = error {
                    NSLog(error.localizedDescription)
                    completion(false)
                    return
                }
                
                // Set current user and complete
                UserController.currentUser = user
                completion(true)
            }
        }
    }
    
    // Delete
    
}
