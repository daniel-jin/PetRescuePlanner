//
//  EmbededTableViewController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/13/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class EmbededTableViewController: UITableViewController {
    
    // MARK: - Oulets
    
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var mixLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    var pet: Pet?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func setUpLabels() {
        
        guard let pet = pet else { return }
        guard let opt = pet.options else { return }
        
        guard let petOptions = (try? JSONSerialization.jsonObject(with: opt as Data, options: .allowFragments)) as? [String] else { return }
        
        let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        let redForegroundAttribute = [NSAttributedStringKey.foregroundColor: redColor]
        
        guard let petDescription = pet.petDescription,
            let petName = pet.name,
            let petBreed = pet.breeds,
            let petSize = pet.size,
            let petAge = pet.age,
            let petSex = pet.sex else { return }
        
        let aboutString: NSMutableAttributedString = NSMutableAttributedString(string: "About \(petName): ", attributes: redForegroundAttribute)
        
        let aboutDescription = NSAttributedString(string: "\(petDescription)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        aboutString.append(aboutDescription)
        
        let breedString: NSMutableAttributedString = NSMutableAttributedString(string: "Breed: ", attributes: redForegroundAttribute)
        let breedDescription = NSAttributedString(string: "\(petBreed)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        breedString.append(breedDescription)
        
        let sizeString: NSMutableAttributedString = NSMutableAttributedString(string: "Size: ", attributes: redForegroundAttribute)
        let sizeDescription = NSAttributedString(string: "\(petSize)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        sizeString.append(sizeDescription)
        
        let ageString: NSMutableAttributedString = NSMutableAttributedString(string: "Age: ", attributes: redForegroundAttribute)
        let ageDescription = NSAttributedString(string: "\(petAge)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        ageString.append(ageDescription)
        
        let sexString: NSMutableAttributedString = NSMutableAttributedString(string: "Sex: ", attributes: redForegroundAttribute)
        let sexDescription = NSAttributedString(string: "\(petSex)", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        sexString.append(sexDescription)
        
        let optionsString: NSMutableAttributedString = NSMutableAttributedString(string: "Options: ", attributes: redForegroundAttribute)
        for option in petOptions {
            let bulletChar = NSAttributedString(string: "\n\u{2022} ", attributes: redForegroundAttribute)
            let petOption = NSAttributedString(string: "\(option)", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
            optionsString.append(bulletChar)
            optionsString.append(petOption)
        }
        
        petNameLabel.text = pet.name
        descriptionLabel.attributedText = aboutString
        mixLabel.attributedText = breedString
        sizeLabel.attributedText = sizeString
        ageLabel.attributedText = ageString
        sexLabel.attributedText = sexString
        optionsLabel.attributedText = optionsString
    }
        
}













