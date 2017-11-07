//
//  BreedSearchContainerViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class BreedSearchContainerViewController: UIViewController {
    
    // MARK: - Properties 
    
    var breeds: [String]? {
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }

    /*
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

}
