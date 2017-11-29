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

class SavedPetsListTableViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    // prefetching store 
    
    var petImages: [String: UIImage] = [:]
    var pets = PetController.shared.savedPets

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
        return pets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "petListCell", for: indexPath) as? SavedPetTableViewCell else {
            return SavedPetTableViewCell()
        }
        
        let pet = pets[indexPath.row]
        guard let id = pet.id else { return ShelterPetTableViewCell() }
        
        if let petImage = petImages[id] {
            cell.pet = pet
            cell.petImage = petImage
        } else {
            cell.pet = pet
            cell.petImage = nil
            return cell
        }

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

            let petToDelete = pets[indexPath.row]
            
            // Delete from Core Data
            
            PetController.shared.delete(pet: petToDelete, completion: {
                
                DispatchQueue.main.async {
                    self.pets.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
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
            let pet = pets[indexPath.row]
            
            guard let destinationVC = segue.destination as? PetDetailCollectionTableViewController else { return }
            destinationVC.hideButton = false
            destinationVC.pet = pet
            
        }
    }
    
    // MARK: - Prefetching Delegate Method
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            let savedPet = PetController.shared.savedPets[indexPath.row]
                        
            PetController.shared.fetchImageFor(pet: savedPet, number: 2, completion: { (success, image) in
                if !success {
                    NSLog("error fetchingpet in pet controller")
                }
                guard let image = image, let id = savedPet.id else { return }
                self.petImages[id] = image
            })
        }
    }
}







