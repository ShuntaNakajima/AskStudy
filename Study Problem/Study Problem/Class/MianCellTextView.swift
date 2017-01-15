//
//  MianCellTextView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/06/26.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class MianCellTextView: UILabel {
    override func draw(_ rect: CGRect) {
        self.updateLayout()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.updateLayout()
    }
    func updateLayout(){
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5
    }
}
