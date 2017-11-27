//
//  SearchResultsTableViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    var resultsArray: [String] = []
    weak var customizableSearchViewController: CustomizableSearchViewController?
    weak var breedSearchViewController: BreedSearchContainerViewController?
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        let breed = resultsArray[indexPath.row]
        cell.textLabel?.text = breed
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        guard let breed = cell?.textLabel?.text else{ return }
        
        let dict: [String: Any] = ["breed": breed, "containerStatus": true, "breedLabelValue": breed]
        
        NotificationCenter.default.post(name: Notifications.BreedWasSetNotification, object: nil, userInfo: dict)
        
    }
}
