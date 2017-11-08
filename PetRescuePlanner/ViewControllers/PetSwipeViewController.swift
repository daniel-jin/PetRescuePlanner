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
                self.viewDidLoad()
            }
        }
    }
    
    var indexIntoPets = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var faceImageView: UIImageView!
    
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        divisor = (view.frame.width / 2) / 0.61
        
        card.layer.cornerRadius = 10.0
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
                // move off to left side of screen
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                
//                UIView.animate(withDuration: <#T##TimeInterval#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
                createCard()
                return
            } else if card.center.x > (view.frame.width - 75) {
                // move off to right of screen
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                })
                createCard()
                return
            } else {
                resetCard()
            }
        }
    }
    
    // MARK: - Private Functions
    
    func createCard() {
        
        
        if indexIntoPets < pets.count {
            
            let pet = pets[indexIntoPets]
            
            self.card.center = self.view.center
            self.faceImageView.alpha = 0
            self.card.alpha = 1
            self.card.transform = CGAffineTransform.identity
            
            self.petNameLabel.text = pet.name
            self.petDescriptionLabel.text = pet.breeds
            
            indexIntoPets += 1
            
        }
        
    }
    
    func resetCard() {
        UIView.animate(withDuration: 0.2) {
            self.card.center = self.view.center
            self.faceImageView.alpha = 0
            self.card.alpha = 1
            self.card.transform = CGAffineTransform.identity
        }
    }
    
}
