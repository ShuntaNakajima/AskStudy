//
//  ReplysTableViewCell.swift
//  
//
//  Created by nakajimashunta on 2016/05/16.
//
//

import UIKit

class ReplysTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView : MainCellButton!
    @IBOutlet var usernameLabel:UILabel!
    
    @IBOutlet var postLabel:UILabel!
    
    @IBOutlet var setBestAnser:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
