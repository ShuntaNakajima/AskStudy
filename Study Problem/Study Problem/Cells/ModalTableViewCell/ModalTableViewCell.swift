//
//  ModalTableViewCell.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/10.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class ModalTableViewCell: UITableViewCell {

    @IBOutlet var textView: MainCellLabel!
    
    @IBOutlet var profileLabel: UILabel!
    
    @IBOutlet var replyscountLabel : UILabel!
    
    @IBOutlet var subjectLabel:UILabel!
    
    @IBOutlet var dateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
