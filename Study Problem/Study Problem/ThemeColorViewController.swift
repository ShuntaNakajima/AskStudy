//
//  ThemeColorViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/31.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit


class ThemeColorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func colorYellow(){
        UITabBar.appearance().tintColor = UIColor.ThemeYellow()
    }
    @IBAction func colorLightBlue(){
        UITabBar.appearance().tintColor = UIColor.ThemeLightBlue()
    }
    @IBAction func colorBlue(){
        UITabBar.appearance().tintColor = UIColor.ThemeBlue()
    }
    @IBAction func colorRed(){
        UITabBar.appearance().tintColor = UIColor.ThemeRed()
    }
    @IBAction func colorGreen(){
          UITabBar.appearance().tintColor = UIColor.ThemeGreen()
    }
    @IBAction func colorOrange(){
       UITabBar.appearance().tintColor = UIColor.ThemeOrange()
    }
    @IBAction func colorPurple(){
         UITabBar.appearance().tintColor = UIColor.ThemePurple()
    }
}
