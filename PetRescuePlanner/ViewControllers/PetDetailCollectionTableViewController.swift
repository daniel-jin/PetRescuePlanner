//
//  PetDetailCollectionTableViewController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/10/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class PetDetailCollectionTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var pet: Pet? {
        didSet {
            updateLabels(pet: pet!)
        }
    }
    var imageArray: [UIImage] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PetController.shared.fetchPetsFor(method: "pet.find", location: "84101", animal: "dog", breed: nil, size: nil, sex: nil, age: nil, offset: nil) { (success) in
            if (success) {
                self.pet = PetController.shared.pets.first
                
                guard let pet = self.pet else { return }
                
                PetController.shared.fetchAllPetImages(pet: pet) { (images) in
                    guard let images = images else { print("optional images can't return"); return }
                    
                    self.imageArray = images
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? PetImageCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.image = imageArray[indexPath.section]
        
        return cell
    }
    
    func updateLabels(pet: Pet) {
        
    }
 
    
}













