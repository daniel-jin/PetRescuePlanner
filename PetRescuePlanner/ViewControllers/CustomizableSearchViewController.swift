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
    
    var animal: String? = nil
    var size: String? = nil
    var age: String? = nil
    var sex: String? = nil
    
    let animals = ["", "Dog", "Cat", "Bird", "Reptile", "Horse", "Barnyard", "Smallfurry"]
    let sizes = ["", "Small", "Medium", "large", "Extra-Large"]
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
    
    // MARK: - Actions
    
    @IBAction func userTappedView(_ sender: UITapGestureRecognizer) {
        
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
            size = sizes[row].lowercased()
        }
        if pickerView == animalAgePicker {
            animalAgeTextField.text = ages[row]
            age = ages[row].lowercased()
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
        
    }
    
   
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
 
    

}
