//
//  CreateAccountViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CreateAccountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,CAAnimationDelegate {
    

    
    var Database = FIRDatabase.database().reference()

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var gradeField: UITextField!
    var pickOption = ["Grade1", "Grade2", "Grade3", "Grade4", "Grade5","Grade6", "Grade7", "Grade8", "Grade9", "Grade10", "Grade11", "Grade12","others"]
    var fromColors = [Any?]()
    var gradient : CAGradientLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        gradeField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x:0,y:self.view.frame.size.height/6,width:self.view.frame.size.width,height:40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.white
        
        
        let defaultButton = UIBarButtonItem(title: "Grade1", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "Pick your grade"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        gradeField.inputAccessoryView = toolBar


        // Do any additional setup after loading the view.
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
    @IBAction func createAccount(sender: AnyObject) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let grade = gradeField.text
        
        if username != "" && email != "" && password != "" && grade != ""{
            
            // Set Email and Password for the New User.
            
            FIRAuth.auth()?.createUser(withEmail: email!, password: password!) { (user, error) in
                if error != nil {
                    
                    // There was a problem.
            
                           self.signupErrorAlert(title: "Oops!", message: "Having some trouble creating your account. Try again.")
                    
                    
                } else {
                    var providerId = ""
                    for provi in (FIRAuth.auth()?.currentUser?.providerData)!{
                        providerId = provi.providerID
                    }
                    // Create and Login the New User with authUser
                    user?.sendEmailVerification(completion: { (error) in
                        if error == nil {
                            let user = ["email": email!, "username": username!, "grade": grade! ,"follows": 0,"followers":0] as [String : Any]
                            
                            // Seal the deal in DataService.swift.
                            self.Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).setValue(user)
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        }else {
                            self.signupErrorAlert(title: "Oops!", message: "Plaese check your e-mail address.")
                        }
                    })
                }
            }
            
        }else{
            
            self.signupErrorAlert(title: "Oops!", message: "Don't forget to enter your email, password, and a username.")
        
        
        }
    }
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

        func donePressed(sender: UIBarButtonItem) {
            
            gradeField.resignFirstResponder()
            
        }
        
        func tappedToolBarBtn(sender: UIBarButtonItem) {
            
            gradeField.text = "Grade1"
            
            gradeField.resignFirstResponder()
        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gradeField.text = pickOption[row]
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
}