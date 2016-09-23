//
//  AnimationView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/09/20.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
extension UIView{
    class func animation(_ view:UIView) -> CABasicAnimation{
        view.layer.anchorPoint = CGPoint(x:5,y:5)
        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 2
        animation.repeatCount = HUGE
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        animation.fromValue = UIColor.ThemeBlue()
        animation.toValue = UIColor.ThemeRed()
        return animation
    }
}
