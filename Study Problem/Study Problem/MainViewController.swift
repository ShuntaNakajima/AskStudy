//
//  MainViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Firebase

class MainViewController: UIViewController {
    
    var Database = Firebase(url: "https://studyproblemfirebase.firebaseio.com/")
    var DataUser = Firebase(url: "https://studyproblemfirebase.firebaseio.com/user/")
    var Datapost = Firebase(url: "https://studyproblemfirebase.firebaseio.com/post/")
    
    var selectpost : String!
    var posts = [Dictionary<String, AnyObject>]()
    @IBOutlet var tableView :UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        
        Datapost.observeEventType(.Value, withBlock: { snapshot in
            
            // The snapshot is a current look at our jokes data.
            
            print(snapshot.value)
            
            self.posts = []
            var nib  = UINib(nibName: "postTableViewCell", bundle:nil)
            self.tableView.registerNib(nib, forCellReuseIdentifier:"PostCell")
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our jokes array for the tableView.
                    
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        
                        // Items are returned chronologically, but it's more fun with the newest jokes first.
                        //            Dictionary<String, AnyObject> = [
                        //                "text": postText!,
                        //                "subject": subjectTextfield.text!,
                        //                "replay":0,
                        //                "author": currentUserId
                        //            ]
                        //postディクショなりの内容
                        postDictionary["key"] = key
                        self.posts.insert(postDictionary, atIndex: 0)
                        self.tableView.reloadData()
                    }
                }
                
            }     
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        // We are using a custom cell.
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! postTableViewCell
        
        // Send the single joke to configureCell() in JokeCellTableViewCell.
        let postDictionary = post as? Dictionary<String, AnyObject>
        cell.textView.text = postDictionary!["text"] as? String
        let currentUser = Firebase(url: "\(Database)").childByAppendingPath("user").childByAppendingPath(postDictionary!["author"] as! String)
        
        currentUser.observeEventType(FEventType.Value, withBlock: { snapshot in
            print(snapshot)
            
            let postUser = snapshot.value.objectForKey("username") as! String
            
            print("Username: \(postUser)")
            cell.profileLabel.text = postUser
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        return cell
        
        
        
    }
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let post = posts[indexPath.row]
        let postDictionary = post as? Dictionary<String, AnyObject>
        selectpost = postDictionary!["key"] as! String!
        
        if selectpost != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            performSegueWithIdentifier("viewPost",sender: nil)
        }
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "viewPost") {
            let vpVC: ViewpostViewController = (segue.destinationViewController as? ViewpostViewController)!
            // SubViewController のselectedImgに選択された画像を設定する
            vpVC.post = selectpost
        }
    }
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 175
    //    }
    
    @IBAction func test(){
        print("adfsdadfsdafs")
        self.slideMenuController()?.openLeft()
    }
    
    
}
