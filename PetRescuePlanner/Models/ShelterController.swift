//
//  ShelterController.swift
//  PetRescuePlanner
//
//  Created by Brian Licea on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

class ShelterController {
    
    var shelter: Shelter?
    
    static let shelterShared = ShelterController()
    
    var shelters: [Shelter] = []
    
    init() {
        
    }
    
    let id = ShelterKeys.idKey
    let keys = API.Keys()
    let methods = API.Methods()
    let parameters = API.Parameters()
    let responseFormat = API.Parameters().jsonFormat
    
    func fetchShelter(id: String?, completion: @escaping (_ success: Bool) -> Void) {
        let method = methods.specificShelter
        let output = responseFormat
        let apiKey = parameters.apiKey
        let baseURL = URL(string: parameters.baseUrl)
        
        var queryItems:[URLQueryItem] = []
        
        var componets = URLComponents(url: (baseURL?.appendingPathComponent(method))!, resolvingAgainstBaseURL: true)
        
        let apiKeyItem = URLQueryItem(name: keys.apiKey, value: apiKey)
        let outputItem = URLQueryItem(name: keys.formatKey, value: output)
        let shelterIdItem = URLQueryItem(name: ShelterKeys.idKey, value: id)
        queryItems.append(apiKeyItem)
        queryItems.append(outputItem)
        queryItems.append(shelterIdItem)
        
        componets?.queryItems = queryItems
        
        guard let searchURL = componets?.url else { return }
        
        NetworkController.performRequest(for: searchURL, httpMethod: NetworkController.HTTPMethod.get, body: nil) { (data, error) in
            
            if let error = error {
                NSLog("Error serializing JSON in \(#file) \(#function). \(error), \(error.localizedDescription)")
                completion(false)
            }
            guard let data = data else {return}
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
                return completion(false)
            }
            
            guard let petfinderDictionary = jsonDictionary["petfinder"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let shelterDictionary = petfinderDictionary["shelter"] as? [String: Any] else {
                return completion(false)
            }
            
            let shelter = Shelter(dictionary: shelterDictionary)
            
            self.shelter = shelter
            completion(true)
        }
    }
}
