//
//  PostViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PostViewController: UIViewController ,UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate{

    
    @IBOutlet var textView:UITextView!
    
    var Database = FIRDatabaseReference.init()

    
    @IBOutlet var subjectTextfield:UITextField!
    @IBOutlet var closebutton:UIButton!
    @IBOutlet var postbutton:UIButton!
    
    var currentUserId = ""
    var pickOption = ["Japanese", "Mathematics", "Science", "Sociology", "English","Other"]
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UITabBar.appearance().tintColor
        self.closebutton.setTitleColor(UITabBar.appearance().tintColor, for: .normal)
        self.postbutton.setTitleColor(UITabBar.appearance().tintColor, for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Database = FIRDatabase.database().reference()
        
        self.currentUserId = (FIRAuth.auth()?.currentUser!.uid)!
        
        print("Username: \(self.currentUserId)")
        closebutton.layer.cornerRadius=30
        closebutton.layer.masksToBounds=true
        postbutton.layer.cornerRadius=25
        postbutton.layer.masksToBounds=true
        
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 20.0
        textView.text = "Type here"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        subjectTextfield.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x:0,y: self.view.frame.size.height/6,width: self.view.frame.size.width,height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.white
        
        
        let defaultButton = UIBarButtonItem(title: "Japanese", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "Pick Subject"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        subjectTextfield.inputAccessoryView = toolBar
        
        let toolBarKeyBoard = UIToolbar(frame: CGRect(x:0,y: self.view.frame.size.height/6,width: self.view.frame.size.width,height: 40.0))
        
        toolBarKeyBoard.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBarKeyBoard.barStyle = UIBarStyle.blackTranslucent
        
        toolBarKeyBoard.tintColor = UIColor.white
        
        toolBarKeyBoard.backgroundColor = UIColor.white
        
        
        
        let doneButtonKey = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressedKey))
        
        let flexSpaces = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        
        
        toolBarKeyBoard.setItems([flexSpaces,flexSpaces,flexSpaces,flexSpaces,doneButtonKey], animated: true)
        
        textView.inputAccessoryView = toolBarKeyBoard
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressedKey(sender: UIBarButtonItem){
        textView.resignFirstResponder()
    }
    
    func donePressed(sender: UIBarButtonItem) {
        
        subjectTextfield.resignFirstResponder()
        
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        
        subjectTextfield.text = "Japanese"
        
        subjectTextfield.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectTextfield.text = pickOption[row]
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Type here"{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    @IBAction func post(){
        let postText = textView.text
        
        if postText != "" && subjectTextfield.text != "" {
            
            // Build the new Joke.
            // AnyObject is needed because of the votes of type Int.
            let date_formatter: DateFormatter = DateFormatter()
            date_formatter.locale     = NSLocale(localeIdentifier: "ja") as Locale!
            date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let newJoke: Dictionary<String, AnyObject> = [
                "text": postText! as AnyObject,
                "subject": subjectTextfield.text! as AnyObject,
                "now" : true as AnyObject,
                "reply":0 as AnyObject,
                "author": currentUserId as AnyObject,
                "date": date_formatter.string(from: NSDate() as Date) as AnyObject
            ]
            
            // Send it over to DataService to seal the deal.
            
            let firebaseNewJoke = Database.child("post/").childByAutoId()
            
            // setValue() saves to Firebase.
            
            firebaseNewJoke.setValue(newJoke)
            let firebaseUserPost = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/posts/").childByAutoId()
            firebaseUserPost.setValue(firebaseNewJoke.key)
            let alert = UIAlertController(title: title, message: "Post Succeeded", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction!) -> Void in
                // self.delegate?.changeViewController(LeftMenu.Main)
                self.textView.text = "Type here"
                self.textView.textColor = UIColor.lightGray
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            
        }
    }
    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
}
