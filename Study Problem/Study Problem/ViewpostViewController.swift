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
    var Database = Firebase(url: "https://studyproblemfirebase.firebaseio.com/")
    var DataUser = Firebase(url: "https://studyproblemfirebase.firebaseio.com/user/")
    var Datapost = Firebase(url: "https://studyproblemfirebase.firebaseio.com/post/")
    var post : String!
    var newpost : Firebase!
    var replys = [Dictionary<String, AnyObject>]()
    var postDic = Dictionary<String, AnyObject>()
    var toreply : String!
    @IBOutlet var tableView :UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        var mainnib  = UINib(nibName: "PostMainTableViewCell", bundle:nil)
        self.tableView.registerNib(mainnib, forCellReuseIdentifier:"postMainCell")
        var replysnib  = UINib(nibName: "ReplysTableViewCell", bundle:nil)
        self.tableView.registerNib(replysnib, forCellReuseIdentifier:"ReplysCell")
        var myreplysnib  = UINib(nibName: "MyReplysTableViewCell", bundle:nil)
        self.tableView.registerNib(myreplysnib, forCellReuseIdentifier:"MyReplysCell")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let Dataonepost = Firebase(url:"\(Datapost)" + "/" + "\(post)" + "/")
        Dataonepost.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
               
                    
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
                        self.postDic = postDictionary
                        self.tableView.reloadData()
                    
                }
            }
        })

        let Dataapost = Firebase(url:"\(Datapost)" + "/" + "\(post)" + "/repays/")
        Dataapost.observeEventType(.Value, withBlock: { snapshot in
        if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
            
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
//        
//        print(post)
//        
//        let firebasenewreply = Dataapost.childByAutoId()
//        let newreply: Dictionary<String, AnyObject> = [
//            "text": "test",
//            "author": Database.authData.uid!
//        ]
//        // setValue() saves to Firebase.
//        
//        firebasenewreply.setValue(newreply)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return replys.count + 1
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var returncell = UITableViewCell!()
      let maincell = tableView.dequeueReusableCellWithIdentifier("postMainCell") as! PostMainTableViewCell
        let replycell = tableView.dequeueReusableCellWithIdentifier("ReplysCell") as! ReplysTableViewCell
        let myreplycell = tableView.dequeueReusableCellWithIdentifier("MyReplysCell") as! MyReplysTableViewCell
        returncell = maincell
if postDic["author"] as? String != nil{
        if indexPath.row == 0{
          returncell = maincell
            maincell.postLabel!.text = postDic["text"] as! String!
            
            let currentUser = Firebase(url: "\(Database)").childByAppendingPath("user").childByAppendingPath(postDic["author"] as? String)
            
            currentUser.observeEventType(FEventType.Value, withBlock: { snapshot in
                print(snapshot)
                
                let postUser = snapshot.value.objectForKey("username") as! String
                
               // print("Username: \(postUser)")
                maincell.usernameLabel.text = postUser
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }else{
            if replys != []{
            let reply = replys[indexPath.row - 1]
            let postDictionary = reply as? Dictionary<String, AnyObject>
            if postDictionary!["author"] as! String != Database.authData.uid!{
                returncell = replycell
            replycell.postLabel.text = postDictionary!["text"] as? String
            let currentUser = Firebase(url: "\(Database)").childByAppendingPath("user").childByAppendingPath(postDictionary!["author"] as! String)
            
            currentUser.observeEventType(FEventType.Value, withBlock: { snapshot in
                print(snapshot)
                
                let postUser = snapshot.value.objectForKey("username") as! String
                
               // print("Username: \(postUser)")
                replycell.usernameLabel.text = postUser
                }, withCancelBlock: { error in
                    print(error.description)
            })
            }else{
                returncell = myreplycell
                myreplycell.postLabel.text = postDictionary!["text"] as? String
                let currentUser = Firebase(url: "\(Database)").childByAppendingPath("user").childByAppendingPath(postDictionary!["author"] as! String)
                
                currentUser.observeEventType(FEventType.Value, withBlock: { snapshot in
                    print(snapshot)
                    
                    let postUser = snapshot.value.objectForKey("username") as! String
                    
                    // print("Username: \(postUser)")
                    myreplycell.usernameLabel.text = postUser
                    }, withCancelBlock: { error in
                        print(error.description)
                })
            }
            }

        }
        }
        
        
        // We are using a custom cell.
        
        
        // Send the single joke to configureCell() in JokeCellTableViewCell.
   
            return returncell
        
        
        
        
        
        
    }
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if indexPath.row == 0{
           toreply = postDic["author"] as! String
        }else{
            toreply = replys[indexPath.row - 1]["author"] as! String
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
