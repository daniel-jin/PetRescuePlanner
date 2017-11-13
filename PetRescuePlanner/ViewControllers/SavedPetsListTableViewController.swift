//
//  SavedPetsListTableViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/10/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class SavedPetsListTableViewController: UITableViewController {
    
    var savedPets: [Pet]? = []
//    {
//        didSet{
//            self.tableView.reloadData()
//        }
//    }
    
    // MARK: - Table View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pets = savedPets else { return 0 }
        return pets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "petListCell", for: indexPath) as? SavedPetTableViewCell else {
            return SavedPetTableViewCell()
        }
        
        guard let pets = savedPets else {
            return SavedPetTableViewCell()
        }
        let pet = pets[indexPath.row]
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
            // Delete the row from the data source
            PetController.shared.pets.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue to Detail view with pet and fetch shelter
        if segue.identifier == "petCellToDetailSegue" {
            
            guard let indexPath = tableView.indexPathForSelectedRow, let pets = savedPets else { return }
            let pet = pets[indexPath.row]
            
            guard let destinationVC = segue.destination as? PetDetailCollectionTableViewController else { return }
            
            destinationVC.pet = pet
            
        }
        
        
    }
    

}







