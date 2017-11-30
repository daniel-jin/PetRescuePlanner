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
        
        cloudKitManager.checkCloudKitAvailability { (success) in
            // iCloud account not logged in
            if !success {
                DispatchQueue.main.async {
                    self.changeRootViewController()
                }
            } else {
                // iCloud account is logged in - now check if we already have a user
                UserController.shared.fetchCurrentUser(completion: { (success) in
                    if !success {
                        UserController.shared.createUser(savedPetsRef: [CKReference](), completion: { (success) in
                            if success {
                                UserController.shared.isUserLoggedIntoiCloud = true
                                DispatchQueue.main.async {
                                    self.changeRootViewController()
                                }
                            }
                        })
                    } else {
                        // There is already a current user - go to customized search screen
                        UserController.shared.isUserLoggedIntoiCloud = true
                        
                        guard let currUser = UserController.shared.currentUser else {
                            return
                        }
                        
                        if currUser.savedPets.count < PetController.shared.savedPets.count {
                            
                            var CKPets: [Pet] = []
                            
                            let group = DispatchGroup()
                            
                            for petRef in currUser.savedPets {
                                
                                group.enter()
                                
                                self.cloudKitManager.fetchRecord(withID: petRef.recordID, completion: { (record, error) in
                                    if let error = error {
                                        NSLog("Unable to fetch record with the reference for the pet: \(error.localizedDescription)")
                                        group.leave()
                                        return
                                    }
                                    DispatchQueue.main.async {
                                        
                                        guard let record = record,
                                            let pet = Pet(cloudKitRecord: record) else {
                                                group.leave()
                                                return
                                        }
                                        
                                        CKPets.append(pet)
                                        group.leave()
                                    }
                                })
                            }
                            
                            group.notify(queue: DispatchQueue.main) {
                                
                                for pet in PetController.shared.savedPets {
                                    
                                    if !CKPets.contains(pet) {
                                        
                                        PetController.shared.deleteCoreData(pet: pet)
                                    }
                                }
                                UserController.shared.checkSubscription(completion: { (success) in
                                    if !success {
                                        UserController.shared.subscribeToPetRefUpdates()
                                    }
                                    
                                    DispatchQueue.main.async {
                                        self.changeRootViewController()
                                    }
                                })
                                
                                // After the current user is set, find user's subscription or subscribe the current user to changes
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.changeRootViewController()
                            }
                            // After the current user is set, find user's subscription or subscribe the current user to changes
                            UserController.shared.checkSubscription(completion: { (success) in
                                if !success {
                                    UserController.shared.subscribeToPetRefUpdates()
                                }
                            })
                            
                            DispatchQueue.main.async {
                                self.changeRootViewController()
                            }
                        }
                    }
                    
                    
                })
            }
        }
        DispatchQueue.main.async {
            self.changeRootViewController()
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










