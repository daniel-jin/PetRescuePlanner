//
//  ShelterAPI.swift
//  PetRescuePlanner
//
//  Created by Brian Licea on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

class ShelterAPI {
    
    static let shelterShared = ShelterAPI()
    
    init() {
        
    }
    
    let keys = API.Keys()
    let methods = API.Methods()
    let parameters = API.Parameters()
    let responseFormat = API.Parameters().jsonFormat
    
    func fetchShelterFor(id: String, completion: @escaping (_ success: Bool) -> Void) {
        let method = methods.specificShelter
        let output = responseFormat
        let apiKey = parameters.apiKey
        let baseURL = URL(string: parameters.baseUrl)
        
        var queryItems:[URLQueryItem] = []
        
        var componets = URLComponents(url: (baseURL?.appendingPathComponent(method))!, resolvingAgainstBaseURL: true)
        
        let apiKeyItem = URLQueryItem(name: keys.apiKey, value: apiKey)
        let outputItem = URLQueryItem(name: keys.formatKey, value: output)
        queryItems.append(apiKeyItem)
        queryItems.append(outputItem)
        
        componets?.queryItems = queryItems
        
        guard let searchURL = componets?.url else { return }
        
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
            
            guard let shelterDictionary = petfinderDictionary["shelter"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let idDictionary = shelterDictionary["id"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let addressDictionary = shelterDictionary["address"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let nameDictionary = shelterDictionary["name"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let phoneDictionary = shelterDictionary["phone"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let stateDictionary = shelterDictionary["state"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let emailDictionary = shelterDictionary["email"] as? [String: Any] else {
                return completion(false)
            }
            
            guard let cityDictionary = shelterDictionary["city"] as? [String: Any] else {
                return completion(false)
            }
        }
    }
    
}
