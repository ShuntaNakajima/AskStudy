//
//  ChatTableViewCell.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/17.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImage:MainCellButton!
    @IBOutlet var profileLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.imageView!.layer.borderWidth = 10
        profileImage.imageView!.layer.cornerRadius = 27.5
        profileImage.layer.cornerRadius=27.5
        profileImage.layer.masksToBounds=true
        profileImage.setTitle("", for: UIControlState.normal)
        profileImage.setBackgroundImage(UIImage(named: "noimage.gif")!, for: .normal)
    }
}
