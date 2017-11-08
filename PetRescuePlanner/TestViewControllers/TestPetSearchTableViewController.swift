//
//  TestPetSearchTableViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class TestPetSearchTableViewController: UITableViewController {
    
    var pets: [Pet] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pets.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "petListCell", for: indexPath)

        let pet = pets[indexPath.row]
        
        cell.textLabel?.text = pet.name

        return cell
    }


}
