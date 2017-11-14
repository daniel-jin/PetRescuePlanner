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
    
    var pet: Pet? = nil
    
    var petsAtShelter: [Pet] = []
    
    
    var shelter: Shelter? {
        didSet {
            guard let shelter = shelter else { return }
            
            self.updateShelterDetailView(shelter: shelter)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    
    func updateShelterDetailView(shelter: Shelter){
        
        DispatchQueue.main.async {
            self.shelterNameLabel.text = shelter.name
            self.addressbutton.setTitle("\(shelter.address) \(shelter.city), \(shelter.state)", for: .normal)
            self.numberButton.setTitle(shelter.phone, for: .normal)
            self.emailButton.setTitle(shelter.email, for: .normal)
            
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
    @IBOutlet weak var shelterMapView: MKMapView!
    @IBOutlet weak var addressbutton: UIButton!
    @IBOutlet weak var numberButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    
    // Mark: - actions
    
    @IBAction func numberButtonTapped(_ sender: Any) {
        guard let shelter = shelter else { return }
        let phoneUrl = URL(string: "tel://\(shelter.phone)")
        
        UIApplication.shared.open(phoneUrl!, options: [:], completionHandler: nil)
    }
    
    @IBAction func AddressButtonTapped(_ sender: Any) {
        
        guard let shelter = shelter else { return }
        
        let mapsDirectionURL = URL(string: "http://maps.apple.com/?daddr=\(shelter.latitude),\(shelter.longitude)")!
        UIApplication.shared.open(mapsDirectionURL, completionHandler: nil)
    }
    
    @IBAction func viewPetsAtShelterButtonTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toPetsList", sender: self)
        
    }
    
    // Mark: - navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPetsList" {
            guard let destinationVC = segue.destination as? SavedPetsListTableViewController else { return }
            guard let pet = pet else { return }
            
            PetController.shared.fetchPetsFor(method: methods.petsAtSpecificShelter, shelterId: pet.shelterId, location: nil, animal: nil , breed: nil, size: nil, sex: nil, age: nil, offset: nil) { (success) in
                if !success {
                    NSLog("Error fetching pets from shelter")
                    return
                }
                
                destinationVC.savedPets = PetController.shared.pets
                
            }
            
        }
        
    }
}



