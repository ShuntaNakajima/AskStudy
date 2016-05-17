//
//  postTableViewCell.swift
//  
//
//  Created by nakajimashunta on 2016/05/15.
//
//

import UIKit

class postTableViewCell: UITableViewCell {
    
    @IBOutlet var textView : UILabel!
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet var profileLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
