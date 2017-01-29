//
//  LoginViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController,CAAnimationDelegate {
    let database = FIRDatabase.database().reference()
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
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
    @IBAction func tryLogin(sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
        if email != "" && password != "" {
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
                if user != nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.loginErrorAlert(title: "Oops!", message: "Check your username and password.")
                }
            }
        } else {
            loginErrorAlert(title: "Oops!", message: "Don't forget to enter your email and password.")
        }
        
    }
    
    func loginErrorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
