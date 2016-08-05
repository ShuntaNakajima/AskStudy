//
//  ViewpostViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/15.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewpostViewController: UIViewController,UITextViewDelegate {
    var Database = FIRDatabaseReference.init()
    var post : String!
    var newpost : FIRDatabase!
    var replys = [Dictionary<String, AnyObject>]()
    var postDic = Dictionary<String, AnyObject>()
    var toreply : String!
    var keyboradheight : CGFloat!
    var myTextView: UITextView!
    var toolbar:UIToolbar!
    @IBOutlet var tableView :UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Database = FIRDatabase.database().reference()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 45))
        let mainnib  = UINib(nibName: "PostMainTableViewCell", bundle:nil)
        self.tableView.registerNib(mainnib, forCellReuseIdentifier:"postMainCell")
        let itemnib = UINib(nibName: "itemTableViewCell", bundle: nil)
        self.tableView.registerNib(itemnib, forCellReuseIdentifier: "ItemCell")
        let replysnib  = UINib(nibName: "ReplysTableViewCell", bundle:nil)
        self.tableView.registerNib(replysnib, forCellReuseIdentifier:"ReplysCell")
        let myreplysnib  = UINib(nibName: "MyReplysTableViewCell", bundle:nil)
        self.tableView.registerNib(myreplysnib, forCellReuseIdentifier:"MyReplysCell")
        toolbar = UIToolbar(frame: CGRectMake(0, self.view.bounds.size.height - 45.0, self.view.bounds.size.width, 45.0))
        toolbar.barStyle = .BlackTranslucent
        toolbar.tintColor = UIColor.whiteColor()
        toolbar.backgroundColor = UIColor.blackColor()
        let button3: UIBarButtonItem = UIBarButtonItem(title: "send", style:.Plain, target: nil, action: #selector(tappedToolBarBtn))
        let buttonGap: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolbar.items = [buttonGap, buttonGap, button3]
        self.view.addSubview(toolbar)
        myTextView = UITextView(frame: CGRectMake(0,0 ,self.view.frame.width - 45, 45))
        myTextView.text = "Type comment"
        myTextView.layer.borderWidth = 0.5
        myTextView.font = UIFont.systemFontOfSize(25.5)
        myTextView.delegate = self
        myTextView.text = "Type here"
        myTextView.textColor = UIColor.lightGrayColor()
        toolbar.addSubview(self.myTextView)
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(ViewpostViewController.handleKeyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        Database.child("post/" + post).observeEventType(.Value, withBlock: { snapshot in
            if snapshot.children.allObjects is [FIRDataSnapshot] {
                if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    postDictionary["key"] = key
                    self.postDic = postDictionary
                    self.tableView.reloadData()
                }
            }
        })
        Database.child("post/" + post + "/replys").observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.replys = []
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key
                        self.replys.append(postDictionary)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let transform = CGAffineTransformMakeTranslation(0, -keyboardScreenEndFrame.size.height)
        self.keyboradheight = keyboardScreenEndFrame.size.height
        self.view.transform = transform
        tableView.frame = (frame: CGRect(x: 0, y: keyboardScreenEndFrame.size.height, width: self.view.frame.width, height: self.view.frame.height - keyboardScreenEndFrame.size.height - 45))
    }
    func textViewDidBeginEditing(textView: UITextView) {
        if myTextView.text == "Type here"{
            myTextView.text = ""
            myTextView.textColor = UIColor.blackColor()
        }
    }
    func tappedToolBarBtn(){
        myTextView.resignFirstResponder()
        let replyText = myTextView.text
        if replyText != "" && replyText != "Type here" {
            self.view.transform = CGAffineTransformIdentity
            toolbar.frame = (frame: CGRectMake(0, self.view.bounds.size.height - 45.0, self.view.bounds.size.width,
                45.0))
            myTextView.frame = (frame: CGRectMake(0,0 ,self.view.frame.width - 45, 45))
            myTextView.text = "Type here"
            myTextView.textColor = UIColor.lightGrayColor()
            tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 45))
            let postedUser : String!
            let newreply: Dictionary<String, AnyObject> = [
                "text": replyText!,
                "author": (FIRAuth.auth()?.currentUser?.uid)!
            ]
            let firebasenewreply = Database.child("post/" + post + "/replys").childByAutoId()
            firebasenewreply.setValue(newreply)
            var replaycount = postDic["reply"] as! Int
            replaycount = replaycount + 1
            let firebasenewreplyscount = Database.child("post/" + post + "/reply")
            firebasenewreplyscount.setValue(replaycount)
        }
    }
    func textViewDidChange(textView: UITextView){
        let textViewtext = myTextView.text!
        let maxHeight = 140.0
        let size:CGSize = myTextView.sizeThatFits(myTextView.frame.size)
        if(size.height.native <= maxHeight) {
            myTextView.frame.size.height = size.height
            toolbar.frame = (frame: CGRectMake(0, self.view.bounds.size.height - size.height, self.view.bounds.size.width, size.height))
            myTextView.frame = (frame: CGRectMake(0,0 ,self.view.frame.width - 45, size.height))
            tableView.frame = (frame: CGRect(x: 0, y: keyboradheight!, width: self.view.frame.width, height: self.view.frame.height - keyboradheight! - size.height))
        }
    }
    func showUserData(sender:UIButton){
        let row = sender.tag
        var segueUser = ""
        if row == 1{}else if row == 0{
           segueUser = postDic["author"] as! String
        }else{
        segueUser = replys[row - 2]["author"] as! String
        }
        let UDMC: UserDetailModalViewController = (self.presentedViewController as? UserDetailModalViewController)!
        UDMC.UserKey = segueUser
    }
}
