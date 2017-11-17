//
//  PetDetailCollectionTableViewController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/10/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class PetDetailCollectionTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    
    
    var pet: Pet? {
        didSet {
            PetController.shared.fetchAllPetImages(pet: pet!) { (images) in
                if images == nil {
                    NSLog("No images found for pet")
                    // set the default image
                    self.imageArray = [#imageLiteral(resourceName: "doge")]
                }
                guard let images = images else { return }
                self.imageArray = images
            }
        }
    }
    var imageArray: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var isButtonHidden: Bool = true 
    
    
    override func viewDidLoad() {
        guard let pet = pet else { return }
        
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        if (self.navigationController != nil) {
            navigationController?.isNavigationBarHidden = true
        }
        if PetController.shared.savedPets.contains(pet) {
            saveButton.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
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
        cell.imageView.image = imageArray[indexPath.row]
        cell.imageView.contentMode = UIViewContentMode.scaleAspectFit
        cell.imageView.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 0.25)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize: CGSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        return cellSize
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPetInfo" {
            guard let destinationVC = segue.destination as? EmbededTableViewController else { return }
            destinationVC.isButtonHidden = isButtonHidden
            destinationVC.pet = pet
        }
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        
        if (self.navigationController != nil) {
            navigationController?.popViewController(animated: true)
            navigationController?.isNavigationBarHidden = false
        } else {
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let pet = self.pet else { return }
        
        impactFeedback.impactOccurred()
        impactFeedback.impactOccurred()
        
        // MARK: - Saving original size to restore later
        let originalFrame = self.saveButton.frame
        
        UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            
            // MARK: - Saving pet
            PetController.shared.add(pet: pet)
            
            // MARK: - Making button grow (2x original size)
            self.saveButton.frame.size.height = self.saveButton.frame.size.height * 2
            self.saveButton.frame.size.width = self.saveButton.frame.size.width * 2
            
            // MARK: - Adjusting coordinates to appear in same spot
            self.saveButton.frame.origin.x = self.saveButton.frame.origin.x - (self.saveButton.frame.size.width / 4)
            self.saveButton.frame.origin.y = self.saveButton.frame.origin.y - (self.saveButton.frame.size.height / 4)
            
        }) { (finished: Bool) in
            
            PetController.shared.add(pet: pet)
            
            // MARK: - Restoring to original size
            UIView.animate(withDuration: 0.35, animations: {
                self.saveButton.frame = originalFrame
                
            })
        }   
    }
}
