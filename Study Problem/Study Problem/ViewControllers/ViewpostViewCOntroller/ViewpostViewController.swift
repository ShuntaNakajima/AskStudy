//
//  ViewpostViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/15.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase


class ViewpostViewController: UIViewController {
    
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var post : String!
    var newpost : FIRDatabase!
    var replies: [[String: AnyObject]] = []
    var postDic: [String: AnyObject] = [:]
    var toReply : String!
    var keyboardHeight : CGFloat!
    var textView: UITextView!
    var toolbar:UIToolbar!
    @IBOutlet var tableView :UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        toolbar = {
            let toolbar: UIToolbar = UIToolbar(frame: CGRect(x:0,y:self.view.bounds.size.height - 30.0,width:self.view.bounds.size.width, height:30.0))
            toolbar.barStyle = .blackTranslucent
            toolbar.tintColor = UIColor.white
            toolbar.backgroundColor = UIColor.black
            let button3: UIBarButtonItem = UIBarButtonItem(title: "send", style:.plain, target: nil, action: #selector(tappedToolBarBtn))
            let buttonGap: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            toolbar.items = [buttonGap, buttonGap, button3]
            return toolbar
        }()
        self.view.addSubview(toolbar)
        textView = {
            let textView: UITextView =  UITextView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 45, height: 30))
            textView.layer.borderWidth = 0.5
            textView.font = UIFont.systemFont(ofSize: 15)
            textView.delegate = self
            textView.text = "Type here"
            textView.textColor = UIColor.lightGray
            return textView
        }()
        toolbar.addSubview(textView)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.fetchBestAnswers()
        self.fetchReplies()
    }
    
    func fetchBestAnswers() {
        
        ref.child("post/" + post).observe(.value, with: { snapshot in
            
            if snapshot.children.allObjects is [FIRDataSnapshot] {
                
                if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    
                    let key = snapshot.key
                    postDictionary["key"] = key as AnyObject?
                    guard let BestAnswer = postDictionary["BestAnswer"] as? String else { return }
                    if BestAnswer == "" {
                        self.toolbar.isHidden = false
                        self.tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30))
                    }else {
                        self.toolbar.isHidden = true
                        self.tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    }
                    self.postDic = postDictionary
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func fetchReplies() {
        
        ref.child("post/" + post + "/replys").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.replies = []
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key as AnyObject?
                        self.replies.append(postDictionary)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func configureTableView() {
        
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        let mainNib  = UINib(nibName: "PostTableViewCell", bundle: nil)
        self.tableView.register(mainNib, forCellReuseIdentifier: "PostCell")
        let itemNib = UINib(nibName: "itemTableViewCell", bundle: nil)
        self.tableView.register(itemNib, forCellReuseIdentifier: "ItemCell")
        let repliesNib  = UINib(nibName: "ReplysTableViewCell", bundle:nil)
        self.tableView.register(repliesNib, forCellReuseIdentifier:"ReplysCell")
        let myreplysnib  = UINib(nibName: "MyReplysTableViewCell", bundle:nil)
        self.tableView.register(myreplysnib, forCellReuseIdentifier:"MyReplysCell")
    }
    
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let transform = CGAffineTransform(translationX: 0, y: -keyboardScreenEndFrame.size.height)
        self.keyboardHeight = keyboardScreenEndFrame.size.height
        self.view.transform = transform
        tableView.frame = (frame: CGRect(x: 0, y: keyboardScreenEndFrame.size.height, width: self.view.frame.width, height: self.view.frame.height - keyboardScreenEndFrame.size.height - 30))
    }
    
    func tappedToolBarBtn() {
        let replyText = textView.text
        if replyText != "" && replyText != "Type here" {
            
            textView.resignFirstResponder()
            self.view.transform = CGAffineTransform.identity
            toolbar.frame = (frame: CGRect(x: 0,y: self.view.bounds.size.height - 30.0, width: self.view.bounds.size.width, height: 30.0))
            textView.frame = (frame: CGRect(x: 0, y: 0 ,width: self.view.frame.width - 45, height: 30))
            textView.text = "Type here"
            textView.textColor = UIColor.lightGray
            tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30))
            let newreply: Dictionary<String, AnyObject> = [
                "text": replyText! as AnyObject,
                "author": (FIRAuth.auth()?.currentUser?.uid)! as AnyObject
            ]
            let firebaseNewReply = ref.child("post/" + post + "/replys").childByAutoId()
            firebaseNewReply.setValue(newreply)
            var replaycount = postDic["reply"] as! Int
            replaycount = replaycount + 1
            let firebasenewreplyscount = ref.child("post/" + post + "/reply")
            firebasenewreplyscount.setValue(replaycount)
        }
    }
    
    func showUserData(sender: UIButton) {
        
        let row = sender.tag
        var segueUser = ""
        if row == 1 {
            
        }else if row == 0 {
            segueUser = postDic["author"] as! String
        }else {
            segueUser = replies[row-2]["author"] as! String
        }
        let viewcontroller: UserDetailModalViewController = self.presentedViewController as! UserDetailModalViewController
        viewcontroller.UserKey = segueUser
    }
}


extension ViewpostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type here"{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView){
        
        let maxHeight = 140.0
        let size:CGSize = textView.sizeThatFits(textView.frame.size)
        if (size.height.native <= maxHeight) {
            textView.frame.size.height = size.height
            toolbar.frame = (frame: CGRect(x:0,y: self.view.bounds.size.height - size.height,width: self.view.bounds.size.width,height: size.height))
            textView.frame = (frame: CGRect(x:0,y:0 ,width:self.view.frame.width - 45,height: size.height))
            tableView.frame = (frame: CGRect(x: 0, y: keyboardHeight!, width: self.view.frame.width, height: self.view.frame.height - keyboardHeight! - size.height))
        }
    }
}
