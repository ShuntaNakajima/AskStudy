//
//  PostMainTableViewCell.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/16.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class PostMainTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView : MainCellUiimageView!
    @IBOutlet var usernameLabel:UILabel!
    @IBOutlet var postLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
