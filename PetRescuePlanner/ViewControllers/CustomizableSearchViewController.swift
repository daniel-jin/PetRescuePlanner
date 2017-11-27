//
//  CustomizableSearchViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class CustomizableSearchViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    // Picker view values
    
    let animals = ["", "Dog", "Cat", "Bird", "Reptile", "Horse", "Barnyard", "Smallfurry"]
    let sizes = ["", "Small", "Medium", "Large", "Extra-Large"]
    let ages = ["", "Baby", "Young", "Adult", "Senior"]
    
    // alert view colors
    
    let warningColor = UIColor.yellow
    let errorColor = UIColor.red
    let noticeColor = UIColor.white
    
    // MARK: - Outlets
    
    @IBOutlet weak var selectBreedLabel: UILabel!
    @IBOutlet weak var animalTypeTextField: UITextField!
    @IBOutlet weak var animalSizeTextField: UITextField!
    @IBOutlet weak var animalAgeTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    @IBOutlet var animalTypePicker: UIPickerView!
    @IBOutlet var animalSizePicker: UIPickerView!
    @IBOutlet var animalAgePicker: UIPickerView!
    
    @IBOutlet weak var selectBreedButton: UIButton!
    
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var breedSearchContainerView: UIView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    // MARK: - Actions
    
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
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == animalTypePicker {
            return animals.count
        }
        if pickerView == animalSizePicker {
            return sizes.count
        }
        if pickerView == animalAgePicker {
            return ages.count
        }
        return 0
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == animalTypePicker {
            return animals[row]
        }
        if pickerView == animalSizePicker {
            return sizes[row]
        }
        if pickerView == animalAgePicker {
            return ages[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == animalTypePicker {
            animalTypeTextField.text = animals[row]
            animal = animals[row].lowercased()
        }
        if pickerView == animalSizePicker {
            animalSizeTextField.text = sizes[row]
            switch sizes[row] {
            case "Small":
                size = "S"
            case "Medium":
                size = "M"
            case "Large":
                size = "L"
            case "Extra-Large":
                size = "XL"
            default:
                size = nil
            }
            
        }
        if pickerView == animalAgePicker {
            animalAgeTextField.text = ages[row]
            age = ages[row]
        }
    }
    
    // MARK: - Private Functions
    
    func isValid(_ zipCode: Int) -> Bool {
        return zipArray.contains(zipCode)
    }
    
    func setUpViews() {
        
        self.title = "Search"
        
        animalTypePicker.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 0.5)
        animalSizePicker.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 0.5)
        animalAgePicker.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 0.5)
        
        
        animalTypePicker.delegate = self
        animalSizePicker.delegate = self
        animalAgePicker.delegate = self
        
        animalTypePicker.dataSource = self
        animalSizePicker.dataSource = self
        animalAgePicker.dataSource = self
        
        animalTypeTextField.inputView = animalTypePicker
        animalSizeTextField.inputView = animalSizePicker
        animalAgeTextField.inputView = animalAgePicker
        
        breedSearchContainerView.isHidden = true
        
        let redColor = UIColor(red: 222.0/255.0, green: 21.0/255.0, blue: 93.0/255.0, alpha: 1)
        
        let messages: [String] = ["Find your new best friend!",
                                  "Take home all of the pets!"]
        
        guard let loveStory = UIFont(name: "Love Story Rough", size: 30.0) else { return }
        
        let rng = Int(arc4random_uniform(UInt32(messages.count)))
        let message = messages[rng]
        let messageToReturn: NSMutableAttributedString = NSMutableAttributedString(string: message, attributes: [NSAttributedStringKey.foregroundColor : redColor, NSAttributedStringKey.font : loveStory])
        
        messageLabel.attributedText = messageToReturn
        selectBreedLabel.textColor = redColor
        sexSegmentedControl.tintColor = redColor
        
    }
    
    func presentAlertWith(title: String, message: String, color: UIColor) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = color
        
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
            
            guard let zip = zipCodeTextField.text else {
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
 
    

}
