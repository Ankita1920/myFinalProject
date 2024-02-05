//
//  DetailsViewController.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 31/01/24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    
    @IBOutlet weak var DetailImage: UIImageView!
    
    
    @IBOutlet weak var statusValue: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var GenderName: UILabel!
    
    @IBOutlet weak var Typevalue: UILabel!
    
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var species: UILabel!
    
    @IBOutlet weak var speciesValue: UILabel!
    
    
    
    @IBOutlet weak var genderValue: UILabel!
    
    var characterDetails : Character?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let characterDetails = characterDetails {
            // Example: Populate your UI elements
            statusValue.text = characterDetails.status
            GenderName.text = characterDetails.gender
            Typevalue.text = "None"
            species.text = characterDetails.species
          
            
            
            if let imageUrl = URL(string: characterDetails.image) {
                            // Download and set the image using AlamofireImage
                            DetailImage.af.setImage(withURL: imageUrl)
                        }
            
        }
        
    }
    
    
    
}
