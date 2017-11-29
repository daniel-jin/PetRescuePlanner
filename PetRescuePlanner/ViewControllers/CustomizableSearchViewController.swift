//
//  CustomizableSearchViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit
import CoreLocation

class CustomizableSearchViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Data
    
    weak var breedSearchViewController: BreedSearchContainerViewController?
    static let shared = CustomizableSearchViewController()
    
    // set to all USA Zipcodes to validate zipcode input
    
    var zipArray: [Int] = []
    
    // values to structure API call
    
    var animal: String? = nil
    var size: String? = nil
    var age: String? = nil
    var sex: String? = nil
    var breed: String? = nil
    var shelterId: String? = nil
    
    enum AnimalTypes: String {
        case any = "Any"
        case dog = "Dog"
        case cat = "Cat"
        case bird = "Bird"
        case reptile = "Reptile"
        case horse = "Horse"
        case barnYard = "Barnyard"
        case smallFurry = "Smallfurry"
    }
    
    enum AnimalSizes: String {
        case any = "Any"
        case small = "Small"
        case medium = "Medium"
        case large = "Large"
        case extraLarge = "Extra Large"
    }
    
    enum AnimalAges: String {
        case any = "Any"
        case baby = "Baby"
        case young = "Young"
        case adult = "Adult"
        case senior = "Senior"
    }
    
    // alert view colors
    
    let warningColor = UIColor.yellow
    let errorColor = UIColor.red
    let noticeColor = UIColor.white
    
    // MARK: - Outlets
    
    @IBOutlet weak var searhButton: UIButton!
    @IBOutlet weak var selectBreedLabel: UILabel!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var selectBreedButton: UIButton!
    @IBOutlet weak var breedResetButton: UIButton!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var breedSearchContainerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    // DropDown control buttons
    @IBOutlet weak var animalTypeMasterButton: UIButton!
    @IBOutlet weak var animalAgeMasterButton: UIButton!
    @IBOutlet weak var animalSizeMasterButton: UIButton!
    // DropDown value button groups
    @IBOutlet var animalTypeButtons: [UIButton]!
    @IBOutlet var animalSizeButtons: [UIButton]!
    @IBOutlet var animalAgeButtons: [UIButton]!
    
    // MARK: - Actions
    @IBAction func userLocationButtonTapped(_ sender: Any) {
        self.zipCodeTextField.text = userZipCode
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        

    }
    
    @IBAction func handleAnimalTypeTapped(_ sender: UIButton) {
        sender.setTitle(animalTypeMasterButton.titleLabel!.text, for: .normal)
        animalTypeButtons.forEach { (button) in
            button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func animalTypeTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let animalType = AnimalTypes(rawValue: title) else {
            return
        }
        
        switch animalType {
        case .any:
            self.animal = nil
            self.animalTypeMasterButton.setTitle("Any Animal Type", for: .normal)
            self.breed = nil
            self.selectBreedLabel.text = "Select Breed"
            animalTypeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .dog:
            self.animal = "dog"
            self.animalTypeMasterButton.setTitle("Search For Dogs", for: .normal)
            self.breed = nil
            self.selectBreedLabel.text = "Select Breed"
            animalTypeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .cat:
            self.animal = "cat"
            self.animalTypeMasterButton.setTitle("Search For Cats", for: .normal)
            self.breed = nil
            self.selectBreedLabel.text = "Select Breed"
            animalTypeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .bird:
            self.animal = "bird"
            self.animalTypeMasterButton.setTitle("Search For Birds", for: .normal)
            self.breed = nil
            self.selectBreedLabel.text = "Select Breed"
            animalTypeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .reptile:
            self.animal = "reptile"
            self.animalTypeMasterButton.setTitle("Search For Reptiles", for: .normal)
            self.breed = nil
            self.selectBreedLabel.text = "Select Breed"
            animalTypeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .horse:
            self.animal = "horse"
            self.animalTypeMasterButton.setTitle("Search For Horses", for: .normal)
            self.breed = nil
            self.selectBreedLabel.text = "Select Breed"
            animalTypeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .barnYard:
            self.animal = "barnyard"
            self.animalTypeMasterButton.setTitle("Search For Barnyards", for: .normal)
            self.breed = nil
            self.selectBreedLabel.text = "Select Breed"
            animalTypeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .smallFurry:
            self.animal = "smallfurry"
            self.animalTypeMasterButton.setTitle("Search For Smallfurrys", for: .normal)
            self.breed = nil
            self.selectBreedLabel.text = "Select Breed"
            animalTypeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func handleAnimalSizeTapped(_ sender: UIButton) {
        sender.setTitle(animalSizeMasterButton.titleLabel?.text, for: .normal)
        animalSizeButtons.forEach { (button) in
            button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func animalSizeTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let animalSize = AnimalSizes(rawValue: title) else {
            return
        }
        
        switch animalSize {
        case .any:
            self.size = nil
            self.animalSizeMasterButton.setTitle("Any Size", for: .normal)
            animalSizeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .small:
            self.size = "S"
            self.animalSizeMasterButton.setTitle("Small", for: .normal)
            animalSizeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .medium:
            self.size = "M"
            self.animalSizeMasterButton.setTitle("Medium", for: .normal)
            animalSizeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .large:
            self.size = "L"
            self.animalSizeMasterButton.setTitle("Large", for: .normal)
            animalSizeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .extraLarge:
            self.size = "XL"
            self.animalSizeMasterButton.setTitle("Extra Large", for: .normal)
            animalSizeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func handleAnimalAgeTapped(_ sender: UIButton) {
        sender.setTitle(animalAgeMasterButton.titleLabel?.text, for: .normal)
        animalAgeButtons.forEach { (button) in
            button.isHidden = !button.isHidden
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func animalAgeTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let animalAge = AnimalAges(rawValue: title) else {
            return
        }
        
        switch animalAge {
        case .any:
            self.age = nil
            self.animalAgeMasterButton.setTitle("Any Age", for: .normal)
            animalAgeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .baby:
            self.age = "baby"
            self.animalAgeMasterButton.setTitle("Babies", for: .normal)
            animalAgeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .young:
            self.age = "young"
            self.animalAgeMasterButton.setTitle("Young", for: .normal)
            animalAgeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .adult:
            self.age = "adult"
            self.animalAgeMasterButton.setTitle("Adult", for: .normal)
            animalAgeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        case .senior:
            self.age = "senior"
            self.animalAgeMasterButton.setTitle("Senior", for: .normal)
            animalAgeButtons.forEach { (button) in
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    @IBAction func sexSegmentedControlChanged(_ sender: Any) {
        if sexSegmentedControl.selectedSegmentIndex == 0 {
            sex = nil
        }
        if sexSegmentedControl.selectedSegmentIndex == 1 {
            sex = "M"
        }
        if sexSegmentedControl.selectedSegmentIndex == 2 {
            sex = "F"
        }
    }
    
    @IBAction func selectBreedButtonTapped(_ sender: Any) {
        
        if animal == "dog" || animal == "cat" || animal == "bird" || animal == "reptile" || animal == "horse" || animal == "barnyard" || animal == "smallfurry" {
            
            if breedSearchContainerView.isHidden == true {
                guard let animal = animal else { return }
                BreedAPI.shared.fetchBreedsFor(animalType: animal, completion: { (success) in
                    if !success {
                        // presetn alert here
                        return
                    }
                    self.breedSearchViewController?.breeds = BreedAPI.shared.breeds
                })
                
                breedSearchContainerView.isHidden = false
                return
            }
            if breedSearchContainerView.isHidden == false {
                breedSearchContainerView.isHidden = true
                return
            }
        } else {
            breedSearchContainerView.isHidden = true
            presentAlertWith(title: "No Animal Type Selected", message: "Choose an animal to search for a certain breed, or leave blank to look for all breeds!", color: warningColor)
        }
    }
    
    @IBAction func resetBreedButtonTapped(_ sender: Any) {
        
        self.breed = nil
        self.selectBreedLabel.text = "Select Breed"
        self.breedSearchContainerView.isHidden = true 
        
    }
    
    // FIXME- move to a segue and create a corresponding generic segue
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        if let zipTextField = zipCodeTextField.text {
            if let zip = Int(zipTextField) {
                if isValid(zip) {
                    
                    self.performSegue(withIdentifier: "toPetTinderPage", sender: self)
                    
                } else {
                    presentAlertWith(title: "Invalid Zipcode", message: "A valid zipcode is required for us to locate adoptable pets near you!", color: errorColor)
                }
            } else {
                presentAlertWith(title: "Invalid Zipcode", message: "A valid zipcode is required for us to locate adoptable pets near you!", color: errorColor)
            }
        }
    }
    
    @IBAction func toSavedPetsButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toSavedPets", sender: self)
        
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(setBreed(notification:)), name: Notifications.BreedWasSetNotification, object: nil)
        self.breedSearchContainerView.isHidden = true 
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        
        self.setUpViews()
        
        // Get zipcodes from JSON to validate
        ZipCodesStore.readJson { (zipCodes) in
            self.zipArray = zipCodes
            print("DONE READING")
        }
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow(_ :)), name: Notifications.SearchBarEditingBegan, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide(_ :)), name: Notifications.SearchBarEditingEnded, object: nil)
    }
    
    @objc func setBreed(notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let breed = userInfo["breed"] as? String else { return }
        guard let status = userInfo["containerStatus"] as? Bool else { return }
        
        
        self.breed = breed
        self.selectBreedLabel.text = breed
        self.breedSearchContainerView.isHidden = status
        
    }
    
    // MARK: - Private Functions
    
    func isValid(_ zipCode: Int) -> Bool {
        return zipArray.contains(zipCode)
    }
    
    func setUpViews() {
        
        self.title = "Search"
        
        breedSearchContainerView.isHidden = true
        
        let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        
        let messages: [String] = ["Find your new best friend!",
                                  "Take home all of the pets!"]
        
        guard let messageFont = UIFont(name: "Hiragino Sans W3", size: 18.0) else { return }
        let rng = Int(arc4random_uniform(UInt32(messages.count)))
        let message = messages[rng]
        let messageToReturn: NSMutableAttributedString = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.foregroundColor : redColor, NSAttributedStringKey.font : messageFont])
        
        messageLabel.attributedText = messageToReturn
        selectBreedLabel.textColor = redColor
        sexSegmentedControl.tintColor = redColor
//        locationButton.imageView?.tintColor = redColor
        
        
        searhButton.layer.cornerRadius = 5.0
        
        // Create Borders for dropDown buttons
        
        animalTypeMasterButton.layer.borderWidth = 1.0
        animalTypeMasterButton.layer.borderColor = redColor.cgColor
        animalTypeMasterButton.layer.cornerRadius = 5.0
        
        animalSizeMasterButton.layer.borderWidth = 1.0
        animalSizeMasterButton.layer.borderColor = redColor.cgColor
        animalSizeMasterButton.layer.cornerRadius = 5.0
        
        animalAgeMasterButton.layer.borderWidth = 1.0
        animalAgeMasterButton.layer.borderColor = redColor.cgColor
        animalAgeMasterButton.layer.cornerRadius = 5.0
        
        // Create border for select breed button
        
        selectBreedButton.layer.borderWidth = 1.0
        selectBreedButton.layer.borderColor = redColor.cgColor
        selectBreedButton.layer.cornerRadius = 5.0
        
        breedResetButton.layer.borderWidth = 1.0
        breedResetButton.layer.borderColor = redColor.cgColor
        breedResetButton.layer.cornerRadius = 5.0
        
    }
    
    func presentAlertWith(title: String, message: String, color: UIColor) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = color
        alertContentView.layer.cornerRadius = 5.0
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(_ notification: NSNotification) {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 150
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 150
        }
        
    }
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "breedContainerSegue" {
            breedSearchViewController = segue.destination as? BreedSearchContainerViewController
        }
        
        if segue.identifier == "toPetTinderPage" {
            
            guard let destinationVC = segue.destination as? PetSwipeViewController else {
                return
            }
            guard let zip = self.zipCodeTextField.text else {
                return
            }
            destinationVC.zip = zip
            destinationVC.animal = self.animal
            destinationVC.size = self.size
            destinationVC.sex = self.sex
            destinationVC.age = self.age
            destinationVC.breed = self.breed

        }
    }
    // Mark: - users zipcode
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var userZipCode: String = ""
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        manager.startUpdatingLocation()
        
        geoCoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print("Error in reveseGeocode")
            }
            guard let placemarks = placemarks else { return }
            let placemark = placemarks as [CLPlacemark]
            if placemark.count > 0 {
                let placemark = placemarks[0]
                guard let userZip = placemark.postalCode else { return }
                
                self.userZipCode = userZip
                self.zipCodeTextField.text = self.userZipCode

                manager.stopUpdatingLocation()
            }
            
        }
        
    }
    
}





