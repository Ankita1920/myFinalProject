//
//  SaveDataTableViewCell.swift
//  MyFinalProject
//
//  Created by Ankita Mondal on 22/02/24.
//

import UIKit

class SaveDataTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var Status: UILabel!
    
    
    @IBOutlet weak var Gender: UILabel!
    
    @IBOutlet weak var Species: UILabel!
    
    @IBOutlet weak var `Type`: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
