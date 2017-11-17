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
    
    var pets: [Pet] = [] {
        didSet {
            if isViewLoaded{
                DispatchQueue.main.async {
                    if self.pets.count > 1 {
                        self.createCard()
                    } else {
                        self.createLastCard()
                    }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let methods = API.Methods()
        PetController.shared.fetchPetsFor(method: methods.pets, shelterId: nil, location: zip, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: nil, completion: { (success, petList, offset) in
            if !success {
                NSLog("Error fetching adoptable pets from PetController")
                return
            }
            guard let pets = petList else { return }
            self.pets = pets
            self.offSet = offset
        })
        
        setUpViews()
        let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        self.title = "PetRescuePlanner"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: redColor]

    }
    
    // MARK: - Actions 
        
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
        if xFromCenter > 0 {
            topSwipeIndicatorImage.image = #imageLiteral(resourceName: "greenCheck")
//            topSwipeIndicatorImage.tintColor = UIColor.lightGray
            
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
                let petToSave: Pet

                if indexIntoPets == pets.count {
                    petToSave = pets[indexIntoPets - 1]
                } else {
                    petToSave = pets[indexIntoPets]
                }
                
                // Save to CoreData first
                PetController.shared.add(pet: petToSave)
                
                self.indexIntoPets += 1
                
                // Then save to CK
                PetController.shared.saveToCK(pet: petToSave, completion: { (success) in
                    if !success {
                        NSLog("Error saving pet to CloudKit")
                        return
                    }
                })
                
                
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
            
            
            PetController.shared.fetchImageFor(pet: pet, number: 2, completion: { (success, image) in
                if !success {
                    NSLog("error fetching pet in pet controller")
                    // Set a default image here
                    self.topCardImageView.backgroundColor = UIColor.white
                    self.topCardImageView.image = #imageLiteral(resourceName: "doge")
                }
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.topCardImageView.image = image
                }
            })

            PetController.shared.fetchImageFor(pet: nextPet, number: 2, completion: { (success, image) in
                if !success {
                    NSLog("error fetching pet in pet controller")
                    // set a default image here
                    self.topCardImageView.backgroundColor = UIColor.white
                    self.topCardImageView.image = #imageLiteral(resourceName: "doge")
                }
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.bottomCardImageView.image = image
                }
            })
            
            self.topPetNameLabel.text = pet.name
            self.topPetBreedLabel.text = pet.breeds
            
            self.bottomPetNameLabel.text = nextPet.name
            self.bottomPetBreedLabel.text = nextPet.breeds
            
            
            
//            print("CREATCARD PET1 = \(pet.name), PET2 = \(nextPet.name)")
            
        }
    }
    
    func createLastCard() {
        
        if pets.count > 0 {
            
            self.hardResetCard()
            bottomCard.isHidden = false
            topCard.isHidden = false
            let pet = pets[pets.count - 1]
            
            PetController.shared.fetchImageFor(pet: pet, number: 2, completion: { (success, image) in
                if !success {
                    NSLog("error fetchingpet in pet controller")
                    // set a default image here
                    self.topCardImageView.backgroundColor = UIColor.white
                    self.topCardImageView.image = #imageLiteral(resourceName: "doge")
                }
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.topCardImageView.image = image
                }
            })
            
            
            self.topPetNameLabel.text = pet.name
            topPetBreedLabel.text = pet.breeds
            
            
            fetchMorePets(pet: pet)
        }
    }
    
    func hardResetCard() {
        self.topCard.isHidden = true
        self.topCardImageView.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 1)
        
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
    
    func fetchMorePets(pet: Pet) {
        if indexIntoPets == pets.count - 1 {
            
            let methods = API.Methods()
            
            PetController.shared.fetchPetsFor(method: methods.pets, shelterId: nil, location: zip, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: offSet, completion: { (success, petList, offset) in
                if !success {
                    NSLog("No more pets fetched In swipe to save view")
                    
                    self.presentAlertWith(title: "Uh Oh...", message: "No pets were found near you")
                    return
                }

                self.indexIntoPets = 0
                
                guard let petList = petList else {
                    return
                }
                
                if petList.count == 0 {
                    // Alert user that no more pets were found
                    self.presentAlertWith(title: "Uh Oh...", message: "We ran out of pets to show you, try another zip code to search from!")
                    return
                }
                
                var pets: [Pet] = petList
                pets.insert(pet, at: 0)
                
                self.offSet = offset
                self.pets = pets
                
                DispatchQueue.main.async {
                    self.bottomCard.isHidden = false
                }
            })
        }
    }
    
    func setUpViews() {
        indexIntoPets = 0
        divisor = (view.frame.width / 2) / 0.61
        
        topImageHolder.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 1)
        bottomImageHolder.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 1)
        
        
        topCard.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 1)
        topCardImageView.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 1)
        
        bottomCard.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 1)
        bottomCardImageView.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 1)
        
        topCard.layer.cornerRadius = 10.0
        bottomCard.layer.cornerRadius = 10.0
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 0.5)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "swipeToPetListSegue" {
            
//            guard let destinationVC = segue.destination as? SavedPetsListTableViewController else {return }
            
//            destinationVC.savedPets = PetController.shared.savedPets
            
        }
        
        if segue.identifier == "tinderToDetailSegue" {
            let pet = pets[indexIntoPets]
            
            let destinationVC = segue.destination as? PetDetailCollectionTableViewController
            destinationVC?.isButtonHidden = true 
            destinationVC?.pet = pet
            
            
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


















