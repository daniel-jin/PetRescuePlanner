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
    
    var errorColor = UIColor.red
    var warningColor = UIColor.yellow

    override func viewDidLoad() {
        super.viewDidLoad()

        UserController.shared.fetchCurrentUser { (success) in
            
            if !success {
                UserController.shared.createUser(savedPetsRef: [CKReference](), completion: { (success) in
                    if success {
                        DispatchQueue.main.async {
                            self.changeRootViewController()
                        }
                    } else {
                        self.presentAlertWith(title: "Warning: no iCloud Account Found", message: "In order to sync your saved data to multiple devices you need to be signed into an iCloud account.", color: self.warningColor)
                    }
                })
            } else {
                DispatchQueue.main.async {
                    self.changeRootViewController()
                }
            }
        }
    }
    
    func changeRootViewController() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let myStoryboard = UIStoryboard(name: "CustomizableSearch", bundle: nil)
        let searchViewController = myStoryboard.instantiateViewController(withIdentifier: "SearchViewController")
        
        appDelegate.window?.rootViewController = searchViewController
    }
    
    func presentAlertWith(title: String, message: String, color: UIColor) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            self.changeRootViewController()
        })
        
        alertController.addAction(okAction)
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = color
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}










