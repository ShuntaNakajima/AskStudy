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
        
        
        // ツールバー
        toolbar = UIToolbar(frame: CGRectMake(0, self.view.bounds.size.height - 45.0, self.view.bounds.size.width, 45.0))
        toolbar.barStyle = .BlackTranslucent
        toolbar.tintColor = UIColor.whiteColor()
        toolbar.backgroundColor = UIColor.blackColor()
        let button3: UIBarButtonItem = UIBarButtonItem(title: "send", style:.Plain, target: nil, action: #selector(tappedToolBarBtn))
        let buttonGap: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        
        toolbar.items = [buttonGap, buttonGap, button3]
        
        self.view.addSubview(toolbar)
        myTextView = UITextView(frame: CGRectMake(0,0 ,self.view.frame.width - 45, 45))
        
        // 表示する文字を代入する.
        myTextView.text = "Type comment"
        
        
        // 枠を表示する.
        myTextView.layer.borderWidth = 0.5
        myTextView.font = UIFont.systemFontOfSize(25.5)
        // Delegateを設定する.
        myTextView.delegate = self
        myTextView.text = "Type here"
        myTextView.textColor = UIColor.lightGrayColor()
        
        // ツールバーに追加する.
        toolbar.addSubview(self.myTextView)
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(ViewpostViewController.handleKeyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        
        Database.child("post/" + post).observeEventType(.Value, withBlock: { snapshot in
            
            if snapshot.children.allObjects is [FIRDataSnapshot] {
                
                
                
                // Make our jokes array for the tableView.
                print(snapshot)
                if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    
                    
                    // Items are returned chronologically, but it's more fun with the newest jokes first.
                    //            Dictionary<String, AnyObject> = [
                    //                "text": postText!,
                    //                "subject": subjectTextfield.text!,
                    //                "replay":0,
                    //                "author": currentUserId
                    //            ]
                    //postディクショなりの内容
                    postDictionary["key"] = key
                    print(postDictionary)
                    self.postDic = postDictionary
                    self.tableView.reloadData()
                    
                }
            }
        })
        
        
        Database.child("post/" + post + "/replys").observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                self.replys = []
                
                for snap in snapshots {
                    
                    // Make our jokes array for the tableView.
                    
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        
                        // Items are returned chronologically, but it's more fun with the newest jokes first.
                        //            Dictionary<String, AnyObject> = [
                        //                "text": postText!,
                        //                "author": currentUserId
                        //            ]
                        //postディクショなりの内容
                        postDictionary["key"] = key
                        self.replys.append(postDictionary)
                        self.tableView.reloadData()
                    }
                }
            }
        })
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
    }
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let transform = CGAffineTransformMakeTranslation(0, -keyboardScreenEndFrame.size.height)
        
        self.keyboradheight = keyboardScreenEndFrame.size.height
        
        print(keyboardScreenEndFrame.size.height)
        
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
            // Build the new Joke.
            // AnyObject is needed because of the votes of type Int.
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
            // Send it over to DataService to seal the deal.
            
            
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return replys.count + 2
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if postDic["author"] as? String != nil{
            if indexPath.row == 0{
                let maincell = tableView.dequeueReusableCellWithIdentifier("postMainCell") as! PostMainTableViewCell
                maincell.postLabel!.text = postDic["text"] as! String!
               
                maincell.profileImageView.layer.cornerRadius=25
                maincell.profileImageView.clipsToBounds=true
               maincell.profileImageView.image = UIImage(named: "noimage.gif")!
                
                let userdata = UserData().readimage(postDic["author"] as! String!)
                if userdata.0 == "noset"{
                    let currentUser = Database.child("user").child(postDic["author"] as! String!)
                    
                    currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                        print(snapshot)
                        
                        let postUser = snapshot.value!.objectForKey("username") as! String
                        
                        
                        print("Username: \(postUser)")
                        let storage = FIRStorage.storage()
                        let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
                        let autorsprofileRef = storageRef.child("\((self.postDic["author"] as? String))/profileimage.png")
                        autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                            if error != nil {
                                // Uh-oh, an error occurred!
                                print(error)
                            } else {
                                
                                
                                let viewImg = data.flatMap(UIImage.init)
                                let resizedSize = CGSizeMake(30, 30)
                                UIGraphicsBeginImageContext(resizedSize)
                                viewImg!.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
                                //                    var sv = cell.profileImage.superview!
                                //                    sv.removeConstraints(sv.constraints)
                                
                                
                                maincell.profileImageView.image = viewImg
                                let data = UserData()
                                data.id = self.postDic["author"] as! String!
                                data.username =  postUser
                                
                                if let imagedata = UIImagePNGRepresentation(viewImg!) {
                                    data.image = imagedata
                                }
                                
                                data.setimage()
                            }
                        }
                        maincell.usernameLabel.text = postUser
                        
                        }, withCancelBlock: { error in
                            print(error.description)
                    })
                }else{
                    let image: UIImage? = UIImage(data: userdata.2)
                    maincell.usernameLabel.text = userdata.1
                    maincell.profileImageView.image = image
                    
                }

                return maincell
            }else if indexPath.row == 1{
                let itemcell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! itemTableViewCell
                itemcell.ReplycountLabel!.text = String(postDic["reply"] as! Int!)
                itemcell.DateLable.text = postDic["date"] as! String!
                return itemcell
            }else{
                if replys != []{
                    let reply = replys[indexPath.row - 2]
                    let postDictionary = reply as? Dictionary<String, AnyObject>
                    if postDictionary!["author"] as? String != FIRAuth.auth()?.currentUser!.uid{
                        let replycell = tableView.dequeueReusableCellWithIdentifier("ReplysCell") as! ReplysTableViewCell
                        replycell.postLabel.text = postDictionary!["text"] as? String
                        replycell.profileImageView.layer.cornerRadius=25
                        replycell.profileImageView.clipsToBounds=true
                        replycell.profileImageView.image = UIImage(named: "noimage.gif")!
                        
                        let userdata = UserData().readimage(postDictionary!["author"] as? String)
                        if userdata.0 == "noset"{
                            let currentUser = Database.child("user").child((postDictionary!["author"] as? String)!)
                            
                            currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                                print(snapshot)
                                
                                let postUser = snapshot.value!.objectForKey("username") as! String
                                
                                
                                print("Username: \(postUser)")
                                let storage = FIRStorage.storage()
                                let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
                                let autorsprofileRef = storageRef.child("\(postDictionary!["author"] as? String)/profileimage.png")
                                autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                                    if error != nil {
                                        // Uh-oh, an error occurred!
                                        print(error)
                                    } else {
                                        
                                        
                                        let viewImg = data.flatMap(UIImage.init)
                                        let resizedSize = CGSizeMake(30, 30)
                                        UIGraphicsBeginImageContext(resizedSize)
                                        viewImg!.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
                                        //                    var sv = cell.profileImage.superview!
                                        //                    sv.removeConstraints(sv.constraints)
                                        
                                        
                                        replycell.profileImageView.image = viewImg
                                        let data = UserData()
                                        data.id = (postDictionary!["author"] as? String)!
                                        data.username =  postUser
                                        
                                        if let imagedata = UIImagePNGRepresentation(viewImg!) {
                                            data.image = imagedata
                                        }
                                        
                                        data.setimage()
                                    }
                                }
                                replycell.usernameLabel.text = postUser
                                
                                }, withCancelBlock: { error in
                                    print(error.description)
                            })
                        }else{
                            let image: UIImage? = UIImage(data: userdata.2)
                            replycell.usernameLabel.text = userdata.1
                            replycell.profileImageView.image = image
                            
                        }

                        return replycell
                    }else{
                        let myreplycell = tableView.dequeueReusableCellWithIdentifier("MyReplysCell") as! MyReplysTableViewCell
                        myreplycell.postLabel.text = postDictionary!["text"] as? String
                        myreplycell.profileImageView.layer.cornerRadius=25
                        myreplycell.profileImageView.clipsToBounds=true
                        myreplycell.profileImageView.image = UIImage(named: "noimage.gif")!
                        
                        let userdata = UserData().readimage(postDictionary!["author"] as? String)
                        if userdata.0 == "noset"{
                            let currentUser = Database.child("user").child((postDictionary!["author"] as? String)!)
                            
                            currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                                print(snapshot)
                                
                                let postUser = snapshot.value!.objectForKey("username") as! String
                                
                                
                                print("Username: \(postUser)")
                                let storage = FIRStorage.storage()
                                let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
                                let autorsprofileRef = storageRef.child("\(postDictionary!["author"] as? String)/profileimage.png")
                                autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                                    if error != nil {
                                        // Uh-oh, an error occurred!
                                        print(error)
                                    } else {
                                        
                                        
                                        let viewImg = data.flatMap(UIImage.init)
                                        let resizedSize = CGSizeMake(30, 30)
                                        UIGraphicsBeginImageContext(resizedSize)
                                        viewImg!.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
                                        //                    var sv = cell.profileImage.superview!
                                        //                    sv.removeConstraints(sv.constraints)
                                        
                                        
                                        myreplycell.profileImageView.image = viewImg
                                        let data = UserData()
                                        data.id = (postDictionary!["author"] as? String)!
                                        data.username =  postUser
                                        
                                        if let imagedata = UIImagePNGRepresentation(viewImg!) {
                                            data.image = imagedata
                                        }
                                        
                                        data.setimage()
                                    }
                                }
                                myreplycell.usernameLabel.text = postUser
                                
                                }, withCancelBlock: { error in
                                    print(error.description)
                            })
                        }else{
                            let image: UIImage? = UIImage(data: userdata.2)
                            myreplycell.usernameLabel.text = userdata.1
                            myreplycell.profileImageView.image = image
                            
                        }
                        return myreplycell
                    }
                }else{
                    let cell = tableView.dequeueReusableCellWithIdentifier("postMainCell") as! PostMainTableViewCell
                    return cell
                }
            }
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("postMainCell") as! PostMainTableViewCell
            return cell
        }
    }
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if indexPath.row == 0{
            toreply = postDic["author"] as! String
        }else{
            toreply = replys[indexPath.row - 2]["author"] as! String
            myTextView.becomeFirstResponder()
        }
        
        
        
    }
    func textViewDidChange(textView: UITextView){
        let textViewtext = myTextView.text!
        
        
        
        let maxHeight = 140.0  // 入力フィールドの最大サイズ
        let size:CGSize = myTextView.sizeThatFits(myTextView.frame.size)
        
        if(size.height.native <= maxHeight) {
            myTextView.frame.size.height = size.height
            
            print(myTextView.text!)
            print(textViewtext)
            //   let nowheight = toolbar.frame.height
            
            toolbar.frame = (frame: CGRectMake(0, self.view.bounds.size.height - size.height, self.view.bounds.size.width, size.height))
            myTextView.frame = (frame: CGRectMake(0,0 ,self.view.frame.width - 45, size.height))
            
            tableView.frame = (frame: CGRect(x: 0, y: keyboradheight!, width: self.view.frame.width, height: self.view.frame.height - keyboradheight! - size.height))
            
        }
        
        
    }
    
    
    
}
