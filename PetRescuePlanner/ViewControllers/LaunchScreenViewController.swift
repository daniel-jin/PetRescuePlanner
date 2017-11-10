//
//  LaunchScreenViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/9/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import CloudKit

class LaunchScreenViewController: UIViewController {
    
    let cloudKitManager = CloudKitManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudKitManager.fetchLoggedInUserRecord { (userRecord, error) in
            
            if let error = error {
                NSLog("Error fetching logged in iCloud user: \(error.localizedDescription)")
                return
            }
            
            let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let searchViewController = myStoryboard.instantiateViewController(withIdentifier: "SearchViewController")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            if let userRecord = userRecord {
                
                let user = User(cloudKitRecord: userRecord)
                
                UserController.currentUser = user
                
                appDelegate.window?.rootViewController = searchViewController
                
            } else {
                // Fetch default Apple "user" recordID
                CKContainer.default().fetchUserRecordID(completionHandler: { (appleUserRecordID, error) in
                    guard let appleUserRecordID = appleUserRecordID else { return }
                    
                    let appleUserRef = CKReference(recordID: appleUserRecordID, action: .deleteSelf)
                    
                    let user = User(appleUserRef: appleUserRef, savedPets: [])
                    UserController.currentUser = user
                    
                    appDelegate.window?.rootViewController = searchViewController

                })
            }
            
        }
        
        
    }

}
