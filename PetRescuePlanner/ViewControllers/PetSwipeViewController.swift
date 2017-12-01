//
//  PetSwipeViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/8/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import MapKit

class PetSwipeViewController: UIViewController {
    
    var divisor: CGFloat!
    let currentLocation = CLLocation()
    
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
                self.leftSwipeButton.isEnabled = true
                self.rightSwipeButton.isEnabled = true
                if self.pets.count > 0 {
                    self.cardToDetailButton.isEnabled = true
                }
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
    
    @IBOutlet weak var leftSwipeButton: UIButton!
    @IBOutlet weak var rightSwipeButton: UIButton!
    
    @IBOutlet weak var bottomCard: UIView!
    
    @IBOutlet weak var bottomPetNameLabel: UILabel!
    @IBOutlet weak var bottomPetBreedLabel: UILabel!
    @IBOutlet weak var bottomAgeLabel: UILabel!
    @IBOutlet weak var bottomImageCount: UILabel!
    
    @IBOutlet weak var topCard: UIView!
    @IBOutlet weak var topSwipeIndicatorImage: UIImageView!
    
    @IBOutlet weak var topPetNameLabel: UILabel!
    @IBOutlet weak var topPetBreedLabel: UILabel!
    @IBOutlet weak var topImageCount: UILabel!
    @IBOutlet weak var topAge: UILabel!
    
    @IBOutlet weak var bottomCardImageView: UIImageView!
    @IBOutlet weak var topCardImageView: UIImageView!
    
    @IBOutlet weak var topImageHolder: UIView!
    @IBOutlet weak var bottomImageHolder: UIView!
    
    @IBOutlet weak var leftPointer: UIImageView!
    @IBOutlet weak var rightPointer: UIImageView!
    
    @IBOutlet weak var cardToDetailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardToDetailButton.isEnabled = false
        
        leftSwipeButton.isEnabled = false
        rightSwipeButton.isEnabled = false
        
        if !Reachability.isConnectedToNetwork() {
            let networkErrorAlert = UIAlertController(title: "No Internet Connection", message: "Please check your cellular or wifi connection and try again.", preferredStyle: .alert)
            let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
            networkErrorAlert.addAction(dismiss)
            self.present(networkErrorAlert, animated: true, completion: nil)
        }
        
        let methods = API.Methods()
        PetController.shared.fetchPetsFor(count: "10", method: methods.pets, shelterId: nil, location: zip, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: nil, completion: { (success, petList, offset) in
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
        
        guard pets.count > 0 else { return }
        
        leftSwipeButton.isEnabled = false
        rightSwipeButton.isEnabled = false
        
        let card = sender.view!
        let point = sender.translation(in: self.view)
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let xFromCenter = card.center.x - view.center.x
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
//        if xFromCenter > 0 {
//            topSwipeIndicatorImage.image = #imageLiteral(resourceName: "greenCheck")
//
//        } else {
//            topSwipeIndicatorImage.image = #imageLiteral(resourceName: "sadFace")
//            topSwipeIndicatorImage.tintColor = UIColor.red
//        }
        
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
    
    
    @IBAction func leftButtonTapped(_ sender: UIButton) {
        
        guard let card = self.topCard else { return }
        guard pets.count > 0 else { return }
        
        rightSwipeButton.isEnabled = false
        leftSwipeButton.isEnabled = false
        
        UIView.animate(withDuration: 0.7, animations: {
            card.transform = CGAffineTransform(rotationAngle: -45)
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
        
    }
    
    @IBAction func rightButtonTapped(_ sender: UIButton) {
        
        guard let card = self.topCard else { return }
        guard pets.count > 0 else { return }
        
        rightSwipeButton.isEnabled = false
        leftSwipeButton.isEnabled = false
        
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
        
        UIView.animate(withDuration: 0.7, animations: {
            card.transform = CGAffineTransform(rotationAngle: 45)
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
        
    }
    
    // MARK: - Private Functions
    
    func createCard() {
        
        if indexIntoPets < pets.count - 1 {
            
            self.topCard.isHidden = false
            
            let pet = pets[indexIntoPets]
            let nextPet = pets[indexIntoPets + 1]
            
            let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
            let breedsString: NSMutableAttributedString = NSMutableAttributedString(string: "Breed: ", attributes: [NSAttributedStringKey.foregroundColor : redColor])
            let breedDescription: NSAttributedString = NSAttributedString(string: pet.1.breeds ?? "No Breed info", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            breedsString.append(breedDescription)
            let nameString: NSAttributedString = NSAttributedString(string: pet.1.name ?? "No pet name", attributes: [NSAttributedStringKey.foregroundColor: redColor])
            let ageString: NSMutableAttributedString = NSMutableAttributedString(string: "Age: ", attributes: [NSAttributedStringKey.foregroundColor : redColor])
            let ageDescription: NSAttributedString = NSAttributedString(string: pet.1.age ?? "No age information", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            ageString.append(ageDescription)
            let photoCountString: NSMutableAttributedString = NSMutableAttributedString(string: "Photos: ", attributes: [NSAttributedStringKey.foregroundColor : redColor])
            let imageCount: NSAttributedString = NSAttributedString(string: pet.1.imageIdCount ?? "0", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            photoCountString.append(imageCount)
            
            topCardImageView.image = pet.0
            bottomCardImageView.image = nextPet.0
            
            self.topPetNameLabel.attributedText = nameString
            self.topPetBreedLabel.attributedText = breedsString
            self.topImageCount.attributedText = photoCountString
            self.topAge.attributedText = ageString
            
            let bottomBreed: NSMutableAttributedString = NSMutableAttributedString(string: "Breed: ", attributes: [NSAttributedStringKey.foregroundColor : redColor])
            let botBreedDescription: NSAttributedString = NSAttributedString(string: nextPet.1.breeds ?? "No Breed info", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            bottomBreed.append(botBreedDescription)
            let bottomName: NSAttributedString = NSAttributedString(string: nextPet.1.name ?? "No pet name", attributes: [NSAttributedStringKey.foregroundColor: redColor])
            let bottomAge: NSMutableAttributedString = NSMutableAttributedString(string: "Age: ", attributes: [NSAttributedStringKey.foregroundColor : redColor])
            let botAgeDescription: NSAttributedString = NSAttributedString(string: nextPet.1.age ?? "No age information", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            bottomAge.append(botAgeDescription)
            let bottomPhoto: NSMutableAttributedString = NSMutableAttributedString(string: "Photos: ", attributes: [NSAttributedStringKey.foregroundColor : redColor])
            let bottomIMage: NSAttributedString = NSAttributedString(string: nextPet.1.imageIdCount ?? "0", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            bottomPhoto.append(bottomIMage)
            
            self.bottomPetNameLabel.attributedText = bottomName
            self.bottomPetBreedLabel.attributedText = bottomBreed
            self.bottomAgeLabel.attributedText = bottomAge
            self.bottomImageCount.attributedText = bottomPhoto
            
            // fetch
            if indexIntoPets + 5 == pets.count - 1{
                fetchMorePets(pet: nextPet)
            } else if indexIntoPets + 1 == pets.count - 1 {
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
            
            let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
            let breedsString: NSMutableAttributedString = NSMutableAttributedString(string: "Breed: ", attributes: [NSAttributedStringKey.foregroundColor : redColor])
            let breedDescription: NSAttributedString = NSAttributedString(string: pet.1.breeds ?? "No Breed info", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            breedsString.append(breedDescription)
            let nameString: NSAttributedString = NSAttributedString(string: pet.1.name ?? "No pet name", attributes: [NSAttributedStringKey.foregroundColor: redColor])
            let ageString: NSMutableAttributedString = NSMutableAttributedString(string: "Age: ", attributes: [NSAttributedStringKey.foregroundColor : redColor])
            let ageDescription: NSAttributedString = NSAttributedString(string: pet.1.age ?? "No age information", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            ageString.append(ageDescription)
            let photoCountString: NSMutableAttributedString = NSMutableAttributedString(string: "Photos: ", attributes: [NSAttributedStringKey.foregroundColor : redColor])
            let imageCount: NSAttributedString = NSAttributedString(string: pet.1.imageIdCount ?? "0", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            photoCountString.append(imageCount)
            
            self.topPetNameLabel.attributedText = nameString
            self.topPetBreedLabel.attributedText = breedsString
            self.topImageCount.attributedText = photoCountString
            self.topAge.attributedText = ageString
            
        }
    }
    
    func hardResetCard() {
        
        leftSwipeButton.isEnabled = true
        rightSwipeButton.isEnabled = true
        
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
            
            self.leftSwipeButton.isEnabled = true
            self.rightSwipeButton.isEnabled = true
        }
    }
    
    func resetCard() {
        
        leftSwipeButton.isEnabled = true
        rightSwipeButton.isEnabled = true 
        
        UIView.animate(withDuration: 0.3) {
            
            self.topCard.center = self.bottomCard.center
            self.topSwipeIndicatorImage.alpha = 0
            self.topCard.alpha = 1
            self.topCard.transform = CGAffineTransform.identity
        }
    }
    
    func fetchMorePets(pet: (UIImage, Pet)) {
        
        let methods = API.Methods()
        
        PetController.shared.fetchPetsFor(count: "10",method: methods.pets, shelterId: nil, location: zip, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: offSet, completion: { (success, petList, offset) in
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
            if pets.count > 0 {
                let pet = pets[indexIntoPets]
                
                let destinationVC = segue.destination as? PetDetailCollectionTableViewController
                destinationVC?.pet = pet.1
                destinationVC?.hideShelterButton = true
            }
            
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


















