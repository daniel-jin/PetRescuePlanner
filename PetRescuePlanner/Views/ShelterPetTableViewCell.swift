//
//  ShelterPetTableViewCell.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/14/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class ShelterPetTableViewCell: UITableViewCell {

    //
    //  SavedPetTableViewCell.swift
    //  PetRescuePlanner
    //
    //  Created by Daniel Rodosky on 11/10/17.
    //  Copyright © 2017 Daniel Rodosky. All rights reserved.
    //
    
        
    // MARK: - Outlets

    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var pet: Pet? {
        didSet{
            self.updateViews()
        }
    }
    
    // MARK: - Private Funcs
    
    func updateViews() {
        
        guard let pet = pet else { return }
        
        let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        let redForegroundAttribute = [NSAttributedStringKey.foregroundColor: redColor]
        
        let nameString: NSMutableAttributedString = NSMutableAttributedString(string: "\(pet.name ?? "Doggo")", attributes: redForegroundAttribute)
        
        nameLabel.attributedText = nameString
        descriptionLabel.text = pet.petDescription
        
        PetController.shared.fetchImageFor(pet: pet, number: 2, completion: { (success, image) in
            if !success {
                NSLog("error fetchingpet in pet controller")
                self.petImageView.image = #imageLiteral(resourceName: "doge")
            }
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.petImageView.image = image
            }
        })
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        petImageView.trailingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: (0 - 8)).isActive = true
        petImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: petImageView.trailingAnchor, constant: 8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
        petImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}

