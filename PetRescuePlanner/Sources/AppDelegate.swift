//
//  AppDelegate.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // If we want to flush core data objects for Pet
        //        PetController.shared.clearPersistentStore()
        //        print(PetController.shared.savedPets.count)
        //
//                // If we want to flush cloudkit records for Pet
//                CloudKitManager().flushPetRecords()
        
        // Override point for customization after application launch.
        
        guard let michaelMarker = UIFont(name: "Michael Marker Lite", size: 20.0) else { return false }
        let navBar = UINavigationBar.appearance()
        
        navBar.barTintColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        navBar.titleTextAttributes = [
            NSAttributedStringKey.font: michaelMarker,
            NSAttributedStringKey.foregroundColor: UIColor.white]
        navBar.tintColor = UIColor.white
        
//        PetController.shared.sortedPetArray = []
//        PetController.shared.saveToiCloud()
        
        PetController.shared.loadFromiCloud()
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // fetch the current user from CK, compare arrays of references, delete if necessary
        UserController.shared.fetchCurrentUser { (success) in
            
            let cloudKitManager = CloudKitManager()
            
            if success {
                
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
                        
                        cloudKitManager.fetchRecord(withID: petRef.recordID, completion: { (record, error) in
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
                        // After the current user is set, find user's subscription or subscribe the current user to changes
                    }
                }
            } else {
                NSLog("Unable to fetch current user")
                return
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

