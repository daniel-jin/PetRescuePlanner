//
//  ShelterPetsListTableViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/14/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class ShelterPetsListTableViewController: UITableViewController {
    
    var pet = Pet()
    
    var savedPets: [Pet] = [] {
        didSet{
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var storedImages: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.prefetchDataSource = self
        
        let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        self.title = "At This Shelter"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: redColor]
        
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
            
        }
        
    }
    
}

//extension ShelterPetsListTableViewController: UITableViewDataSourcePrefetching {
//
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            let savedPet = savedPets[indexPath.row]
//
//            PetController.shared.fetchImageFor(pet: savedPet, number: 2, completion: { (success, image) in
//                if !success {
//                    NSLog("error fetchingpet in pet controller")
//                }
//                guard let image = image else { return }
//                DispatchQueue.main.async {
//                    self.storedImages.append(image)
//                }
//            })
//        }
//    }
//
//
//}
////            NetworkController.performRequest(for: photoURL, httpMethod: NetworkController.HTTPMethod.get, body: nil) { (data, error) in
////                if let error = error {
////                    NSLog("error fetching pet photo in pet controller \(error)")
////                    completion(false, nil)
////                }
////                guard let data = data else { return completion(false, nil) }
////
////                let imageReturned = UIImage(data: data)
////
////                completion(true, imageReturned)
////            }


