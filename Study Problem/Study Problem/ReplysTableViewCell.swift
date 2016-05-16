//
//  ReplysTableViewCell.swift
//  
//
//  Created by nakajimashunta on 2016/05/16.
//
//

import UIKit

class ReplysTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView : UIImageView!
    
    @IBOutlet var usernameLabel:UILabel!
    
    @IBOutlet var postLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
