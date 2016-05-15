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


    var posts = [[String!]]()
    @IBOutlet var tableView :UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // observeEventType is called whenever anything changes in the Firebase - new Jokes or Votes.
        // It's also called here in viewDidLoad().
        // It's always listening.
        
        Datapost.observeEventType(.Value, withBlock: { snapshot in
            
            // The snapshot is a current look at our jokes data.
            
            print(snapshot.value)
            
            self.posts = []
            var nib  = UINib(nibName: "postTableViewCell", bundle:nil)
            self.tableView.registerNib(nib, forCellReuseIdentifier:"PostCell")
            
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our jokes array for the tableView.
                    
                    if let postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let text = postDictionary["text"] as? String
                        let subject = postDictionary["subject"] as? String
                        let author = postDictionary["author"] as? String
                        let newpost : [String!] = [text,subject,author]
                        
                        // Items are returned chronologically, but it's more fun with the newest jokes first.
                        
                        self.posts.insert(newpost, atIndex: 0)
                        self.tableView.reloadData()
                    }
                }
                
            }
            
            // Be sure that the tableView updates when there is new data.
          
            
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
        
        let joke = posts[indexPath.row]
        
        // We are using a custom cell.
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! postTableViewCell
            
            // Send the single joke to configureCell() in JokeCellTableViewCell.
            
            cell.textView.text = joke[0]
        let currentUser = Firebase(url: "\(Database)").childByAppendingPath("user").childByAppendingPath(Database.authData.uid)
        
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
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 175
    }

    @IBAction func test(){
        print("adfsdadfsdafs")
        self.slideMenuController()?.openLeft()
    }


}
