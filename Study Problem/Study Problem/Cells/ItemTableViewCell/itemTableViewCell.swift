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
    @IBOutlet var DateLable:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
