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
    
    var animal: String? = nil
    var size: String? = nil
    var age: String? = nil
    var sex: String? = nil
    var breed: String? = nil
    
    let animals = ["", "Dog", "Cat", "Bird", "Reptile", "Horse", "Barnyard", "Smallfurry"]
    let sizes = ["", "Small", "Medium", "Large", "Extra-Large"]
    let ages = ["", "Baby", "Young", "Adult", "Senior"]
    
    // MARK: - Outlets
    
    @IBOutlet weak var animalTypeTextField: UITextField!
    @IBOutlet weak var animalSizeTextField: UITextField!
    @IBOutlet weak var animalAgeTextField: UITextField!
    @IBOutlet weak var zipCodeTextField: UITextField!
    
    @IBOutlet var animalTypePicker: UIPickerView!
    @IBOutlet var animalSizePicker: UIPickerView!
    @IBOutlet var animalAgePicker: UIPickerView!
    
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var breedSearchContainerView: UIView!
    
    // MARK: - Actions
    
    @IBAction func userTappedView(_ sender: UITapGestureRecognizer) {
        breedSearchContainerView.isHidden = true 
        self.view.endEditing(true)
    }
    
    @IBAction func sexSegmentedControlChanged(_ sender: Any) {
        if sexSegmentedControl.selectedSegmentIndex == 0 {
            sex = nil
        }
        if sexSegmentedControl.selectedSegmentIndex == 1 {
            sex = "male"
        }
        if sexSegmentedControl.selectedSegmentIndex == 2 {
            sex = "female"
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
            presentAlertWith(title: "No Animal Type Selected", message: "Choose an animal to search for a certain breed, or leave blank to look for all breeds!")
        }
    }
    
    // FIXME- move to a segue and create a corresponding generic segue
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toPetTinderPage", sender: self)
        
    }
    
    
    
    
    
    @IBAction func testOutputsButtonTapped(_ sender: Any) {
        
        if let animal = animal {
            print("The Type of animal is \(animal),")
        }
        if let size = size {
            print("and it is \(size) sized.")
        }
        if let age = age {
            print("The animal is \(age).")
        }
        if let sex = sex {
            print("It is a \(sex)")
        }
        if let breed = breed {
            print("the breed of this animal is \(breed)")
        }
        
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpViews()
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
            guard let temp = sizes[row].uppercased().characters.first else { return }
            size = "\(temp)"
        }
        if pickerView == animalAgePicker {
            animalAgeTextField.text = ages[row]
            let age = ages[row]
        }
        
    }
    
    // MARK: - Private Functions
    
    func setUpViews() {
        
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
        
    }
    
    func presentAlertWith(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.yellow
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
        
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
                presentAlertWith(title: "Zip Code Missing", message: "Please enter a zip code to base your search off of.")
                return
            }
            
            PetController.shared.fetchPetsFor(location: zip, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: nil, completion: { (success) in
                if !success {
                    NSLog("Error fetching adoptable pets from PetController")
                    return
                }
                destinationVC.pets = PetController.shared.pets
            })
        }
        
    }
 
    

}
