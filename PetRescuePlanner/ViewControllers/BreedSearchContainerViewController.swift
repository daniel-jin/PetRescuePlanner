//
//  BreedSearchContainerViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class BreedSearchContainerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    // MARK: - Properties
    
    var searchController : UISearchController?
    
    var breeds: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.breedsTableView.reloadData()
            }
        }
    }
    
    // MARK: - Outlets 

    @IBOutlet weak var breedsTableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController()
        
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
    
    // MARK: - SearchController funcs
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let resultsController = searchController.searchResultsController as? SearchResultsTableViewController,
            let searchTerm = searchController.searchBar.text?.lowercased() {
            
            let breedList = breeds
            
            let searchBreeds = breedList.filter({ (breed) -> Bool in
                return breed.lowercased().contains(searchTerm)
            }).map({ $0 })
            resultsController.resultsArray = searchBreeds
            resultsController.tableView.reloadData()
            
        }
    }
    
    // MARK: - Private funcs
    
    func setUpSearchController() {
        
        
        let resultsController = UIStoryboard(name: "CustomizableSearch", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsTableViewController")
        
        searchController = UISearchController(searchResultsController: resultsController)
        
        searchController?.searchResultsUpdater = self
        
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.searchBarStyle = .minimal
        searchController?.hidesNavigationBarDuringPresentation = true
        
        breedsTableView.tableHeaderView = searchController?.searchBar
        definesPresentationContext = true
        
    }
    
    /*
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    */

}
