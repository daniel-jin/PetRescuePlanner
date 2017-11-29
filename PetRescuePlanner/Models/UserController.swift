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
    
    var currentUser: User? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: CloudKit.CurrentUserWasSetNotification, object: nil)
            }
        }
    }
    
    var isUserLoggedIntoiCloud = false
    
    // CK Subscription setup for when user's CKRef array is modified
    func subscribeToPetRefUpdates() {
        
        guard let userRef = currentUser?.appleUserRef else { return }
        guard let subscriptionID = currentUser?.cloudKitRecordID?.recordName else {
            return
        }
        
        let predicate = NSPredicate(format: "appleUserRef == %@", userRef)
        let subscription = CKQuerySubscription(recordType: CloudKit.userRecordType, predicate: predicate, subscriptionID: subscriptionID, options: CKQuerySubscriptionOptions.firesOnRecordUpdate)
        let notificationInfo = CKNotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        // Save subscription here
        CKContainer.default().publicCloudDatabase.save(subscription) { (_, error) in
            if let error = error {
                NSLog("Eror saving the CK Subscription: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func checkSubscription(completion: @escaping ((_ subscribed: Bool) -> Void) = { _ in }) {
        
        guard let subscriptionID = currentUser?.cloudKitRecordID?.recordName else {
            completion(false)
            return
        }
        
        cloudKitManager.fetchSubscription(subscriptionID) { (subscription, error) in
            let subscribed = subscription != nil
            completion(subscribed)
        }
    }
    
    // Fetch Current User
    func fetchCurrentUser(completion: @escaping (_ success: Bool) -> Void = { _ in }) {
        
        // Fetch default Apple 'Users' RecordID
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            
            if let error = error { print(error.localizedDescription) }
            guard let appleUserRecordID = appleUserRecordID else { completion(false); return }
            
            // Create the CKRef with the Apple 'User's recordID so that we can perform the fetch for the Custom User record
            let appleUserRef = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            // Create a predicate with the ref that will go through all the users and filter to return the matching ref., i.e. custom user
            let predicate = NSPredicate(format: "appleUserRef == %@", appleUserRef)
            
            // Fetch the custom user record
            self.cloudKitManager.fetchRecordsWithType(CloudKit.userRecordType, predicate: predicate, recordFetchedBlock: nil, completion: { (records, error) in
                
                if let error = error {
                    NSLog("Error fetching matching user in cloudkit \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let currentUserRecord = records?.first else { completion(false); return }
                
                let currentUser = User(cloudKitRecord: currentUserRecord)
                self.currentUser = currentUser
                completion(true)
            })
        }
    }
    
    // MARK: - CRUD
    // Create
    func createUser(savedPetsRef: [CKReference], completion: @escaping ((_ success: Bool) -> Void) = { _ in }) {
        // Fetch default Apple "user" recordID
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            
            guard let appleUserRecordID = appleUserRecordID else { return completion(false) }
            
            let appleUserRef = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
            
            let user = User(appleUserRef: appleUserRef, savedPets: savedPetsRef)
            
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
                self.currentUser = User(cloudKitRecord: userRecord)
                completion(true)
            }
        }
    }
    
    // Delete
    
}
