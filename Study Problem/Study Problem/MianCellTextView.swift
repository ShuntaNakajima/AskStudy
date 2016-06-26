//
//  MianCellTextView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/06/26.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class MianCellTextView: UILabel {
    override func drawRect(rect: CGRect) {
        self.updateLayout()
    }
    func updateLayout(){
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5
    }
}
