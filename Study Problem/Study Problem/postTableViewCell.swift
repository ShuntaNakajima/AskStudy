//
//  postTableViewCell.swift
//  
//
//  Created by nakajimashunta on 2016/05/15.
//
//

import UIKit

class postTableViewCell: UITableViewCell {
    
    @IBOutlet var textView : MianCellTextView!
    
    @IBOutlet var profileImage: MainCellUiimageViewClass!
    
    @IBOutlet var profileLabel: UILabel!
    
    @IBOutlet var replyscountLabel : UILabel!
    
    @IBOutlet var subjectLabel:UILabel!
    
    @IBOutlet var dateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
