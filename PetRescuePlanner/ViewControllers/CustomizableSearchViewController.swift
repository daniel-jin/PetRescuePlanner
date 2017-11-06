//
//  CustomizableSearchViewController.swift
//  PetRescuePlanner
//
//  Created by Daniel Rodosky on 11/6/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class CustomizableSearchViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var animalTypeTextField: UITextField!
    @IBOutlet weak var animalSizeTextField: UITextField!
    @IBOutlet weak var animalAgeTextField: UITextField!
    
    @IBOutlet var animalTypePicker: UIPickerView!
    @IBOutlet var animalSizePicker: UIPickerView!
    @IBOutlet var animalAgePicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    

}
