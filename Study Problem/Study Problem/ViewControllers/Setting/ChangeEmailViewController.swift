//
//  ChangeEmailViewController.swift
//
//
//  Created by nakajimashunta on 2016/09/25.
//
//

import UIKit
import Firebase
import SVProgressHUD

class ChangeEmailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    
    var userDic: [String: AnyObject] = [:]
    let databaseReference: FIRDatabaseReference = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        databaseReference.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).observe(.value, with: { snapshot in
            
            if var postDictionary: [String: AnyObject] = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                postDictionary["key"] = key as AnyObject?
                self.userDic = postDictionary
                self.emailTextField.text = self.userDic["email"] as? String
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
                
                guard let text: String = emailTextField.text else {
                    
                    return
                }
                databaseReference.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("email").setValue(text)
                SVProgressHUD.showSuccess(withStatus: "Update Successful!")
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline:delayTime, execute:{ SVProgressHUD.dismiss() })
            }
        }
    }}
