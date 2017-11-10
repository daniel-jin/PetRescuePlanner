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
    
    init() {
        
    }
    
    let id = ShelterKeys.idKey
    let keys = API.Keys()
    let methods = API.Methods()
    let parameters = API.Parameters()
    let responseFormat = API.Parameters().jsonFormat
    
    func fetchShelter(by id: String?, completion: @escaping (_ success: Bool) -> Void) {
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
        
        var request = URLRequest(url: url)
        request.httpMethod = NetworkController.HTTPMethod.get.rawValue
        request.httpBody = nil
        
        
    }
    
}
