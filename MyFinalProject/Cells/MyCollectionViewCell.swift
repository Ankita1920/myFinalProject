//
//  MyCollectionViewCell.swift
//  MyFinalProject
//
//  Created by Ankita Mondal on 22/02/24.
//

import UIKit

class myCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var collectionImage: UIImageView!
    
    
    @IBOutlet weak var characterName2: UILabel!
    
    
    @IBOutlet weak var characterStatus: UILabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           setupCell()
       }

       func setupCell() {
           // Set corner radius for rounded corners
           contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

           // Other cell setup code
       }
   }

//


