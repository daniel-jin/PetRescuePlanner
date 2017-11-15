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
            DispatchQueue.main.async {
                if self.pets.count > 1 {
                    self.createCard()
                } else {
                    self.createLastCard()
                }
            }
        }
    }
    
    var indexIntoPets = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var card2: UIView!
    
    @IBOutlet weak var petNameLabel2: UILabel!
    @IBOutlet weak var petDescriptionLabel2: UILabel!
    
    @IBOutlet weak var faceImageView2: UIImageView!
    
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var faceImageView: UIImageView!
    
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var card2ImageView: UIImageView!
    @IBOutlet weak var cardImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()

    }
    
    // MARK: - Actions 
        
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
        if xFromCenter > 0 {
            faceImageView.image = #imageLiteral(resourceName: "doge")
            faceImageView.tintColor = UIColor.lightGray
            
        } else {
            faceImageView.image = #imageLiteral(resourceName: "sadFace")
            faceImageView.tintColor = UIColor.red
        }
        
        faceImageView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizerState.ended {
            
            if card.center.x < 75 {
                
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (success) in
                    self.indexIntoPets += 1

                    self.cardImageView.image = UIImage()

                    if self.indexIntoPets < self.pets.count - 1 {
                        self.card.isHidden = true
                        self.resetCard()
                        self.createCard()
                    } else if self.indexIntoPets == self.pets.count - 1 {
                        
                        self.createLastCard()
                    }
                })
                
                return
            } else if card.center.x > (view.frame.width - 75) {
                
                // Save pet to Core Data & CloudKit
                let petToSave = pets[indexIntoPets]
                
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
                        self.cardImageView.image = UIImage()

                        self.card.isHidden = true
                        self.resetCard()
                        self.createCard()
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
            
            let pet = pets[indexIntoPets]
            let nextPet = pets[indexIntoPets + 1]
            
            
            PetController.shared.fetchImageFor(pet: pet, number: 2, completion: { (success, image) in
                if !success {
                    NSLog("error fetchingpet in pet controller")
                }
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.cardImageView.image = image
                }
            })
            
            PetController.shared.fetchImageFor(pet: nextPet, number: 2, completion: { (success, image) in
                if !success {
                    NSLog("error fetchingpet in pet controller")
                }
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.card2ImageView.image = image
                }
            })
            
            
            self.petNameLabel.text = pet.name
            self.petDescriptionLabel.text = pet.breeds
            
            self.petNameLabel2.text = nextPet.name
            self.petDescriptionLabel2.text = nextPet.breeds
            
//            print("CREATCARD PET1 = \(pet.name), PET2 = \(nextPet.name)")
            
        }
    }
    
    func createLastCard() {
        
        if pets.count > 0 {
            
            resetCard()
            card2.isHidden = false 
            let pet = pets[pets.count - 1]
            
            PetController.shared.fetchImageFor(pet: pet, number: 2, completion: { (success, image) in
                if !success {
                    NSLog("error fetchingpet in pet controller")
                }
                guard let image = image else { return }
                DispatchQueue.main.async {
                    self.cardImageView.image = image
                }
            })
            
            petNameLabel.text = pet.name
            petDescriptionLabel.text = pet.breeds
            
//            print("CREATELASTCARD: PET = \(pet.name)")
            
            fetchMorePets(pet: pet)
        } else {
            presentAlertWith(title: "Uh Oh...", message: "No pets were found near you")
        }
    }
    
    func resetCard() {
        self.card.isHidden = true
        UIView.animate(withDuration: 0.0000000001) {
            
            self.card.center = self.view.center
            self.faceImageView.alpha = 0
            self.card.alpha = 1
            self.card.transform = CGAffineTransform.identity
            
            self.card.isHidden = false
            
        }
    }
    
    func fetchMorePets(pet: Pet) {
        if indexIntoPets == pets.count - 1 {
            
            let methods = API.Methods()
            
            PetController.shared.fetchPetsFor(method: methods.pets, shelterId: nil, location: zip, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: offSet, completion: { (success) in
                if !success {
                    NSLog("No more pets fetched In swipe to save view")
                    return
                }
                self.offSet = PetController.shared.offset
                self.pets = PetController.shared.pets
                self.pets.insert(pet, at: 0)
                self.indexIntoPets = 0
                
                DispatchQueue.main.async {
                    self.card2.isHidden = false
                }
            })
        }
    }
    
    func setUpViews() {
        indexIntoPets = 0
        divisor = (view.frame.width / 2) / 0.61
        
        card.layer.cornerRadius = 10.0
        card2.layer.cornerRadius = 10.0
        
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


















