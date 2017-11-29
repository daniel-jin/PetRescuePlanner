//
//  PetController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CloudKit

class PetController {
    
    var guardCount = 0
    
    // MARK: - Properties
    
    static let shared = PetController()
    
    var pets: [Pet] = []
    
    var savedPets: [Pet] {
        // MARK: - Core Data fetch
        // set up request
        let request: NSFetchRequest<Pet> = Pet.fetchRequest()
        
        // Set up sort descriptors for the request
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        
        // Perform fetch - handle errors
        do {
            var results = try CoreDataStack.context.fetch(request)
            
            results = try CoreDataStack.context.fetch(request)
            return results
        } catch {
            NSLog("There was an error configuring the fetched results. \(error.localizedDescription)")
            return []
        }
    }
    
    let cloudKitManager: CloudKitManager
    
    init() {
        
        self.cloudKitManager = CloudKitManager()
        
    }
    
    let keys = API.Keys()
    let methods = API.Methods()
    let parameters = API.Parameters()
    let responseFormat = API.Parameters().jsonFormat
    
    
    func fetchPetsFor(count: String, method: String, shelterId: String?, location: String?, animal: String?, breed: String?, size: String?, sex: String?, age: String?, offset: String?, completion: @escaping (_ success: Bool, _ petList: [Pet]?, _ offset: String?) -> Void) {
                
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
        if let location = location{
            let locationItem = URLQueryItem(name: keys.locationKey, value: location)
            queryItems.append(locationItem)
        }
        if let shelterId = shelterId {
            let shelterIdItem = URLQueryItem(name: keys.idKey, value: shelterId)
            queryItems.append(shelterIdItem)
        }
        
        var components = URLComponents(url: baseUrl.appendingPathComponent(method), resolvingAgainstBaseURL: true)
        
        let apiKeyItem = URLQueryItem(name: keys.apiKey, value: apiKey)
        let outputItem = URLQueryItem(name: keys.formatKey, value: output)
        queryItems.append(apiKeyItem)
        queryItems.append(outputItem)
        
        // Tesing with larger count
        
        let countItem = URLQueryItem(name: "count", value: count)
        
        queryItems.append(countItem)
        
        components?.queryItems = queryItems
        
        guard let searchUrl = components?.url else { return }
        
        URLSession.shared.dataTask(with: searchUrl) { [unowned self] (data, _, error) in
            
            if let error = error {
                NSLog("Error serializing JSON in \(#file) \(#function). \(error), \(error.localizedDescription)")
                completion(false, nil, nil)
            }
            guard let data = data else { return }
            guard let jsonDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
                let petfinderDictionary = jsonDictionary[self.keys.petFinderKey] as? [String: Any],
                let offsetDict = petfinderDictionary["lastOffset"] as? [String: Any],
                let lastOffset = offsetDict[self.keys.itemKey] as? String,
                let petsDictionary = petfinderDictionary[self.keys.petsKey] as? [String: Any],
                let petsArray = petsDictionary[self.keys.petKey] as? [[String: Any]] else {
                    return
            }
            
            
            let arrayOfPets = petsArray.flatMap { Pet(dictionary: $0, context: nil) }
            
            var filteredPets: [Pet] = []
            
            var tempPet = arrayOfPets[0]
            
            for index in 1...arrayOfPets.count - 1 {
                let pet = arrayOfPets[index]
                
                guard let petName = pet.name,
                    let lastPetName = tempPet.name,
                    let petBreed = pet.breeds,
                    let lastPetBreed = tempPet.breeds,
                    let petDescrip = pet.petDescription,
                    let lastPetDescrip = tempPet.petDescription,
                    let petId = pet.id,
                    let lastPetId = tempPet.id else {
                        return
                }
                
                if !petName.contains(lastPetName) {
                    if petBreed != lastPetBreed {
                        if petDescrip != lastPetDescrip {
                            if petId != lastPetId {
                                filteredPets.append(tempPet)
                            }
                        }
                    }
                }
                tempPet = pet
            }
            
            completion(true, filteredPets, lastOffset)
            return 
            }.resume()
    }
    
    // Updated by Dan Rodosky 11/9/2017
    
    func fetchImageFor(pet: Pet, number: Int, completion: @escaping (_ success: Bool, _ image: UIImage?) -> Void) {
        
        guard let media = pet.media else { completion(false, nil); return }
        
        guard let photos = (try? JSONSerialization.jsonObject(with: media as Data, options: .allowFragments)) as? [String] else {
            completion(false, nil)
            return
        }
        
        let photo = photos[number]
        
        guard let photoURL = URL(string: photo) else { return completion(false, nil) }
        
        URLSession.shared.dataTask(with: photoURL) { (data, _, error) in
            
            if let error = error {
                NSLog("error fetching pet photo in pet controller \(error)")
                completion(false, nil)
            }
            guard let data = data else { return completion(false, nil) }
            
            let imageReturned = UIImage(data: data)
            
            completion(true, imageReturned)
        }.resume()
    }
    
    func fetchAllPetImages(pet: Pet, completion: @escaping ([UIImage]?) -> Void) {
        
        guard let lastId = pet.imageIdCount else { return completion([#imageLiteral(resourceName: "doge")]) }
        let dispatchGroup = DispatchGroup()
        let count = Int(lastId) ?? 0
        
        guard let media = pet.media else { return }
        
        guard let urls = (try? JSONSerialization.jsonObject(with: media as Data, options: .allowFragments)) as? [String] else { return }
        
        var petImageArray: [(String, UIImage)] = []
        
        var photoUrls: [String] = []
        
        for i in 1...count {
            for url in urls {
                if url.contains("/\(i)") && url.contains("width=500")  && !photoUrls.contains(url) {
                    photoUrls.append(url)
                }
            }
        }
        
        for photo in photoUrls {
            
            guard let photoUrl = URL(string: photo) else { return }
            
            dispatchGroup.enter()
            
            
            URLSession.shared.dataTask(with: photoUrl) { (data, _, error) in
                
                if let error = error {
                    NSLog("Error fetching images. \(#file) \(#function), \(error): \(error.localizedDescription)")
                    dispatchGroup.leave()
                    completion(nil)
                    return
                }
                
                guard let data = data,
                    let image = UIImage(data: data) else { dispatchGroup.leave(); completion(nil); return}
                
                guard petImageArray.count < count else { return }
                
                petImageArray.append((photo, image))
                
                dispatchGroup.leave()
                
            }.resume()
        }
        dispatchGroup.notify(queue: .main) {
            
            var images: [UIImage] = []
            var urlStrings: [String] = []
            for item in petImageArray {
                if !urlStrings.contains(item.0) {
                    urlStrings.append(item.0)
                    images.append(item.1)
                }
            }
            completion(images)
        }
    }
    
    // Takes the list of fetched pets, gets the image for each one and returns them as a tuple with the corresponding pet
    func preFetchImagesFor(pets: [Pet], completion: @escaping (_ photos: [(UIImage, Pet)]?) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        var petData: [(UIImage, Pet)] = []
        
        for index in 0...pets.count - 1 {
            
            let pet = pets[index]

            dispatchGroup.enter()
            
            fetchImageFor(pet: pet, number: 2, completion: { (success, image) in
                if !success {
                    NSLog("No image for pet")
                    petData.append((#imageLiteral(resourceName: "doge"), pet))
                }
                guard let image = image else { dispatchGroup.leave(); return completion(nil) }
                
                petData.append((image, pet))
                dispatchGroup.leave()
                
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(petData)
        }
    }
}








