//
//  ShelterController.swift
//  PetRescuePlanner
//
//  Created by Brian Licea on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

class ShelterController {
    
    // MARK: - Properties
    
    static let shelterShared = ShelterController()
    
    var shelters: [Shelter] = []
    
    init() {
        
    }
    
    let methods = API.Methods().specificShelter
    let parameters = API.Parameters()
    let responseFormat = API.Parameters().jsonFormat
    let baseURL = URL(string: ShelterKeys.shelterURL)
    
    // you might want to put Shelter? in the ()
    func fetchShelter(by id: String, name: String?, address: String?, state: String?, city: String?, phone: String?, completion: @escaping () -> Void) {
        
        let apiKey = parameters.apiKey
        
        guard let unwrappedURL = baseURL else {
            print("Broken URL")
            completion(); return
        }
        
        var componets = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        
        let queryItem1 = URLQueryItem(name: "key", value: parameters.apiKey)
        let queryItem2 = URLQueryItem(name: "id", value: id)
        let queryItem3 = URLQueryItem(name: "format", value: parameters.jsonFormat)
        
        guard let url = componets?.url else { completion(); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = NetworkController.HTTPMethod.get.rawValue
        request.httpBody = nil
        
        
        
        
        
    }
    
}
