//
//  ThemeColorViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/31.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit


class ThemeColorViewController: UIViewController {
let color = UserDefaults.standard
    @IBOutlet var YellowButton : ThemeButton!
    @IBOutlet var LightBlueButton : ThemeButton!
    @IBOutlet var BlueButton : ThemeButton!
    @IBOutlet var RedButton : ThemeButton!
    @IBOutlet var GreenButton : ThemeButton!
    @IBOutlet var PurpleButton : ThemeButton!
    @IBOutlet var OrangeButton : ThemeButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        YellowButton.backgroundColor = UIColor.themeYellow()
        LightBlueButton.backgroundColor = UIColor.themeLightBlue()
        BlueButton.backgroundColor = UIColor.themeBlue()
        PurpleButton.backgroundColor = UIColor.themePurple()
        RedButton.backgroundColor = UIColor.themeRed()
        GreenButton.backgroundColor = UIColor.themeGreen()
        OrangeButton.backgroundColor = UIColor.themeOrange()
    }
    @IBAction func colorYellow(){
        self.navigationController?.navigationBar.barTintColor = UIColor.themeYellow()
       UITabBar.appearance().tintColor = UIColor.themeYellow()
    UINavigationBar.appearance().barTintColor = UIColor.themeYellow()
        color.set("yellow", forKey: "id")
    }
    @IBAction func colorLightBlue(){
         self.navigationController?.navigationBar.barTintColor = UIColor.themeLightBlue()
     UINavigationBar.appearance().barTintColor = UIColor.themeLightBlue()
        UITabBar.appearance().tintColor = UIColor.themeLightBlue()
        color.set("lightblue", forKey: "id")
    }
    @IBAction func colorBlue(){
         self.navigationController?.navigationBar.barTintColor = UIColor.themeBlue()
      UINavigationBar.appearance().barTintColor = UIColor.themeBlue()
        UITabBar.appearance().tintColor = UIColor.themeBlue()
        color.set("blue", forKey: "id")
    }
    @IBAction func colorRed(){
         self.navigationController?.navigationBar.barTintColor = UIColor.themeRed()
         UINavigationBar.appearance().barTintColor = UIColor.themeRed()
        UITabBar.appearance().tintColor = UIColor.themeRed()
        color.set("red", forKey: "id")
    }
    @IBAction func colorGreen(){
         self.navigationController?.navigationBar.barTintColor = UIColor.themeGreen()
         UITabBar.appearance().tintColor = UIColor.themeGreen()
        UINavigationBar.appearance().barTintColor = UIColor.themeGreen()
        color.set("green", forKey: "id")
    }
    @IBAction func colorOrange(){
         self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange()
       UITabBar.appearance().tintColor = UIColor.themeOrange()
        UINavigationBar.appearance().barTintColor = UIColor.themeOrange()
        color.set("orange", forKey: "id")
    }
    @IBAction func colorPurple(){
         self.navigationController?.navigationBar.barTintColor = UIColor.themePurple()
         UITabBar.appearance().tintColor = UIColor.themePurple()
        UINavigationBar.appearance().barTintColor = UIColor.themePurple()
        color.set("purple", forKey: "id")
    }
}
