//
//  ThemeColorViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/31.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit


class ThemeColorViewController: UIViewController {
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    @IBOutlet var yellowButton : ThemeButton!
    @IBOutlet var lightBlueButton : ThemeButton!
    @IBOutlet var blueButton : ThemeButton!
    @IBOutlet var redButton : ThemeButton!
    @IBOutlet var greenButton : ThemeButton!
    @IBOutlet var purpleButton : ThemeButton!
    @IBOutlet var orangeButton : ThemeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yellowButton.backgroundColor = UIColor.themeYellow()
        lightBlueButton.backgroundColor = UIColor.themeLightBlue()
        blueButton.backgroundColor = UIColor.themeBlue()
        purpleButton.backgroundColor = UIColor.themePurple()
        redButton.backgroundColor = UIColor.themeRed()
        greenButton.backgroundColor = UIColor.themeGreen()
        orangeButton.backgroundColor = UIColor.themeOrange()
    }
    
    @IBAction func colorYellow(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeYellow()
        UITabBar.appearance().tintColor = UIColor.themeYellow()
        UINavigationBar.appearance().barTintColor = UIColor.themeYellow()
        userDefaults.set("yellow", forKey: "id")
    }
    
    @IBAction func colorLightBlue(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeLightBlue()
        UINavigationBar.appearance().barTintColor = UIColor.themeLightBlue()
        UITabBar.appearance().tintColor = UIColor.themeLightBlue()
        userDefaults.set("lightblue", forKey: "id")
    }
    
    @IBAction func colorBlue(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeBlue()
        UINavigationBar.appearance().barTintColor = UIColor.themeBlue()
        UITabBar.appearance().tintColor = UIColor.themeBlue()
        userDefaults.set("blue", forKey: "id")
    }
    
    @IBAction func colorRed(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeRed()
        UINavigationBar.appearance().barTintColor = UIColor.themeRed()
        UITabBar.appearance().tintColor = UIColor.themeRed()
        userDefaults.set("red", forKey: "id")
    }
    
    @IBAction func colorGreen(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeGreen()
        UITabBar.appearance().tintColor = UIColor.themeGreen()
        UINavigationBar.appearance().barTintColor = UIColor.themeGreen()
        userDefaults.set("green", forKey: "id")
    }
    
    @IBAction func colorOrange(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themeOrange()
        UITabBar.appearance().tintColor = UIColor.themeOrange()
        UINavigationBar.appearance().barTintColor = UIColor.themeOrange()
        userDefaults.set("orange", forKey: "id")
    }
    
    @IBAction func colorPurple(){
        
        self.navigationController?.navigationBar.barTintColor = UIColor.themePurple()
        UITabBar.appearance().tintColor = UIColor.themePurple()
        UINavigationBar.appearance().barTintColor = UIColor.themePurple()
        userDefaults.set("purple", forKey: "id")
    }
}
