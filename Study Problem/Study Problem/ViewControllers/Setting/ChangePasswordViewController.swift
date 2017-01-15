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
    
    @IBOutlet var oldPasswordField: UITextField!
    @IBOutlet var newPasswordField: UITextField!
    @IBOutlet var newPasswordAgainField: UITextField!
    
    var userDic: [String: AnyObject] = [:]
    let databaseReference: FIRDatabaseReference = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseReference.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).observe(.value, with: { snapshot in
            
            if var userDictionary: [String: AnyObject] = snapshot.value as? Dictionary<String, AnyObject> {
                
                let key = snapshot.key
                userDictionary["key"] = key as AnyObject?
                self.userDic = userDictionary
            }
        })
    }
    
    @IBAction func done(){
        
        SVProgressHUD.show()
        guard let oldPassword: String = oldPasswordField.text else {
            
            return
        }
        let credential = FIREmailPasswordAuthProvider.credential(withEmail: userDic["email"] as! String, password: oldPassword)
        FIRAuth.auth()?.currentUser?.reauthenticate(with: credential, completion: { (error) in
            
            if error != nil{
                
                let alertController = UIAlertController(title: "Please check your old password", message: "", preferredStyle: .alert)
                let otherAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(otherAction)
                self.present(alertController, animated: true, completion: nil)
                SVProgressHUD.dismiss()
            }else{
                
                guard let newPassword: String = self.newPasswordField.text, let newPasswordAgain: String = self.newPasswordAgainField.text else {
                    
                    let alertController = UIAlertController(title: "New password dosen't match. please check it", message: "", preferredStyle: .alert)
                    let otherAction = UIAlertAction(title: "OK", style: .default)
                    alertController.addAction(otherAction)
                    self.present(alertController, animated: true, completion: nil)
                    SVProgressHUD.dismiss()
                    return
                }
                
                
                let user = FIRAuth.auth()?.currentUser
                user?.updatePassword(newPassword) { error in
                    
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
            }
        })
    }
}
