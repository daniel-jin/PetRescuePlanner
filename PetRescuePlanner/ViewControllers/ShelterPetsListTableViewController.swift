//
//  ShelterPetsListTableViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/14/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class ShelterPetsListTableViewController: UITableViewController/*, UITableViewDataSourcePrefetching*/ {
    
    var pet = Pet()
    
    var savedPets: [Pet] = [] {
        didSet{
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func toSavedPetsButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSavedPets", sender: self)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let methods = API.Methods()
        
        PetController.shared.fetchPetsFor(count: "50", method: methods.petsAtSpecificShelter, shelterId: pet.shelterID, location: nil, animal: nil, breed: nil, size: nil, sex: nil, age: nil, offset: nil, completion: { (success, petList, offset) in
            if !success {
                NSLog("Error fetching pets from shelter")
                return
            }
            
            guard let petList = petList else { return }
            self.savedPets = petList
        })
//        tableView.prefetchDataSource = self
        
        self.title = "At This Shelter"
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shelterPetCell", for: indexPath) as? ShelterPetTableViewCell else {
            return ShelterPetTableViewCell()
        }
        let pet = savedPets[indexPath.row]
        
        cell.pet = pet
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue to Detail view with pet and fetch shelter
        if segue.identifier == "shelterPetToDetail" {
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let pet = savedPets[indexPath.row]
            
            guard let destinationVC = segue.destination as? PetDetailCollectionTableViewController else { return }
            
            destinationVC.pet = pet
            destinationVC.isComingFromShelter = true
        }
        
    }
    
    
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        
//        let cell = ShelterPetTableViewCell()
//        
//        cell.nameLabel.text = pet.name
//        cell.descriptionLabel.text = pet.description
//        cell.imageView?.image = #imageLiteral(resourceName: "doge")
//        
//        
//        for indexPath in indexPaths {
//            let savedPet = savedPets[indexPath.row]
//            
//            cell.pet = savedPet
//            
//            
//            PetController.shared.fetchImageFor(pet: savedPet, number: 2, completion: { (success, image) in
//                if !success {
//                    NSLog("error fetchingpet in pet controller")
//                }
//                guard let image = image else { return }
//                DispatchQueue.main.async {
//
//                    if cell.petImageView.image != nil {
//                        cell.petImageView.image = image
//                    } else {
//                        cell.petImageView.image = #imageLiteral(resourceName: "happyFace")
//                    }
//                }
//            })
//        }
//    }
}








