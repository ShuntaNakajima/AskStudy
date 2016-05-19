//
//  CreateAccountViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var Database = Firebase(url: "https://studyproblemfirebase.firebaseio.com/")
    var DataUser = Firebase(url: "https://studyproblemfirebase.firebaseio.com/user/")
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var gradeField: UITextField!
    var pickOption = ["Grade1", "Grade2", "Grade3", "Grade4", "Grade5","Grade6", "Grade7", "Grade8", "Grade9", "Grade10", "Grade11", "Grade12"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        gradeField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor.whiteColor()
        
        
        let defaultButton = UIBarButtonItem(title: "Grade1", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor.whiteColor()
        
        label.text = "Pick your grade"
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        gradeField.inputAccessoryView = toolBar


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func createAccount(sender: AnyObject) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let grade = gradeField.text
        
        if username != "" && email != "" && password != "" && gradeField != ""{
            
            // Set Email and Password for the New User.
            
            self.Database.createUser(email, password: password, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    
                    // There was a problem.
                    
                    if let errorCode = FAuthenticationError(rawValue: error.code) {
                        switch (errorCode) {
                        case .UserDoesNotExist:
                            self.signupErrorAlert("Oops!", message: "Handle invalid user. Try again.")
                        case .InvalidEmail:
                           self.signupErrorAlert("Oops!", message: "Handle invalid email. Try again.")
                        case .InvalidPassword:
                            self.signupErrorAlert("Oops!", message: "Handle invalid password. Try again.")
                        default:
                           self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
                        }
                    }
                    
                } else {
                    
                    // Create and Login the New User with authUser
                    self.Database.authUser(email, password: password, withCompletionBlock: {
                        err, authData in
                        
                        let user = ["provider": authData.provider!, "email": email!, "username": username!, "grade": grade! ,"follow": 0,"follower":0,"rank":5.0]
                        
                        // Seal the deal in DataService.swift.
                        self.DataUser.childByAppendingPath(authData.uid).setValue(user)
                        let mainViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                        let leftViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
                        let rightViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
                        
                        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                        let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
                        self.presentViewController(slideMenuController, animated: true, completion: nil)

                    })
                    
                    // Store the uid for future access - handy!
                    //NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    
                                     //  self.performSegueWithIdentifier("NewUserLoggedIn", sender: nil)
                }
            })
            
        }else{
            
            self.signupErrorAlert("Oops!", message: "Don't forget to enter your email, password, and a username.")
        
        
        }
    }
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

        func donePressed(sender: UIBarButtonItem) {
            
            gradeField.resignFirstResponder()
            
        }
        
        func tappedToolBarBtn(sender: UIBarButtonItem) {
            
            gradeField.text = "Grade1"
            
            gradeField.resignFirstResponder()
        }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gradeField.text = pickOption[row]
    }


}
