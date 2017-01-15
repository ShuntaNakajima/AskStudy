//
//  colorNavigationViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/07/10.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class ColorNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor(red: 15/255, green: 250/255, blue: 150/255, alpha: 1)
    }
}
