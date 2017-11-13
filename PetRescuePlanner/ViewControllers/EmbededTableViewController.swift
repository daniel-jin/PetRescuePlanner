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
    @IBOutlet weak var petTestLabel: UILabel!
    
    // MARK: - Properties
    var pet: Pet?
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mixLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var ageSexLabel: UILabel!
    @IBOutlet var shelterInfoButton: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    func setUpLabels() {
        
        guard let pet = pet else { return }
        
        petNameLabel.text = pet.name
        descriptionLabel.text = "About \(pet.name): \(pet.description)"
        mixLabel.text = "Mix: \(pet.description)"
        sizeLabel.text = "Size: \(pet.size)"
        ageSexLabel.text = "Age: \(pet.age)   Sex: \(pet.sex)"
        
    }
    
    @IBAction func shelterInfoButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toShelter", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShelter" {
            guard let destinationVC = segue.destination as? ShelterDetailViewController else { return }
            
            destinationVC.pet = pet
        }
    }

}













