//
//  ReplysTableViewCell.swift
//  
//
//  Created by nakajimashunta on 2016/05/16.
//
//

import UIKit

class ReplysTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView : MainCellUiimageView!    
    @IBOutlet var usernameLabel:UILabel!
    @IBOutlet var postLabel:UILabel!
    @IBOutlet var setBestAnser:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
