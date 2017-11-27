//
//  PetSwipeViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/8/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class PetSwipeViewController: UIViewController {
    
    var divisor: CGFloat!
    
    var offSet: String? = nil
    var zip: String? = nil
    var animal: String? = nil
    var size: String? = nil
    var sex: String? = nil
    var age: String? = nil
    var breed: String? = nil
    
    var petDescriptions: [String] = []
    
    var pets: [(UIImage, Pet)] = [] {
        didSet {
            DispatchQueue.main.async {
                if self.pets.count > 1 {
                    self.createCard()
                } else {
                    self.createLastCard()
                }
            }
        }
    }
    
    var petPhotos: [UIImage] = []
    
    var indexIntoPets = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var bottomCard: UIView!
    
    @IBOutlet weak var bottomPetNameLabel: UILabel!
    @IBOutlet weak var bottomPetBreedLabel: UILabel!
    
    @IBOutlet weak var bottomSwipeIndicatorImage: UIImageView!
    
    
    @IBOutlet weak var topCard: UIView!
    @IBOutlet weak var topSwipeIndicatorImage: UIImageView!
    
    @IBOutlet weak var topPetNameLabel: UILabel!
    @IBOutlet weak var topPetBreedLabel: UILabel!
    
    
    @IBOutlet weak var bottomCardImageView: UIImageView!
    @IBOutlet weak var topCardImageView: UIImageView!
    
    @IBOutlet weak var topImageHolder: UIView!
    @IBOutlet weak var bottomImageHolder: UIView!
    
    @IBOutlet weak var leftPointer: UIImageView!
    @IBOutlet weak var rightPointer: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Reachability.isConnectedToNetwork() {
            let networkErrorAlert = UIAlertController(title: "No Internet Connection", message: "Please check your cellular or wifi connection and try again.", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
            networkErrorAlert.addAction(dismiss)
            self.present(networkErrorAlert, animated: true, completion: nil)
        }
        
        let methods = API.Methods()
        PetController.shared.fetchPetsFor(method: methods.pets, shelterId: nil, location: zip, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: nil, completion: { (success, petList, offset) in
            if !success {
                NSLog("Error fetching adoptable pets from PetController")
                return
            }
            guard let pets = petList else { return }
            
            // Prefetch pets images and make a tuple with the image and pet?
            
            PetController.shared.preFetchImagesFor(pets: pets, completion: { (petData) in
                if petData == nil {
                    NSLog("Error fetching pets images")
                    return
                }
                guard let petData = petData else { return }
                
                for pet in petData {
                    if let description = pet.1.petDescription {
                        self.petDescriptions.append(description)
                    }
                }
                
                self.pets = petData
                self.offSet = offset
            })
        })
        
        setUpViews()
    }
    
    // MARK: - Actions 
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let point = sender.translation(in: view)
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let xFromCenter = card.center.x - view.center.x
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
        if xFromCenter > 0 {
            topSwipeIndicatorImage.image = #imageLiteral(resourceName: "greenCheck")
            
        } else {
            topSwipeIndicatorImage.image = #imageLiteral(resourceName: "sadFace")
            topSwipeIndicatorImage.tintColor = UIColor.red
        }
        
        topSwipeIndicatorImage.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 75 {
                
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (success) in
                    self.indexIntoPets += 1
                    
                    self.topCardImageView.image = UIImage()
                    
                    if self.indexIntoPets < self.pets.count - 1 {
                        self.topCard.isHidden = true
                        self.hardResetCard()
                    } else if self.indexIntoPets == self.pets.count - 1 {
                        
                        self.createLastCard()
                    }
                })
                
                return
            } else if card.center.x > (view.frame.width - 75) {
                
                // Save pet to Core Data & CloudKit
                let petToSave: (UIImage, Pet)
                
                if indexIntoPets == pets.count {
                    petToSave = pets[indexIntoPets - 1]
                } else {
                    petToSave = pets[indexIntoPets]
                }
                
                // Save to CoreData first
                PetController.shared.add(pet: petToSave.1)
                
                // Sync with CloudKit
                PetController.shared.performFullSync()
                
                self.indexIntoPets += 1
                
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (success) in
                    
                    if self.indexIntoPets < self.pets.count - 1 {
                        self.topCardImageView.image = UIImage()
                        
                        self.topCard.isHidden = true
                        self.hardResetCard()
                    } else if self.indexIntoPets == self.pets.count - 1 {
                        
                        self.createLastCard()
                    }
                })
                
                return
            } else {
                resetCard()
            }
        }
    }
    
    // MARK: - Private Functions
    
    func createCard() {
        
        if indexIntoPets < pets.count - 1 {
            
            self.topCard.isHidden = false 
            
            let pet = pets[indexIntoPets]
            let nextPet = pets[indexIntoPets + 1]
            
            topCardImageView.image = pet.0
            bottomCardImageView.image = nextPet.0
            
            self.topPetNameLabel.text = pet.1.name
            self.topPetBreedLabel.text = pet.1.breeds
            
            self.bottomPetNameLabel.text = nextPet.1.name
            self.bottomPetBreedLabel.text = nextPet.1.breeds
            
            
            // fetch
            if indexIntoPets + 5 == pets.count - 1{
                
                fetchMorePets(pet: nextPet)
                
            }
        }
    }
    
    func createLastCard() {
        
        if pets.count > 0 {
            
            self.hardResetCard()
            bottomCard.isHidden = true
            topCard.isHidden = false
            let pet = pets[pets.count - 1]
            
            topCardImageView.image = pet.0
            
            self.topPetNameLabel.text = pet.1.name
            topPetBreedLabel.text = pet.1.breeds
            
            
//            fetchMorePets(pet: pet)
        }
    }
    
    func hardResetCard() {
        self.topCard.isHidden = true
        self.topCardImageView.backgroundColor = UIColor.clear
        
        UIView.animate(withDuration: 0.01, animations: {
            
            self.topCard.center = self.bottomCard.center
            self.topSwipeIndicatorImage.alpha = 0
            self.topCard.transform = CGAffineTransform.identity
            
        }) { (success) in
            self.topCard.isHidden = false
            self.topCard.alpha = 1.0
            self.createCard()
        }
        
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.3) {
            
            self.topCard.center = self.bottomCard.center
            self.topSwipeIndicatorImage.alpha = 0
            self.topCard.alpha = 1
            self.topCard.transform = CGAffineTransform.identity
        }
    }
    
    func fetchMorePets(pet: (UIImage, Pet)) {
        
        let methods = API.Methods()
        
        PetController.shared.fetchPetsFor(method: methods.pets, shelterId: nil, location: zip, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: offSet, completion: { (success, petList, offset) in
            if !success {
                NSLog("No more pets fetched In swipe to save view")
                return
            }
            
            guard let petList = petList else {
                return
            }
            
            if petList.count == 0 {
                // Alert user that no more pets were found
                return
            }
            
            var tempPets: [(UIImage, Pet)] = []
            
            PetController.shared.preFetchImagesFor(pets: petList, completion: { (petData) in
                if petData == nil {
                    NSLog("Error fetching pets images")
                    return
                }
                guard let petData = petData else { return }
                
                // check to see if pet already exists in the working set of pets
                for pet in petData {
                    guard let description = pet.1.petDescription else { return }
                    if !self.petDescriptions.contains(description) && description != "No description available" {
                        tempPets.append(pet)
                        self.petDescriptions.append(description)
                    }
                }
            
                self.offSet = offset
                self.pets += tempPets
                
                DispatchQueue.main.async {
                    self.bottomCard.isHidden = false
                }
            })
        })
    }
    
    func setUpViews() {
        indexIntoPets = 0
        divisor = (view.frame.width / 2) / 0.61
        
        self.title = "Pets"
        
        leftPointer.tintColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 0.3)
        rightPointer.tintColor = UIColor(red: 3.0/255.0, green: 209.0/255.0, blue: 0.0, alpha: 0.3)
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "swipeToPetListSegue" {
            
            
        }
        
        if segue.identifier == "tinderToDetailSegue" {
            let pet = pets[indexIntoPets]
            
            let destinationVC = segue.destination as? PetDetailCollectionTableViewController
            destinationVC?.isButtonHidden = true 
            destinationVC?.pet = pet.1
            
            
        }
        
    }
    
    func presentAlertWith(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.yellow
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
}


















