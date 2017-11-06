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
    
    let animal = ["Dog", "Cat", "Bird", "Reptile", "Horse", "Barnyard", "Smallfurry"]
    let size = ["Small", "Medium", "large", "Extra-Large"]
    let age = ["Baby", "Young", "Adult", "Senior"]
    
    // MARK: - Outlets
    
    @IBOutlet weak var animalTypeTextField: UITextField!
    @IBOutlet weak var animalSizeTextField: UITextField!
    @IBOutlet weak var animalAgeTextField: UITextField!
    
    @IBOutlet var animalTypePicker: UIPickerView!
    @IBOutlet var animalSizePicker: UIPickerView!
    @IBOutlet var animalAgePicker: UIPickerView!
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpPickerViews()
        
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
    
    // MARK: - UIPickerView Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == animalTypePicker {
            return animal.count
        }
        if pickerView == animalSizePicker {
            return size.count
        }
        if pickerView == animalAgePicker {
            return age.count
        }
        return 0
    }
    
    // MARK: - UIPickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == animalTypePicker {
            return animal[row]
        }
        if pickerView == animalSizePicker {
            return size[row]
        }
        if pickerView == animalAgePicker {
            return age[row]
        }
        return ""
    }
    
    
    // MARK: - Private Functions
    
    func setUpPickerViews() {
        
        animalTypePicker.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 0.5)
        animalSizePicker.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 0.5)
        animalAgePicker.backgroundColor = UIColor(red: 71.0 / 255.0, green: 70.0 / 255.0, blue: 110.0 / 255.0, alpha: 0.5)
        
    }
    
   
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
 
    

}
