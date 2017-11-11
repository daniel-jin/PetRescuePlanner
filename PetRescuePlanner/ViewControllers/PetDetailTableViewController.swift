//
//  PetDetailTableViewController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class PetDetailTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Properties
    
    @IBOutlet weak var petImageCollectionView: UICollectionView!
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petDescriptionLabel: UILabel!
    @IBOutlet weak var petMixLabel: UILabel!
    @IBOutlet weak var petSizeSexLabel: UILabel!
    @IBOutlet weak var petAgeLabel: UILabel!
    @IBOutlet weak var petStatusLabel: UILabel!
    @IBOutlet weak var petOptionsLabel: UILabel!
    @IBOutlet weak var shelterNameLabel: UILabel!
    @IBOutlet weak var shelterAddress: UILabel!
    @IBOutlet weak var shelterCityStateZipLabel: UILabel!
    @IBOutlet weak var shelterPhoneLabel: UILabel!
    
    
    var pet: Pet? {
        didSet{
            DispatchQueue.main.async {
                self.setUpUI()
            }
        }
    }
    var shelter: Shelter?
    var imageArray: [UIImage] = [] {
        didSet {
            petImageCollectionView.reloadData()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        petImageCollectionView.delegate = self
        petImageCollectionView.dataSource = self
        
        setUpUI()
        
        PetController.shared.fetchPetsFor(method: "pet.find", location: "84101", animal: "dog", breed: nil, size: nil, sex: nil, age: nil, offset: nil) { (success) in
            if (success) {
                self.pet = PetController.shared.pets.first
                
                guard let pet = self.pet else { return }
                PetController.shared.fetchAllPetImages(pet: pet) { (images) in
                    guard let images = images else { print("optional images can't return"); return }
                    
                    self.imageArray = images
                }
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
  
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        
        
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: super.view.frame.width, height: cell.frame.height))
        let image: UIImage = imageArray[indexPath.section]
        imageView.image = image
        imageView.frame.size.width = cell.frame.size.width
        cell.contentView.addSubview(imageView)
        cell.frame.size.width = view.frame.size.width
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setUpUI() {
        
        guard let pet = self.pet else { return }
        let optionsString = pet.options.reduce("", +)
        self.tableView.estimatedRowHeight = 88.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.petNameLabel.text = pet.name
        self.petDescriptionLabel.text = "About \(pet.name): \(pet.description)"
        self.petMixLabel.text = "Mix: \(pet.mix)"
        self.petSizeSexLabel.text = "Size: \(pet.size)"
        self.petAgeLabel.text = "Age: \(pet.age)"
        self.petStatusLabel.text = "Status: \(pet.status)"
        self.petOptionsLabel.text = "Options: \(optionsString)"
        
    }
}

