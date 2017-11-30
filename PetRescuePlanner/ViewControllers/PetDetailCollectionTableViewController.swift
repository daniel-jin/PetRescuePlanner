//
//  PetDetailCollectionTableViewController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/10/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class PetDetailCollectionTableViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shelterInfoButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var exitButton: UIButton!
    
    // MARK: - Properties
    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    var hideShelterButton = true
    var isComingFromShelter = false
    var isSaved = false
    
    var pet: Pet? = nil
    var imageArray: [UIImage] = [] {
        
        // MARK: - Reloading collection view once we have images to show
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        // MARK: - Revealing nav bar once view changes
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // MARK: - Setting collection view rows to the count of images
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? PetImageCollectionViewCell else { return UICollectionViewCell() }
        
        // MARK: - Setting cell to image to the image array at row index
        cell.imageView.image = imageArray[indexPath.row]
        
        // MARK: - Making UI of cell look nice
        cell.imageView.contentMode = UIViewContentMode.scaleAspectFit
        cell.imageView.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 0.25)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // MARK: - Sizing cell to fit in view
        let cellSize: CGSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // MARK: - Setting page control dot to match current page
        pageControl.currentPage = indexPath.row
    }
    
    @IBAction func pageIndicator(_ sender: UIPageControl) {
        
        // MARK: - Creating an index based off page control indicator dot
        let indexPath = IndexPath(row: pageControl.currentPage, section: 0)
        
        // MARK: - Scrolling Collection View to the index path
        collectionView.scrollToItem(at: indexPath , at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // MARK: - Sending pet info to required destinations
        
        if segue.identifier == "toPetInfo" {
            // MARK: - Setting destination as the Embeded Table View
            guard let destinationVC = segue.destination as? EmbededTableViewController else { return }
            
            // MARK: - Passing pet information to Destination VC
            destinationVC.pet = pet
            
        } else if segue.identifier == "toShelter" {
            
            // MARK: - Setting Destination VC to Shelter Detail View
            guard let destinationVC = segue.destination as? ShelterDetailViewController else { return }
            
            // MARK: - Ensuring there is a pet to pass to Destination VC
            guard let pet = pet else { return }
            
            // MARK: - Passing pet to Shelter Detail VC
            destinationVC.pet = pet
        }
    }
    
    // MARK: - Actions
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let pet = pet else {return}
        guard let breeds = pet.breeds else {return}
        let activityVC = UIActivityViewController(activityItems: [self.imageArray[0], pet.name as Any, ", ", "\(String(describing: breeds))." ," Sent from the Pet Rescue Planner App"], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        
        // MARK: - Returning to swipe view and bringing navigation bar back on screen
        self.dismiss(animated: true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func shelterInfoButtonTapped(_ sender: UIButton) {
        
        // MARK: - Performing segue to shelter view
        performSegue(withIdentifier: "toShelter", sender: self)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        guard let pet = self.pet else { return }
        
        if isSaved == true {
            
            let petToDelete = pet
            
            // Delete from sorted array to update iCloud key/value store
            guard let petID = petToDelete.id,
                let index = PetController.shared.sortedPetArray.index(of: petID) else { return }
            PetController.shared.sortedPetArray.remove(at: index)
            PetController.shared.saveToiCloud()
            
            // Delete from Core Data
            PetController.shared.delete(pet: petToDelete, completion: {
                
                // Sync with CloudKit to update
                PetController.shared.performFullSync()
            })
        }
        
        // MARK: - Saving original size to restore later
        let originalFrame = self.saveButton.frame
        
        // MARK: - Adding phone vibrate
        impactFeedback.impactOccurred()
        
        // MARK: - Animation
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
            
            self.saveButton.setImage(self.isSaved ? #imageLiteral(resourceName: "EmptyHeart") : #imageLiteral(resourceName: "heart"), for: .normal)
            
            // MARK: - Adding second phone vibrate
            self.impactFeedback.impactOccurred()
            
            // MARK: - Restoring to original size
            UIView.animate(withDuration: 0.25, animations: {
                self.saveButton.frame = originalFrame
            }, completion: { (_) in
                self.isSaved = !self.isSaved
            })
        }   
    }
    
    // MARK: - UI
    
    func setUpUI() {
        
        guard let pet = pet else { return }
        
        // MARK: - hideShelterButton checks what view/segue is presenting the pet detail view
        if hideShelterButton == true {
            
            // MARK: - Checking against saved pets to hide save button on currently saved pets
            if PetController.shared.savedPets.contains(pet) {
                self.saveButton.imageView?.image = #imageLiteral(resourceName: "heart")
                self.isSaved = true
            } else {
                self.saveButton.imageView?.image = #imageLiteral(resourceName: "EmptyHeart")
                self.isSaved = false
            }
            
            // MARK: - Hiding nav bar and shelter info button, also displaying exit button for module presentation
            exitButton.isHidden = false
            shelterInfoButton.isHidden = true
            navigationController?.isNavigationBarHidden = true
            
        } else {
            
            // MARK: - Creating shelter button and presenting all necesary buttons as well as nav bar for show presentaion
            shelterInfoButton.layer.cornerRadius = 5.0
            shelterInfoButton.backgroundColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
            shelterInfoButton.isHidden = false
            self.navigationController?.isNavigationBarHidden = false
            
            saveButton.isHidden = true
            exitButton.isHidden = true
            self.title = pet.name
        }
        
        // MARK: - Setting data source to self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        // MARK: - Updating page control dots
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.numberOfPages = imageArray.count
        
        if isComingFromShelter == true {
            
            self.navigationController?.isNavigationBarHidden = false
            saveButton.isHidden = true
            exitButton.isHidden = true
            shelterInfoButton.isHidden = true
        }
        
        PetController.shared.fetchAllPetImages(pet: pet) { (images) in
            if images == nil {
                NSLog("No images found for pet")
                // set the default image
                self.imageArray = [#imageLiteral(resourceName: "DefaultCardIMGNoBorder")]
            }
            guard let images = images else { return }
            self.imageArray = images
            self.pageControl.numberOfPages = images.count
        }
        
    }
    
}









