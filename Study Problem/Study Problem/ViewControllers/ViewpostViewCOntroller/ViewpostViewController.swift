//
//  ViewpostViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/15.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase

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
        let mainnib  = UINib(nibName: "postTableViewCell", bundle:nil)
        self.tableView.register(mainnib, forCellReuseIdentifier:"PostCell")
        let itemnib = UINib(nibName: "itemTableViewCell", bundle: nil)
        self.tableView.register(itemnib, forCellReuseIdentifier: "ItemCell")
        let replysnib  = UINib(nibName: "ReplysTableViewCell", bundle:nil)
        self.tableView.register(replysnib, forCellReuseIdentifier:"ReplysCell")
        let myreplysnib  = UINib(nibName: "MyReplysTableViewCell", bundle:nil)
        self.tableView.register(myreplysnib, forCellReuseIdentifier:"MyReplysCell")
        toolbar = UIToolbar(frame: CGRect(x:0,y:self.view.bounds.size.height - 30.0,width:self.view.bounds.size.width, height:30.0))
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = UIColor.white
        toolbar.backgroundColor = UIColor.black
        let button3: UIBarButtonItem = UIBarButtonItem(title: "send", style:.plain, target: nil, action: #selector(tappedToolBarBtn))
        let buttonGap: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.items = [buttonGap, buttonGap, button3]
        self.view.addSubview(toolbar)
        myTextView = UITextView(frame: CGRect(x:0,y:0 ,width:self.view.frame.width - 45,height: 30))
        myTextView.layer.borderWidth = 0.5
        myTextView.font = UIFont.systemFont(ofSize: 15)
        myTextView.delegate = self
        myTextView.text = "Type here"
        myTextView.textColor = UIColor.lightGray
        toolbar.addSubview(self.myTextView)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ViewpostViewController.handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        Database.child("post/" + post).observe(.value, with: { (snapshot:FIRDataSnapshot) in
            if snapshot.children.allObjects is [FIRDataSnapshot] {
                if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    postDictionary["key"] = key as AnyObject?
                    guard let BestAnswer = postDictionary["BestAnswer"] as? String else{return}
                    if BestAnswer == ""{
                        self.toolbar.isHidden = false
                        self.tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30))
                    }else{
                        self.toolbar.isHidden = true
                        self.tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    }
                    self.postDic = postDictionary
                    self.tableView.reloadData()
                }
            }
        })
        Database.child("post/" + post + "/replys").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.replys = []
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key as AnyObject?
                        self.replys.append(postDictionary)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let transform = CGAffineTransform(translationX: 0, y: -keyboardScreenEndFrame.size.height)
        self.keyboradheight = keyboardScreenEndFrame.size.height
        self.view.transform = transform
        tableView.frame = (frame: CGRect(x: 0, y: keyboardScreenEndFrame.size.height, width: self.view.frame.width, height: self.view.frame.height - keyboardScreenEndFrame.size.height - 30))
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if myTextView.text == "Type here"{
            myTextView.text = ""
            myTextView.textColor = UIColor.black
        }
    }
    func tappedToolBarBtn(){
        let replyText = myTextView.text
        if replyText != "" && replyText != "Type here" {
            myTextView.resignFirstResponder()
            self.view.transform = CGAffineTransform.identity
            toolbar.frame = (frame: CGRect(x:0,y: self.view.bounds.size.height - 30.0,width: self.view.bounds.size.width,height:30.0))
            myTextView.frame = (frame: CGRect(x:0,y:0 ,width:self.view.frame.width - 45,height: 30))
            myTextView.text = "Type here"
            myTextView.textColor = UIColor.lightGray
            tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30))
            let newreply: Dictionary<String, AnyObject> = [
                "text": replyText! as AnyObject,
                "author": (FIRAuth.auth()?.currentUser?.uid)! as AnyObject
            ]
            let firebasenewreply = Database.child("post/" + post + "/replys").childByAutoId()
            firebasenewreply.setValue(newreply)
            var replaycount = postDic["reply"] as! Int
            replaycount = replaycount + 1
            let firebasenewreplyscount = Database.child("post/" + post + "/reply")
            firebasenewreplyscount.setValue(replaycount)
        }
    }
    func textViewDidChange(_ textView: UITextView){
        let maxHeight = 140.0
        let size:CGSize = myTextView.sizeThatFits(myTextView.frame.size)
        if (size.height.native <= maxHeight) {
            myTextView.frame.size.height = size.height
            toolbar.frame = (frame: CGRect(x:0,y: self.view.bounds.size.height - size.height,width: self.view.bounds.size.width,height: size.height))
            myTextView.frame = (frame: CGRect(x:0,y:0 ,width:self.view.frame.width - 45,height: size.height))
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
    func reportPost(sender:UIButton){
        let row = sender.tag
        let alert = UIAlertController(title: "Report Post", message: "Are you sure report this Post?", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Report", style: .default, handler:{(_) in
            let newreport: Dictionary<String, Any> = [
                "reportPost":self.postDic["key"] as! String!,
                "reportUser":FIRAuth.auth()?.currentUser?.uid
            ]
            self.Database.child("report").childByAutoId().setValue(newreport)
        })
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelaction)
        present(alert, animated: true, completion: nil)
    }
}
