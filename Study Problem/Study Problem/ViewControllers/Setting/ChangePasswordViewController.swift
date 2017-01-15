//
//  ChangePasswordViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/31.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChangePasswordViewController: UIViewController {
    @IBOutlet var oldPassword:UITextField!
    @IBOutlet var newPassword:UITextField!
    @IBOutlet var newPasswordAgain:UITextField!
    var userDic = Dictionary<String, AnyObject>()
    var Database = FIRDatabaseReference.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        Database = FIRDatabase.database().reference()
        Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).observe(.value, with: { snapshot in
            if var userDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                userDictionary["key"] = key as AnyObject?
                self.userDic = userDictionary
            }
        })
    }
    @IBAction func done(){
        SVProgressHUD.show()
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: userDic["email"] as! String, password: oldPassword.text!)
        FIRAuth.auth()?.currentUser?.reauthenticate(with: credential, completion: { (error) in
            if error != nil{
                let alertController = UIAlertController(title: "Please check your old password", message: "", preferredStyle: .alert)
                let otherAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(otherAction)
                self.present(alertController, animated: true, completion: nil)
                SVProgressHUD.dismiss()
            }else{
                if self.newPassword.text! == self.newPasswordAgain.text! && self.newPassword.text! != ""{
                    let user = FIRAuth.auth()?.currentUser
                    user?.updatePassword(self.newPassword.text!) { error in
                        if let error = error {
                            print(error)
                            let alertController = UIAlertController(title: "The password must be 6 characters long or more.", message: "", preferredStyle: .alert)
                            let otherAction = UIAlertAction(title: "OK", style: .default)
                            alertController.addAction(otherAction)
                            self.present(alertController, animated: true, completion: nil)
                            SVProgressHUD.dismiss()
                        } else {
                            SVProgressHUD.showSuccess(withStatus: "Update Successful!")
                            let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                            DispatchQueue.main.asyncAfter(deadline:delayTime, execute:{ SVProgressHUD.dismiss() })
                        }
                    }
                }else{
                    let alertController = UIAlertController(title: "New password dosen't match. please check it", message: "", preferredStyle: .alert)
                    let otherAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(otherAction)
                    self.present(alertController, animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                }
            }
        })
    }
}
