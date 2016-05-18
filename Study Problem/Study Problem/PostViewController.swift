//
//  PostViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController ,UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet var textView:UITextView!
    
    var Database = Firebase(url: "https://studyproblemfirebase.firebaseio.com/")
    var Datapost = Firebase(url: "https://studyproblemfirebase.firebaseio.com/post/")
    
    weak var delegate: LeftMenuProtocol?
    
    @IBOutlet var subjectTextfield:UITextField!
    
    var currentUserId = ""
    var pickOption = ["Japanese", "Mathematics", "Science", "Sociology", "English","Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.currentUserId = self.Database.authData.uid
        
        print("Username: \(self.currentUserId)")
        
        
        textView.layer.borderColor = UIColor.blackColor().CGColor
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 20.0
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        subjectTextfield.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.BlackTranslucent
        
        toolBar.tintColor = UIColor.whiteColor()
        
        toolBar.backgroundColor = UIColor.whiteColor()
        
        
        let defaultButton = UIBarButtonItem(title: "Japanese", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clearColor()
        
        label.textColor = UIColor.whiteColor()
        
        label.text = "Pick Subject"
        
        label.textAlignment = NSTextAlignment.Center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        subjectTextfield.inputAccessoryView = toolBar
        
        let toolBarKeyBoard = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height/6, self.view.frame.size.width, 40.0))
        
        toolBarKeyBoard.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBarKeyBoard.barStyle = UIBarStyle.BlackTranslucent
        
        toolBarKeyBoard.tintColor = UIColor.whiteColor()
        
        toolBarKeyBoard.backgroundColor = UIColor.whiteColor()
        
        
        
        let doneButtonKey = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(donePressedKey))
        
        let flexSpaces = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        
        
        toolBarKeyBoard.setItems([flexSpaces,flexSpaces,flexSpaces,flexSpaces,doneButtonKey], animated: true)
        
        textView.inputAccessoryView = toolBarKeyBoard
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openlefts(){
        self.slideMenuController()?.openLeft()
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
        subjectTextfield.text = pickOption[row]
    }
    
    @IBAction func post(){
        let postText = textView.text
        
        if postText != "" {
            
            // Build the new Joke.
            // AnyObject is needed because of the votes of type Int.
            
            let newJoke: Dictionary<String, AnyObject> = [
                "text": postText!,
                "subject": subjectTextfield.text!,
                "reply":0,
                "author": currentUserId
            ]
            
            // Send it over to DataService to seal the deal.
            
            let firebaseNewJoke = Datapost.childByAutoId()
            
            // setValue() saves to Firebase.
            
            firebaseNewJoke.setValue(newJoke)
            let alert = UIAlertController(title: title, message: "Post Succeeded", preferredStyle: UIAlertControllerStyle.Alert)
            let action = UIAlertAction(title: "Ok", style: .Default, handler: {(action: UIAlertAction!) -> Void in
                // self.delegate?.changeViewController(LeftMenu.Main)
                let mainViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                let leftViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LeftViewController") as! LeftViewController
                let rightViewController = self.storyboard!.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
                
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
                self.presentViewController(slideMenuController, animated: true, completion: nil)
            })
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            
            
        }
    }
    
    
}
