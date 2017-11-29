//
//  PetDetailCollectionTableViewController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/10/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class PetDetailCollectionTableViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shelterInfoButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    var hideButton = true
    
    var pet: Pet? = nil
    var imageArray: [UIImage] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
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
            destinationVC.pet = pet
        } else if segue.identifier == "toShelter" {
            guard let destinationVC = segue.destination as? ShelterDetailViewController else { return }
            guard let pet = pet else { return }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
    @IBAction func pageIndicator(_ sender: UIPageControl) {
        
        let indexPath = IndexPath(row: pageControl.currentPage, section: 0)
        collectionView.scrollToItem(at: indexPath , at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let pet = self.pet else { return }
        
        // MARK: - Saving original size to restore later
        let originalFrame = self.saveButton.frame
        impactFeedback.impactOccurred()
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            
            // MARK: - Saving pet
            PetController.shared.add(pet: pet)
            
            // MARK: - Making button grow (2x original size)
            self.saveButton.frame.size.height = self.saveButton.frame.size.height * 2
            self.saveButton.frame.size.width = self.saveButton.frame.size.width * 2
            
            // MARK: - Adjusting coordinates to appear in same spot
            self.saveButton.frame.origin.x = self.saveButton.frame.origin.x - (self.saveButton.frame.size.width / 4)
            self.saveButton.frame.origin.y = self.saveButton.frame.origin.y - (self.saveButton.frame.size.height / 4)
            
        }) { (finished: Bool) in
            
            self.impactFeedback.impactOccurred()
            
            // MARK: - Restoring to original size
            UIView.animate(withDuration: 0.25, animations: {
                self.saveButton.frame = originalFrame
                
            })
        }   
    }
    
    func setUpUI() {
        guard let pet = pet else { return }
        
        if hideButton == true {
            shelterInfoButton.isHidden = true
        } else {
            shelterInfoButton.isHidden = false
        }
        
        shelterInfoButton.backgroundColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if (self.navigationController != nil) {
            navigationController?.isNavigationBarHidden = true
        }
        if PetController.shared.savedPets.contains(pet) {
            saveButton.isHidden = true
        }

        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.numberOfPages = imageArray.count

        shelterInfoButton.layer.cornerRadius = 5.0
        
        PetController.shared.fetchAllPetImages(pet: pet) { (images) in
            if images == nil {
                NSLog("No images found for pet")
                // set the default image
                self.imageArray = [#imageLiteral(resourceName: "doge")]
            }
            guard let images = images else { return }
            self.imageArray = images
            self.pageControl.numberOfPages = images.count
        }
        
    }
    
    @IBAction func shelterInfoButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toShelter", sender: self)
    }
    
    
}









