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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let pet = pet else { return }
        PetController.shared.fetchImagesFor(pet: pet) {
            self.setUpUI()
            self.tableView.reloadData()
        }
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
