//
//  CustomizableSearchViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class CustomizableSearchViewController: UIViewController, UIPickerViewDelegate {
    
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
        
        animalTypePicker.delegate = self
        animalSizePicker.delegate = self
        animalAgePicker.delegate = self
        
        animalTypeTextField.inputView = animalTypePicker
        animalSizeTextField.inputView = animalSizePicker
        animalAgeTextField.inputView = animalAgePicker
    }
    
    // MARK: - UIPickerView Delegate
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == animalTypePicker {
            return animal[component]
        }
        if pickerView == animalSizePicker {
            return size[component]
        }
        if pickerView == animalAgePicker {
            return age[component]
        }
        return ""
    }
    
   
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
 
    

}
