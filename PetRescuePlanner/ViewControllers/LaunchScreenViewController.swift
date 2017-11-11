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
        
        let myStoryboard = UIStoryboard(name: "CustomizableSearch", bundle: nil)
        let searchViewController = myStoryboard.instantiateViewController(withIdentifier: "SearchViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        UserController.shared.fetchCurrentUser { (success) in
            
            if !success {
                UserController.shared.createUser(completion: { (success) in
                    if success {
                        appDelegate.window?.rootViewController = searchViewController
                    } else {
                        
                    }
                })
            } else {
                DispatchQueue.main.async {
                    appDelegate.window?.rootViewController = searchViewController
                }
            }
        }
    }
}
