//
//  StarDtialViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/09/25.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class StarDetailViewController: UIViewController {
    @IBOutlet var closebutton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        closebutton.layer.cornerRadius=30
        closebutton.layer.masksToBounds=true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UITabBar.appearance().tintColor
        self.closebutton.setTitleColor(UITabBar.appearance().tintColor, for: .normal)
    }
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
