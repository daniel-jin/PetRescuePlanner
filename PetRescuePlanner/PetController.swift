//
//  PetController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UIKit

class PetController {
    
    // MARK: - Properties
    
    static let shared = PetController()
    
    var pets: [Pet] = []
    
    let cloudKitManager: CloudKitManager
    
    init() {
        
        self.cloudKitManager = CloudKitManager()
        performFullSync()
        
    }
    
    let keys = API.Keys()
    let methods = API.Methods()
    let parameters = API.Parameters()
    let responseFormat = API.Parameters().jsonFormat
    
    func fetchPetsFor(location: String, animal: String?, breed: String?, size: String?, sex: String?, age: String?, offset: String?, completion: @escaping (_ success: Bool) -> Void) {
        
        let method = methods.pets
        let output = responseFormat
        let apiKey = parameters.apiKey
        let baseUrl = URL(string: parameters.baseUrl)!
        
        var queryItems: [URLQueryItem] = []
        
        if let animal = animal {
            let animalItem = URLQueryItem(name: keys.animalKey, value: animal)
            queryItems.append(animalItem)
        }
        if let breed = breed {
            let breedItem = URLQueryItem(name: keys.breedKey, value: breed)
            queryItems.append(breedItem)
        }
        if let size = size {
            let sizeItem = URLQueryItem(name: keys.sizeKey, value: size)
            queryItems.append(sizeItem)
        }
        if let sex = sex {
            let sexItem = URLQueryItem(name: keys.sexKey, value: sex)
            queryItems.append(sexItem)
        }
        if let age = age {
            let ageItem = URLQueryItem(name: keys.ageKey, value: age)
            queryItems.append(ageItem)
        }
        if let offset = offset {
            let offsetItem = URLQueryItem(name: keys.offsetKey, value: offset)
            queryItems.append(offsetItem)
        }
        
        var components = URLComponents(url: baseUrl.appendingPathComponent(method), resolvingAgainstBaseURL: true)
        
        let apiKeyItem = URLQueryItem(name: keys.apiKey, value: apiKey)
        let outputItem = URLQueryItem(name: keys.formatKey, value: output)
        let locationItem = URLQueryItem(name: keys.locationKey, value: location)
        queryItems.append(locationItem)
        queryItems.append(apiKeyItem)
        queryItems.append(outputItem)
        components?.queryItems = queryItems
        
        guard let searchUrl = components?.url else { return }
        
        NetworkController.performRequest(for: searchUrl, httpMethod: NetworkController.HTTPMethod.get, body: nil) { (data, error) in
            
            if let error = error {
                NSLog("Error serializing JSON in \(#file) \(#function). \(error), \(error.localizedDescription)")
                completion(false)
            }
            guard let data = data else { return }
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: [String: Any]],
                let petfinderDictionary = jsonDictionary[self.keys.petFinderKey] as? [String: [String: Any]],
                let petsDictionary = petfinderDictionary[self.keys.petsKey],
                let petsArray = petsDictionary[self.keys.petKey] as? [[String: Any]] else { return }
            let arrayOfPets = petsArray.flatMap { Pet(dictionary: $0) }
            self.pets = arrayOfPets
            completion(true)
        }
    }
    
    func fetchImagesFor(pet: Pet, completion: @escaping (_ imageData: [Data]?,_ error: Error?) -> Void) {
        let photos = pet.media
        let dispatchGroup = DispatchGroup()
        var images: [Data] = []
        
        for urlString in photos {
            
            dispatchGroup.enter()
            guard let searchUrl = URL(string: urlString) else { dispatchGroup.leave(); return }
            
            NetworkController.performRequest(for: searchUrl, httpMethod: NetworkController.HTTPMethod.get, body: nil, completion: { (data, error) in
                if let error = error {
                    NSLog("Error fetching images. \(#file) \(#function), \(error): \(error.localizedDescription)")
                    completion(nil, error)
                }
                guard let data = data else { dispatchGroup.leave(); return completion(nil, error) }
                images.append(data)
                
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main) {
            completion(images, nil)
        }
    }
}








