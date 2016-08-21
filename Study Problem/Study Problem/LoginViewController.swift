//
//  LoginViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    var Database = FIRDatabase.database().reference()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  let currentuser = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func tryLogin(sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
    
        if email != "" && password != "" {
                      // Login with the Firebase's authUser method
            
            FIRAuth.auth()?.signInWithEmail(email!, password: password!) { (user, error) in
                
                if user != nil {
                    
                    // Be sure the correct uid is stored.
                    
                    // NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    // Enter the app!
                    let mainViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                    self.presentViewController(mainViewController, animated: true, completion: nil)
                    //self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
                   
                } else {
                  
                    self.loginErrorAlert("Oops!", message: "Check your username and password.")
                }
            }
            
        } else {
            
            // There was a problem
            
            loginErrorAlert("Oops!", message: "Don't forget to enter your email and password.")
        }
        
    }
    
    func loginErrorAlert(title: String, message: String) {
        
        // Called upon login error to let the user know login didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}
