//
//  ShelterController.swift
//  PetRescuePlanner
//
//  Created by Brian Licea on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UIKit

class ShelterController {
    
    let baseURL = URL(string: ShelterKeys.shelterURL)
    
    func fetchShelter(by name: String, address: String?, state: String?, city: String?, phone: String?, completion: @escaping (Shelter?) -> Void) {
        
        guard let unwrappedURL = baseURL else {
            print("Broken URL")
            completion(nil); return
        }
        
        var urlComponets = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        
        
      
    }
    
}
