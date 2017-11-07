//
//  PetDetailTableViewController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class PetDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var petImageScrollView: UIScrollView!
    var pet: Pet?
    var images = [UIImageView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let count = pet?.media.count
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }



}
