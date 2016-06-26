//
//  MainCellUiimageViewClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/06/26.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
class MainCellUiimageViewClass: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateLayout()
    }
 
    func updateLayout(){
        self.layer.cornerRadius=25
        self.clipsToBounds=true
        self.image = UIImage(named: "noimage.gif")!
    }

}
