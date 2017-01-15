//
//  ChangeDisplayNameViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/09/25.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChangeDisplayNameViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var usernameTextField:UITextField!
    
    var userDic=Dictionary<String, AnyObject>()
    var Database = FIRDatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database = FIRDatabase.database().reference()
        usernameTextField.delegate = self
        Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).observe(.value, with: { snapshot in
            if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                postDictionary["key"] = key as AnyObject?
                self.userDic = postDictionary
                self.usernameTextField.text = self.userDic["username"] as! String?
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func changeName(){
        SVProgressHUD.show()
        self.Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("username").setValue(self.usernameTextField?.text!)
        SVProgressHUD.showSuccess(withStatus: "Update Successful!")
        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline:delayTime, execute:{ SVProgressHUD.dismiss() })
    }
}
