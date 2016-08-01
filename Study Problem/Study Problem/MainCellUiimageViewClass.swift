//
//  MainCellUiimageViewClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/06/26.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
class MainCellUiimageViewClass: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: "showUser:", forControlEvents: .TouchUpInside)
        self.updateLayout()
    }
    override func awakeFromNib() {
        self.addTarget(self, action: "showUser:", forControlEvents: .TouchUpInside)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateLayout()
    }
    func updateLayout(){
        self.layer.cornerRadius=25
        self.layer.masksToBounds=true
        self.setTitle("", forState: UIControlState.Normal)
        self.setBackgroundImage(UIImage(named: "noimage.gif")!, forState: .Normal)
    }
 func showUser(sender:UIButton){
        print("test")
    }
}
