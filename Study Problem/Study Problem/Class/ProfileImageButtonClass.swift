//
//  selfClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/04.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import UIKit
class ProfileImageButton: UIButton{
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
        self.layer.borderColor = UIColor.white.cgColor
        self.imageView!.layer.borderWidth = 10
        self.imageView!.layer.cornerRadius = 25
        self.layer.cornerRadius=25
        self.layer.masksToBounds=true
        self.setTitle("", for: UIControlState.normal)
        self.setBackgroundImage(UIImage(named: "noimage.gif")!, for: .normal)
    }
}
