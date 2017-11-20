//
//  NetworkController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import Foundation

class NetworkController {
    
    // MARK: Properties
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    static func performRequest(for url: URL, httpMethod: HTTPMethod, body: Data? = nil, completion: ((Data?, Error?) -> Void)? = nil) {
                
        // Build URL
        var request = URLRequest(url: url)
        
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        // Create and run task
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in completion?(data, error)
            
            if let error = error {
                NSLog("Error fetching data in networkController \(error.localizedDescription).")
                completion!(nil, error)
            }
            
            guard let data = data else {
                NSLog("No data returned in networkController.")
                return completion!(nil, error)
            }
            
            completion!(data, nil)
            return
        }
        dataTask.resume()
    }
    

    
}
