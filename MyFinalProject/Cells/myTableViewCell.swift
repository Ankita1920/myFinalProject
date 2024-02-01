//
//  myTableViewCell.swift
//  Ricky and Morty project
//
//  Created by Ankita Mondal on 30/01/24.
//

import UIKit

class myTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var CharacterImage: UIImageView!
    
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
