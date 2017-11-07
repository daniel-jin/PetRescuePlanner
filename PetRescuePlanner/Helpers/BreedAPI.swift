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
        let apiKey = parameters.apiKey
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
        
        NetworkController.performRequest(for: searchURL, httpMethod: NetworkController.HTTPMethod.get, body: nil) { (data, error) in
            
            if let error = error {
                NSLog("error \(error.localizedDescription)")
            }
            
            guard let data = data else { return }
            
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any] else {
                return completion(false)
            }
            
            guard let petfinderDictionary = jsonDictionary["petfinder"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let breedsDictionary = petfinderDictionary["breeds"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let breedsArray = breedsDictionary["breed"] as? [[String: Any]] else {
                return completion(false)
            }
            
            var breedList: [String] = []
            
            for index in 0..<breedsArray.count {
                breedList.append(breedsArray[index]["$t"] as! String)
            }
            self.breeds = breedList
            
            completion(true)
        }
        
    }
    
}
