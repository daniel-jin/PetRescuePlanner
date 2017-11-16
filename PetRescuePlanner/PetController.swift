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
    
    // MARK: - Properties
    
    static let shared = PetController()
    
    var pets: [Pet] = []
    var offset: String = ""
    
    var savedPets: [Pet] {
        // MARK: - Fetched Results Controller configuration
        // set up request
        let request: NSFetchRequest<Pet> = Pet.fetchRequest()
        
        // Set up sort descriptors for the request
        request.sortDescriptors = [NSSortDescriptor(key: "dateAdded", ascending: false)]
        
        // Perform fetch - handle errors
        do {
            var results = try CoreDataStack.context.fetch(request)
            
            for result in results {
                if result.contactInfo == nil {
                    CoreDataStack.context.delete(result)
                }
            }
            
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
        
//        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Pet")
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)
//        do {
//            try NSManagedObjectContext.execute
//        } catch {
//            // error handling
//        }
        
        
//        performFullSync()
        
        /* flush function to delete all records of a record type
        let query = CKQuery(recordType: "Pet", predicate: NSPredicate(value: true))
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            if error == nil {
                
                for record in records! {
                    
                    CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID, completionHandler: { (recordId, error) in
                        
                        if error == nil {
                            
                            //Record deleted
                        }
                    })
                }
            }
        }
         */
        
    }
    
    let keys = API.Keys()
    let methods = API.Methods()
    let parameters = API.Parameters()
    let responseFormat = API.Parameters().jsonFormat
    
    
    func fetchPetsFor(method: String, shelterId: String?, location: String?, animal: String?, breed: String?, size: String?, sex: String?, age: String?, offset: String?, completion: @escaping (_ success: Bool) -> Void) {
        
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
        
        var count = ""
        
        if method == "pet.find" {
            count = "10"
        } else {
            count = "50"
        }
        
        let countItem = URLQueryItem(name: "count", value: count)
        
        queryItems.append(countItem)
        
        components?.queryItems = queryItems
        
        guard let searchUrl = components?.url else { return }
        
        NetworkController.performRequest(for: searchUrl, httpMethod: NetworkController.HTTPMethod.get, body: nil) { (data, error) in
            
            if let error = error {
                NSLog("Error serializing JSON in \(#file) \(#function). \(error), \(error.localizedDescription)")
                completion(false)
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
            
            self.offset = lastOffset
            
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
            
            self.pets = filteredPets
            completion(true)
        }
    }
    
    // Updated by Dan Rodosky 11/9/2017
    
    func fetchImageFor(pet: Pet, number: Int, completion: @escaping (_ success: Bool, _ image: UIImage?) -> Void) {
        
        guard let media = pet.media else { return }
        
        guard let photos = (try? JSONSerialization.jsonObject(with: media as Data, options: .allowFragments)) as? [String] else {
            completion(false, nil)
            return
        }
        
        let photo = photos[number]
        
        guard let photoURL = URL(string: photo) else { return completion(false, nil) }
        
        NetworkController.performRequest(for: photoURL, httpMethod: NetworkController.HTTPMethod.get, body: nil) { (data, error) in
            if let error = error {
                NSLog("error fetching pet photo in pet controller \(error)")
                completion(false, nil)
            }
            guard let data = data else { return completion(false, nil) }
            
            let imageReturned = UIImage(data: data)
            
            completion(true, imageReturned)
        }
    }
    
    func fetchAllPetImages(pet: Pet, completion: @escaping ([UIImage]?) -> Void) {
        
        guard let lastId = pet.imageIdCount else { return }
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
        
        let tempUrls = photoUrls
        photoUrls += tempUrls
        
        for photo in photoUrls {
            
            guard let photoUrl = URL(string: photo) else { return }
            
            dispatchGroup.enter()
            
            NetworkController.performRequest(for: photoUrl, httpMethod: NetworkController.HTTPMethod.get, body: nil, completion: { (data, error) in
                
                if let error = error {
                    NSLog("Error fetching images. \(#file) \(#function), \(error): \(error.localizedDescription)")
                    dispatchGroup.leave()
                    completion(nil)
                    return
                }
                
                guard let data = data,
                    let image = UIImage(data: data) else { dispatchGroup.leave(); completion(nil); return}
                
                guard petImageArray.count < count * 2 else { return }
                
                petImageArray.append((photo, image))
                
                dispatchGroup.leave()
                
            })
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
}








