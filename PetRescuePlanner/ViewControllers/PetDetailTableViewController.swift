//
//  PetDetailTableViewController.swift
//  PetRescuePlanner
//
//  Created by Michael Budd on 11/7/17.
//  Copyright © 2017 Daniel Rodosky. All rights reserved.
//

import UIKit

class PetDetailTableViewController: UITableViewController {
    
    // MARK: - Properties
    @IBOutlet weak var petImageScrollView: UIScrollView!
    @IBOutlet weak var petNameLabel: UILabel!
    var pet: Pet?
    var imageArray: [UIImage] = []
    let tempSearchUrl = URL(string: "http://api.petfinder.com/pet.find?key=73c75e3c063309430144f8ad39125ec7&location=84101&animal=dog&format=json")

    override func viewDidLoad() {
        super.viewDidLoad()
        PetController.shared.fetchPetsFor(location: "84101", animal: "dog", breed: nil, size: nil, sex: nil, age: nil, offset: nil) { (success) in
            self.pet = 
        }
        setUpUI()
        
    }
    
    func setUpUI() {
        
        guard let pet = pet else { return }
        
        petNameLabel.text = pet.name
        
        var images = [UIImageView]()
        var contentWidth: CGFloat = 0.0
        
        for image in imageArray {
            
            let newImage = image
            let imageView = UIImageView(image: newImage)
            images.append(imageView)
            
            var newX: CGFloat = 0.0
            newX = view.frame.midX + view.frame.size.width * CGFloat(images.count)
            contentWidth += newX
            
            petImageScrollView.addSubview(imageView)
            imageView.frame = CGRect(x: newX, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            
        }
        petImageScrollView.contentSize = CGSize(width: contentWidth, height: view.frame.size.height)
    }

}
