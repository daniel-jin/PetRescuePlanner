//
//  ShelterDetailViewController.swift
//  PetRescuePlanner
//
//  Created by Brian Licea on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
import CallKit

class ShelterDetailViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
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
        
        self.title = "Shelter Info"
        
        findMorePetsButton.backgroundColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        addressbutton.titleLabel?.textColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        numberButton.titleLabel?.textColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        emailButton.titleLabel?.textColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func updateShelterDetailView(shelter: Shelter){
        
        DispatchQueue.main.async {
            let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
            guard let loveStory = UIFont(name: "Love Story Rough", size: 25.0) else { return }
            let shelterName: NSMutableAttributedString = NSMutableAttributedString(string: shelter.name, attributes: [NSAttributedStringKey.font : loveStory, NSAttributedStringKey.foregroundColor: redColor])
            self.shelterNameLabel.attributedText = shelterName
            self.numberButton.setTitle(shelter.phone, for: .normal)
            self.emailButton.setTitle(shelter.email, for: .normal)
            
            var addressButtonTitle = ""
            
            if shelter.address == ShelterKeys.noInfo {
                addressButtonTitle = "Get directions"
            } else {
                addressButtonTitle = "\(shelter.address) \(shelter.city), \(shelter.state)"
            }
            
            self.addressbutton.setTitle(addressButtonTitle, for: .normal)
            
            
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
    @IBOutlet weak var findMorePetsButton: UIButton!
    
    // Mark: - actions
    
    // Mark: - Emailing shelter
    @IBAction func toSavedPetsButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toSavedPets", sender: self)
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        
        
        let mailComposeViewController = configureMailController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    func configureMailController() -> MFMailComposeViewController {
        if let pet = pet {
            let mailComposerVC = MFMailComposeViewController()
            mailComposerVC.mailComposeDelegate = self
            mailComposerVC.setToRecipients([(shelter?.email)!])
            guard let name = pet.name else { return MFMailComposeViewController() }
            mailComposerVC.setSubject("Interested in \(String(describing: name))")
            
            return mailComposerVC
        }
        return MFMailComposeViewController()
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Mark: - calling shelter
    
    @IBAction func numberButtonTapped(_ sender: Any) {
        guard let shelter = shelter else {return}
        
        var number = shelter.phone.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
        
        var realPhoneNumber: String = ""
        
        let numbers: [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        
        if number.count > 10 {
            
            let numbersToDrop = number.count - 10
            
            for _ in 1...numbersToDrop {
                number.removeLast()
            }
        }
        
        for character in number {
            
            var characterToAddToPhoneNumber = character
            
            if !numbers.contains(character) {
                
                guard let numberValue = letterDictionary[character] else { break }
                
                characterToAddToPhoneNumber = numberValue
            }
            realPhoneNumber.append(characterToAddToPhoneNumber)
        }
        
        if let phoneCallURL:URL = URL(string: "tel:\(realPhoneNumber)") {
            let application:UIApplication = UIApplication.shared
            application.open(phoneCallURL)
            
        }
    }
    // Mark: - clean up a bit have all the letters that are asigned to the same number on the same row
    let letterDictionary: [Character: Character] = ["a" : "2",
                                                    "b" : "2",
                                                    "c" : "2",
                                                    "d" : "3",
                                                    "e" : "3",
                                                    "f" : "3",
                                                    "g" : "4",
                                                    "h" : "4",
                                                    "i" : "4",
                                                    "j" : "5",
                                                    "k" : "5",
                                                    "l" : "5",
                                                    "m" : "6",
                                                    "n" : "6",
                                                    "o" : "6",
                                                    "p" : "7",
                                                    "q" : "7",
                                                    "r" : "7",
                                                    "s" : "7",
                                                    "t" : "8",
                                                    "u" : "8",
                                                    "v" : "8",
                                                    "w" : "9",
                                                    "x" : "9",
                                                    "y" : "9",
                                                    "z" : "9"]
    
    // Mark: - getting directions
    
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
            guard let destinationVC = segue.destination as? ShelterPetsListTableViewController else { return }
            guard let pet = pet else { return }
            
            PetController.shared.fetchPetsFor(method: methods.petsAtSpecificShelter, shelterId: pet.shelterID, location: nil, animal: nil , breed: nil, size: nil, sex: nil, age: nil, offset: nil) { (success, petList, offset) in
                if !success {
                    NSLog("Error fetching pets from shelter")
                    return
                }
                
                guard let petList = petList else { return }
                destinationVC.savedPets = petList
                
            }
            
        }
        
    }
}





