//
//  myTableViewCell.swift
//  MyFinalProject
//
//  Created by Ankita Mondal on 22/02/24.
//

import UIKit

class myTableViewCell: UITableViewCell {
    
    @IBOutlet weak var characterImage: UIImageView!
    
    
    @IBOutlet weak var CharacterName: UILabel!
    
    @IBOutlet weak var CharacterStatus: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
