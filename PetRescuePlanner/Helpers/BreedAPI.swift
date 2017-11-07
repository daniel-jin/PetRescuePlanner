//
//  BreedAPI.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation


class BreedAPI {
    
    static let shared = BreedAPI()
    
    var breeds: [String] = []
    
    
    init() {
        
    }
    
    let keys = API.Keys()
    let methods = API.Methods()
    let parameters = API.Parameters()
    let responseFormat = API.Parameters().jsonFormat
    
    func fetchBreedsFor(animalType: String, completion: @escaping (_ success: Bool) -> Void) {
        
        let method = methods.breed
        let output = responseFormat
        let apiKey = keys.apiKey
        let baseURL = URL(string: parameters.baseUrl)!
        
        var queryItems:[URLQueryItem] = []
        
        let animalItem = URLQueryItem(name: keys.animalKey, value: animalType)
        queryItems.append(animalItem)
        
        var components = URLComponents(url: baseURL.appendingPathComponent(method), resolvingAgainstBaseURL: true)
        
        let apiKeyItem = URLQueryItem(name: keys.apiKey, value: apiKey)
        let outputItem = URLQueryItem(name: keys.formatKey, value: output)
        queryItems.append(apiKeyItem)
        queryItems.append(outputItem)
        
        components?.queryItems = queryItems
        
        guard let searchURL = components?.url else { return }
        
        NetworkController.performRequest(for: searchURL, httpMethod: NetworkController.HTTPMethod.get)
        completion(true)
        
    }
    
}
