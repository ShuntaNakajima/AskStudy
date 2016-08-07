//
//  UserDetailModalViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/02.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UserDetailModalViewController: UIViewController {
var UserKey = ""
    @IBOutlet var ProfileImageButton:ProfileImageButtonClass!
    @IBOutlet var ProfileLabel:UILabel!
    @IBOutlet var ExitButton:UIButton!
    @IBOutlet var FollowButton:FollowButtonClass!
    @IBOutlet var FollowIngButton:UIButton!
    @IBOutlet var FollowerButton:UIButton!
    var mykey = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        ExitButton.layer.cornerRadius=15
        ExitButton.layer.masksToBounds=true
        FollowIngButton.layer.cornerRadius=10
    FollowIngButton.layer.masksToBounds=true
        FollowerButton.layer.cornerRadius=10
        FollowerButton.layer.masksToBounds=true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func ExitButtonPushed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func Follow(){
        if self.UserKey == (FIRAuth.auth()?.currentUser!.uid)!{
        }else if mykey == ""{
            FollowButtonClass().follow(UserKey)
        }else{
            FollowButtonClass().unfollow(UserKey)
        }
    }
    func reloadFollowButton(){
        let Database = FIRDatabase.database().reference()
        let recentUesrsQuery = (Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/").queryOrderedByChild(self.UserKey))
        recentUesrsQuery.observeEventType(.Value, withBlock: { snapshot in
            self.mykey = ""
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.mykey = snap.key
                        }
            }
            if self.UserKey == (FIRAuth.auth()?.currentUser!.uid)!{
                self.FollowButton.setTitle("Me", forState: .Normal)
                self.FollowButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            }else if self.mykey == ""{
                self.FollowButton.setTitle("Follow", forState: .Normal)
                self.FollowButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            }else{
                self.FollowButton.setTitle("UnFollow", forState: .Normal)
                self.FollowButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            }
            })
    }
    func loadData(){
        let Database = FIRDatabase.database().reference()
        let User = Database.child("user").child(UserKey)
        Database.child("user/" + self.UserKey + "/followers").observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot as? FIRDataSnapshot {
                var num = snap.value as! Int
                if num == -1{
                    num = 0
                }
                self.FollowerButton.setTitle(String(num), forState: .Normal)
                self.reloadFollowButton()
            }
        })
        Database.child("user/" + self.UserKey + "/follows").observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot as? FIRDataSnapshot {
                var num = snap.value as! Int
                if num == -1{
                 num = 0
                }
                self.FollowIngButton.setTitle(String(num), forState: .Normal)
            }
        })
        reloadFollowButton()
        User.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            let postUser = snapshot.value!.objectForKey("username") as! String
            self.ProfileLabel.text = postUser
            let recentUesrsQuery = (Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/").queryOrderedByChild(self.UserKey))
            recentUesrsQuery.observeEventType(.Value, withBlock: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        self.mykey = snap.key
                        self.reloadFollowButton()
                    }
                }
            })
            }, withCancelBlock: { error in
                print(error.description)
        })
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var viewImg = UIImage!()
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\(self.UserKey)/profileimage.png")
            autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.ProfileImageButton.setBackgroundImage(viewImg!, forState: .Normal)
                    });
                }
            }
        });
    }
}
