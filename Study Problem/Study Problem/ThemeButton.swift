//
//  ThemeButton.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/09/19.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class ThemeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateLayout()
    }
    override func awakeFromNib() {
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateLayout()
    }
    func updateLayout(){
        self.layer.cornerRadius=50
        self.layer.masksToBounds=true
        self.setTitle("", for: UIControlState.normal)
    }
}
