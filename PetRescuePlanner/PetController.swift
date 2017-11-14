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
    
//    // Fetched results controller for Core Data
//    let fetchedResultsController: NSFetchedResultsController<Pet>!
    
    var pets: [Pet] = []
    
    var savedPets: [Pet] {
        // MARK: - Fetched Results Controller configuration
        // set up request
        let request: NSFetchRequest<Pet> = Pet.fetchRequest()
//        request.predicate = NSPredicate(format: <#T##String#>, <#T##args: CVarArg...##CVarArg#>) // Set up predicate to filter pets?
        
        // Set up sort descriptors for the request
        request.sortDescriptors = [NSSortDescriptor(key: "breeds", ascending: true)]
        
        // Perform fetch - handle errors
        do {
            let results = try CoreDataStack.context.fetch(request)
            return results.filter { $0.contactInfo != nil }
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
                let petsDictionary = petfinderDictionary[self.keys.petsKey] as? [String: Any],
                let petsArray = petsDictionary[self.keys.petKey] as? [[String: Any]] else { return }
            let arrayOfPets = petsArray.flatMap { Pet(dictionary: $0, context: nil) }
            self.pets = arrayOfPets
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
        let imageBaseUrl = URL(string: "http://photos.petfinder.com/photos/pets")
        let count = Int(lastId) ?? 0
        guard let id = pet.id else { return }
        var petImageArray: [UIImage] = []
        
        for index in 1...count {
            
            dispatchGroup.enter()

            guard let imageEndpoint = imageBaseUrl?.appendingPathComponent(id).appendingPathComponent("\(index)/") else { dispatchGroup.leave(); break }
            
            NetworkController.performRequest(for: imageEndpoint, httpMethod: NetworkController.HTTPMethod.get, body: nil, completion: { (data, error) in
                
                if let error = error {
                    NSLog("Error fetching images. \(#file) \(#function), \(error): \(error.localizedDescription)")
                    dispatchGroup.leave()
                    completion(nil)
                    return
                }
                guard let data = data,
                    let image = UIImage(data: data) else { dispatchGroup.leave(); completion(nil); return}
                
                guard petImageArray.count < count else { return }
                petImageArray.append(image)
                
                dispatchGroup.leave()
                
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(petImageArray)
        }
    }
    
}








