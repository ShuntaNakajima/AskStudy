//
//  StarPostViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/30.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import RealmSwift

class StarPostViewController:UIViewController,UIGestureRecognizerDelegate{
    var Database = FIRDatabaseReference.init()
    var selectpost : String!
    var starposts = [String!]()
    var posts = [Dictionary<String, AnyObject>]()
    var segueUser = ""
    var longState = false
    @IBOutlet var tableView :UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib  = UINib(nibName: "postTableViewCell", bundle:nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier:"PostCell")
        Database = FIRDatabase.database().reference()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "cellLongPressed:")
        longPressRecognizer.allowableMovement = 0
        longPressRecognizer.minimumPressDuration = 0.4
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("stars").observeEventType(.Value, withBlock: { snapshot in
            self.posts = []
            self.starposts = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key
                        self.starposts.insert(postDictionary["userstars"] as! String!, atIndex: 0)
                    }
                }
                self.tableView.reloadData()
                for post in self.starposts{
                    self.Database.child("post").child(post).observeEventType(.Value, withBlock: { snapshot in
                        if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                            let key = snapshot.key
                            postDictionary["key"] = key
                            self.posts.append(postDictionary)
                        }
                        self.tableView.reloadData()
                        })
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "viewStarPost") {
            let vpVC: ViewpostViewController = (segue.destinationViewController as? ViewpostViewController)!
            vpVC.post = selectpost
        }
    }
    @IBAction func Post(){
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    func showUserData(sender:UIButton){
        let row = sender.tag
        segueUser = posts[row]["author"] as! String
        let UDMC: UserDetailModalViewController = (self.presentedViewController as? UserDetailModalViewController)!
        UDMC.UserKey = segueUser
    }
}
