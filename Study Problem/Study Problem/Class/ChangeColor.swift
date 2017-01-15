//
//  ChangeColor.swift
//  Study Problem
//
//  Created by nakajimashunta on 2017/01/15.
//  Copyright © 2017年 ShuntaNakajima. All rights reserved.
//

import UIKit

class ChangeColor: NSObject {
    
    static func getColor() {
        
        let color = UserDefaults.standard
        let colorop : String? = color.object(forKey: "id") as! String?
        UITabBar.appearance().tintColor = UIColor.ThemeBlue()
        UINavigationBar.appearance().barTintColor = UIColor.ThemeBlue()
        if let color = colorop{
            switch color{
            case "yellow":
                UITabBar.appearance().tintColor = UIColor.ThemeYellow()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeYellow()
            case "lightblue":
                UITabBar.appearance().tintColor = UIColor.ThemeLightBlue()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeLightBlue()
            case "blue":
                UITabBar.appearance().tintColor = UIColor.ThemeBlue()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeBlue()
            case "red":
                UITabBar.appearance().tintColor = UIColor.ThemeRed()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeRed()
            case "green":
                UITabBar.appearance().tintColor = UIColor.ThemeGreen()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeGreen()
            case "orange":
                UITabBar.appearance().tintColor = UIColor.ThemeOrange()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeOrange()
            case "purple":
                UITabBar.appearance().tintColor = UIColor.ThemePurple()
                UINavigationBar.appearance().barTintColor = UIColor.ThemePurple()
            default:
                UITabBar.appearance().tintColor = UIColor.ThemeBlue()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeBlue()
            }
        }
    }
    
}
