//
//  itemTableViewCell.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/18.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class itemTableViewCell: UITableViewCell {
    @IBOutlet var ReplycountLabel:UILabel!
    @IBOutlet var IwantknowButton:UIButton!
    @IBOutlet var StateLabel:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
