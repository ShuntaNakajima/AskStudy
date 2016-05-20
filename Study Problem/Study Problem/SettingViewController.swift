//
//  SettingViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase



class SettingViewController: UIViewController {
    
    //var Database = Firebase(url: "https://studyproblemfirebase.firebaseio.com/")
    
    var Database = FIRDatabaseReference.init()
    let user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openlefts(){
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func logoutbutton(){
        try! FIRAuth.auth()!.signOut()
        let viewController:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewControllers")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}
