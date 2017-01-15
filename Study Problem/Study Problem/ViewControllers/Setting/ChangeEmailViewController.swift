//
//  ChangeEmailViewController.swift
//
//
//  Created by nakajimashunta on 2016/09/25.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class ChangeEmailViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var emailTextField:UITextField!
    
    var userDic=Dictionary<String, AnyObject>()
    var Database = FIRDatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database = FIRDatabase.database().reference()
        emailTextField.delegate = self
        Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).observe(.value, with: { snapshot in
            if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                postDictionary["key"] = key as AnyObject?
                self.userDic = postDictionary
                self.emailTextField.text = self.userDic["email"] as! String?
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func changeEmail(){
        SVProgressHUD.show()
        let user = FIRAuth.auth()?.currentUser
        user?.updateEmail(emailTextField.text!) { error in
            if let error = error {
                print(error)
                SVProgressHUD.dismiss()
            } else {
                self.Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("email").setValue(self.emailTextField.text!)
                SVProgressHUD.showSuccess(withStatus: "Update Successful!")
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline:delayTime, execute:{ SVProgressHUD.dismiss() })
            }
        }
    }}
