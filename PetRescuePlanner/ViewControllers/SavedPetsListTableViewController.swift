//
//  SavedPetsListTableViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/10/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class SavedPetsListTableViewController: UITableViewController {

    // MARK: - Table View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Saved Pets"
        
        PetController.shared.performFullSync {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PetController.shared.savedPets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "petListCell", for: indexPath) as? SavedPetTableViewCell else {
            return SavedPetTableViewCell()
        }
        
        let pet = PetController.shared.savedPets[indexPath.row]
        cell.pet = pet

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let petToDelete = PetController.shared.savedPets[indexPath.row]
            
            // Delete from Core Data
            
            PetController.shared.delete(pet: petToDelete, completion: {
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                // Sync with CloudKit to update
                PetController.shared.performFullSync()
            })
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue to Detail view with pet and fetch shelter
        if segue.identifier == "petCellToDetailSegue" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let pet = PetController.shared.savedPets[indexPath.row]
            
            guard let destinationVC = segue.destination as? PetDetailCollectionTableViewController else { return }
            destinationVC.hideButton = false
            destinationVC.pet = pet
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            
        }
    }
}







