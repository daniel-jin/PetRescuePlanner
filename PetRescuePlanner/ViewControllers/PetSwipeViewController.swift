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
                self.createCard()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indexIntoPets = 0
        divisor = (view.frame.width / 2) / 0.61
        
        card.layer.cornerRadius = 10.0
        card2.layer.cornerRadius = 10.0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
                    
                    if self.indexIntoPets < self.pets.count - 1 {
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
            
            self.petNameLabel.text = pet.name
            self.petDescriptionLabel.text = pet.breeds
            
            self.petNameLabel2.text = nextPet.name
            self.petDescriptionLabel2.text = nextPet.breeds
            
            indexIntoPets += 1
            
            return
        } else if indexIntoPets == pets.count - 1 {
        
            let pet = pets[indexIntoPets]
            
            self.card2.isHidden = true
            self.petNameLabel.text = pet.name
            self.petDescriptionLabel.text = pet.breeds
        }
    }
    
    func createLastCard() {
        
        resetCard()
        card2.isHidden = true
        let pet = pets[pets.count - 1]
        
        petNameLabel.text = pet.name
        petDescriptionLabel.text = pet.breeds
        
        indexIntoPets += 1
        
    }
    
    func resetCard() {
        
        UIView.animate(withDuration: 0.0000000001) {
            
            self.card.center = self.view.center
            self.faceImageView.alpha = 0
            self.card.alpha = 1
            self.card.transform = CGAffineTransform.identity
            
            self.card.isHidden = false
            
        }
    }
}
