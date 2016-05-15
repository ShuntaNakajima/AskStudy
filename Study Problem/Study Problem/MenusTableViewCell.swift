//
//  MenusTableViewCell.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/14.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class MenusTableViewCell: UITableViewCell {
    @IBOutlet var MenuLablel : UILabel!
    @IBOutlet var MenuImage : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
