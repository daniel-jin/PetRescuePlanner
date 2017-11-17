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
    
    var breed: String?
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        breed = breeds[indexPath.row]
        searchController?.searchBar.text = breed
        
        let dicts = ["breed": breed, "containerStatus": true, "breedLabelValue": breed] as [String : Any]
        
        NotificationCenter.default.post(name: Notifications.BreedWasSetNotification, object: nil, userInfo: dicts)
    }
    
    func updateParentValues(breed: String) {
        
        searchController?.searchBar.text = breed
        guard let p = self.parent as? CustomizableSearchViewController else { return }
        
        p.breed = breed
        p.breedSearchContainerView.isHidden = true
        p.selectBreedLabel.text = breed 

        
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
        searchController?.hidesNavigationBarDuringPresentation = false
        
        breedsTableView.tableHeaderView = searchController?.searchBar
        definesPresentationContext = true
        
    }

}
