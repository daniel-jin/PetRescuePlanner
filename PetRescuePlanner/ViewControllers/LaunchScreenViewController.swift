//
//  LaunchScreenViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Jin on 11/9/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    let cloudKitManager = CloudKitManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cloudKitManager.fetchLoggedInUserRecord { (userRecord, error) in
            
            if let error = error {
                NSLog("Error fetching logged in iCloud user: \(error.localizedDescription)")
                return
            }
            
            if let userRecord = userRecord {
                
                
                
            }
            
        }
        
        
    }

}
