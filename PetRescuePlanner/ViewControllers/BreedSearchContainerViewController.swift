//
//  BreedSearchContainerViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class BreedSearchContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties 
    
    var breeds: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.breedsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Outlets 

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var breedsTableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        breedsTableView.delegate = self
        breedsTableView.dataSource = self
    }
    
    // MARK: - TableView funcs
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "amimalBreedCell", for: indexPath)
        
        let breed = breeds[indexPath.row]
        
        cell.textLabel?.text = breed
        
        return cell
    }
    
  
    

    /*
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

}
