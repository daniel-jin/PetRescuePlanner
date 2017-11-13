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
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        
        resetCard()
    }
    
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
                
                // save to store here
                
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (success) in
                    self.indexIntoPets += 1


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
            
        }
    }
    
    func createLastCard() {
        
        resetCard()
        card2.isHidden = true
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
            
            guard let destinationVC = segue.destination as? SavedPetsListTableViewController else {return }
            
            // do fetch request here for saved pets
            
            destinationVC.savedPets = pets
            
        }
        
    }
}


















