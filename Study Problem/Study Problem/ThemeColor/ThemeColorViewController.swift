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
        YellowButton.backgroundColor = UIColor.ThemeYellow()
        LightBlueButton.backgroundColor = UIColor.ThemeLightBlue()
        BlueButton.backgroundColor = UIColor.ThemeBlue()
        PurpleButton.backgroundColor = UIColor.ThemePurple()
        RedButton.backgroundColor = UIColor.ThemeRed()
        GreenButton.backgroundColor = UIColor.ThemeGreen()
        OrangeButton.backgroundColor = UIColor.ThemeOrange()
    }
    @IBAction func colorYellow(){
        self.navigationController?.navigationBar.barTintColor = UIColor.ThemeYellow()
        UITabBar.appearance().tintColor = UIColor.ThemeYellow()
        UINavigationBar.appearance().barTintColor = UIColor.ThemeYellow()
        color.set("yellow", forKey: "id")
    }
    @IBAction func colorLightBlue(){
        self.navigationController?.navigationBar.barTintColor = UIColor.ThemeLightBlue()
        UINavigationBar.appearance().barTintColor = UIColor.ThemeLightBlue()
        UITabBar.appearance().tintColor = UIColor.ThemeLightBlue()
        color.set("lightblue", forKey: "id")
    }
    @IBAction func colorBlue(){
        self.navigationController?.navigationBar.barTintColor = UIColor.ThemeBlue()
        UINavigationBar.appearance().barTintColor = UIColor.ThemeBlue()
        UITabBar.appearance().tintColor = UIColor.ThemeBlue()
        color.set("blue", forKey: "id")
    }
    @IBAction func colorRed(){
        self.navigationController?.navigationBar.barTintColor = UIColor.ThemeRed()
        UINavigationBar.appearance().barTintColor = UIColor.ThemeRed()
        UITabBar.appearance().tintColor = UIColor.ThemeRed()
        color.set("red", forKey: "id")
    }
    @IBAction func colorGreen(){
        self.navigationController?.navigationBar.barTintColor = UIColor.ThemeGreen()
        UITabBar.appearance().tintColor = UIColor.ThemeGreen()
        UINavigationBar.appearance().barTintColor = UIColor.ThemeGreen()
        color.set("green", forKey: "id")
    }
    @IBAction func colorOrange(){
        self.navigationController?.navigationBar.barTintColor = UIColor.ThemeOrange()
        UITabBar.appearance().tintColor = UIColor.ThemeOrange()
        UINavigationBar.appearance().barTintColor = UIColor.ThemeOrange()
        color.set("orange", forKey: "id")
    }
    @IBAction func colorPurple(){
        self.navigationController?.navigationBar.barTintColor = UIColor.ThemePurple()
        UITabBar.appearance().tintColor = UIColor.ThemePurple()
        UINavigationBar.appearance().barTintColor = UIColor.ThemePurple()
        color.set("purple", forKey: "id")
    }
}
