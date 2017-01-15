//
//  ResetPasswordViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController ,CAAnimationDelegate{
        @IBOutlet weak var emailField: UITextField!
    var fromColors = [Any?]()
    var gradient : CAGradientLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradient = CAGradientLayer()
        self.gradient?.frame = self.view.bounds
        self.gradient?.colors = [ UIColor.ThemePurple().cgColor, UIColor.ThemeRed().cgColor]
        self.view.layer.insertSublayer(self.gradient!, at: 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        animateLayer()
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        animateLayer()
    }
    func animateLayer(){
        let toColors: [AnyObject] = [ UIColor.ThemeBlue().cgColor, UIColor.ThemeLightBlue().cgColor]
        let fromColors: [AnyObject] = [ UIColor.ThemePurple().cgColor, UIColor.ThemeRed().cgColor]
        self.gradient?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 18.00
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.autoreverses = true
        animation.repeatCount = 10
        animation.delegate = self
        self.gradient?.add(animation, forKey:"animateGradient")
    }
    @IBAction func sendreset(){
        let email = emailField.text
        FIRAuth.auth()?.sendPasswordReset(withEmail: email!) { error in
            if error != nil {
                // There was an error processing the request
            } else {
                // Password reset sent successfully
                let alert = UIAlertController(title: "Done!", message: "Send your password reset", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func backbuttonPushed(segue:UIStoryboardSegue){
        
    }
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
}
