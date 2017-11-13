//
//  ShelterDetailViewController.swift
//  PetRescuePlanner
//
//  Created by Brian Licea on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import MapKit

class ShelterDetailViewController: UIViewController {
    
    let methods = API.Methods()
    
    let pet: Pet? = nil
    var petsAtShelter: [Pet] = []
    
    
    var shelter: Shelter? {
        didSet {
            guard let shelter = shelter else { return }
            
            self.updateShelterDetailView(shelter: shelter)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        ShelterController.shelterShared.fetchShelter(id: String(describing: pet?.shelterId)) { (success) in
            if !success {
                NSLog("Error")
                return
                
            }
            self.shelter = ShelterController.shelterShared.shelter
        }
    }
    
    
    func updateShelterDetailView(shelter: Shelter){
        
        DispatchQueue.main.async {
            self.shelterNameLabel.text = shelter.name
            self.addressLabel.text = "\(shelter.address), \(shelter.city), \(shelter.state)"
            self.numberLabel.text = shelter.phone
            self.emailLabel.text = shelter.email
            
            var numberToPhone = self.numberLabel.text
            numberToPhone = shelter.phone
            
            
            guard let numberUrl = URL(string: "tel://\(String(describing: numberToPhone))") else { return }
            UIApplication.shared.open(numberUrl, options: [:], completionHandler: nil)
            
            // Mark: - Map view
            
            
                    // Mark: - Remove annotations
                    let annotaions = self.shelterMapView.annotations
                    self.shelterMapView.removeAnnotations(annotaions)
                    
                  
                    
                    // Mark: - create annotation
                    let annotation = MKPointAnnotation()
                    annotation.title = shelter.name
                    annotation.coordinate = CLLocationCoordinate2DMake(shelter.latitude, shelter.longitude)
                    self.shelterMapView.addAnnotation(annotation)
                    
                    // Mark: - zooming in on the annotaion
                    let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(shelter.latitude, shelter.longitude)
                    let span = MKCoordinateSpanMake(0.1, 0.1)
                    let region = MKCoordinateRegionMake(coordinate, span)
                    self.shelterMapView.setRegion(region, animated: true)
                    
                
            
        }
    }
    
    // Mark: - outlets
    
    @IBOutlet weak var shelterNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var shelterMapView: MKMapView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // Mark: - actions
    
    @IBAction func viewPetsAtShelterButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toPetsList", sender: self)
        
    }
    
    
    @IBAction func directionsButtonTapped(_ sender: Any) {
        
        guard let shelter = shelter else { return }
        
        let mapsDirectionURL = URL(string: "http://maps.apple.com/?daddr=\(shelter.latitude),\(shelter.longitude)")!
        UIApplication.shared.open(mapsDirectionURL, completionHandler: nil)
    }
    
    // Mark: - navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPetsList" {
            guard let destinationVC = segue.destination as? SavedPetsListTableViewController else { return }
            
            PetController.shared.fetchPetsFor(method: methods.petsAtSpecificShelter, shelterId: "UT183", location: nil, animal: nil , breed: nil, size: nil, sex: nil, age: nil, offset: nil) { (success) in
                if !success {
                    NSLog("Error fetching pets from shelter")
                    return
                }
                self.petsAtShelter = PetController.shared.pets
                destinationVC.savedPets = self.petsAtShelter

            }
            
        }
        
    }
}



