//
//  StarDtialViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/09/25.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class StarDtialViewController: UIViewController {
    @IBOutlet var closebutton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        closebutton.layer.cornerRadius=30
        closebutton.layer.masksToBounds=true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UITabBar.appearance().tintColor
        self.closebutton.setTitleColor(UITabBar.appearance().tintColor, for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func close(){
        self.dismiss(animated: true, completion: nil)
    }

}
