//
//  Keys.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

class API {
    
    struct Parameters {
        
        let apiKey = "73c75e3c063309430144f8ad39125ec7"
        let baseUrl = "http://api.petfinder.com"
        let jsonFormat = "json"
    }
    
    struct Methods {
        let breed = "breed.list" // Returns a list of breeds for a particular animal.
        let specificPet = "pet.get" // Returns a record for a single pet.
        let randomPet = "pet.getRandom" /* Returns a record for a randomly selected pet. You can choose the characteristics of the pet you want returned using the various arguments to this method.
         This method can return pet records in three formats:
         id: just the pet ID
         basic: essential information like name, animal, breed, shelter ID, primary photo
         full: the complete pet record
         */
        let pets = "pet.find" /* Searches for pets according to the criteria you provde and returns a collection of pet records matching your search. The results will contain at most count records per query, and a lastOffset tag. To retrieve the next result set, use the lastOffset value as the offset to the next pet.find call.
         NOTE: the total number of records you are allowed to request may vary depending on the type of developer key you have.
         */
        let shelters = "shelter.find" // Returns a collection of shelter records matching your search criteria.
        let specificShelter = "shelter.get" // Returns a record for a single shelter.
        let petsAtSpecificShelter = "shelter.getPets" // Returns a list of IDs or collection of pet records for an individual shelter
        let sheltersWithBreed = "shelter.listByBreed" // Returns a list of shelter IDs listing animals of a particular breed.
    }
    
    struct Keys {
        
        // MARK: - Item Key
        let itemKey = "$t"
        let apiKey = "key"
        let petFinderKey = "petfinder"
        let lastOffsetKey = "lastOffset"
        let petsKey = "pets"
        let petKey = "pet"
        let locationKey = "location"
        let imageId = "@id"
        
        // MARK: - Top Level Keys
        var ageKey = "age"
        let animalKey = "animal"
        let breedsKey = "breeds"
        let contactInfoKey = "contact"
        let descriptionKey = "description"
        let idKey = "id"
        let lastUpdatKey = "lastUpdate"
        let mediaKey = "media"
        let mixKey = "mix"
        let nameKey = "name"
        let optionsKey = "options"
        let sexKey = "sex"
        let shelterIdKey = "shelterId"
        let sizeKey = "size"
        let statusKey = "status"
        
        // MARK: - Breeds Keys
        let breedKey = "breed"
        
        // MARK: - Contact Keys
        let phoneKey = "phone"
        let stateKey = "state"
        let emailKey = "email"
        let cityKey = "city"
        let zipKey = "zip"
        let addressKey = "address1"
        
        // MARK: - Options Keys
        let optionKey = "option"
        let offsetKey = "offset"
        let formatKey = "format"
        
        // MARK: - Photo Keys
        let photoKey = "photo"
        let photosKey = "photos"
        
    }
}

struct CloudKit {
    
    // MARK: - Keys for CloudKit
    static let appleUserRefKey = "appleUserRef"
    
    static let petRecordType = "Pet"
    
    static let userRecordType = "User"
    
    static let savedPetsRefKey = "savedPets"
    
    // Notification center
    static let CurrentUserWasSetNotification = Notification.Name("currentUserWasSet")
    
}

struct Notifications {
    static let BreedWasSetNotification = Notification.Name("BreedWasSetNotification")
    static let SearchBarEditingBegan = Notification.Name("SearchBarEditingBegan")
    static let SearchBarEditingEnded = Notification.Name("SearchBarEditingEnded")
}

class ShelterKeys {
    
    // Mark: - Top level
    static let petfinderKey = "petfinder"
    
    // Mark: - in petfinder dictionary
    static let shelterKey = "shelter"
    
    // Mark: - in shelter dictionary
    static let addressKey = "address1"
    static let idKey = "id"
    static let nameKey = "name"
    static let stateKey = "state"
    static let cityKey = "city"
    static let emailKey = "email"
    static let phoneKey = "phone"
    static let zipKey = "zip"
    static let longitudeKey = "longitude"
    static let latitudeKey = "latitude"
    static let noInfo = "No info available"
    static let fakeLanLon = 10101010101010101010101010101010101.17459813759812739587213947123984791823749
}

































