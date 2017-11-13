//
//  ZipCodesStore.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/13/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

// Create an array of Int's from the USA zicodes JSON file 

struct ZipCodesStore {
    
    static func readJson(completion: @escaping ([Int]) -> Void) {
        
        do {
            if let file = Bundle.main.url(forResource: "zipCodes", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: [Int]] {
                    if let zipArray = object["zip"] {
                        completion(zipArray)
                    } else {
                        print("JSON is invalid")
                    }
                } else {
                    print("Mo file")
                }
            }
        } catch {
            print("Error serializing zipcodes from JSON, \(error.localizedDescription)")
        }
    }
}
