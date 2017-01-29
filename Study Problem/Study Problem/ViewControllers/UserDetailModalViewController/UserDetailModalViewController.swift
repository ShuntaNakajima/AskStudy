//
//  UserDetailModalViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/02.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase

class UserDetailModalViewController: UIViewController {
    var UserKey = ""
    let database = FIRDatabase.database().reference()
    @IBOutlet var ProfileImageButton:ProfileImageButton!
    @IBOutlet var ProfileLabel:UILabel!
    @IBOutlet var ExitButton:UIButton!
    @IBOutlet var FollowButton:FollowButton!
    @IBOutlet var FollowIngButton:UIButton!
    @IBOutlet var FollowerButton:UIButton!
    @IBOutlet var UserPostButton:UIButton!
    @IBOutlet var UserGropeButton:UIButton!
    var mykey = ""
    var postkeys = [String!]()
    var mypost = [Dictionary<String, AnyObject>]()
    var selectpost : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        ExitButton.layer.cornerRadius=15
        ExitButton.layer.masksToBounds=true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    @IBAction func ExitButtonPushed(){
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func Follow(){
        if self.UserKey == (FIRAuth.auth()?.currentUser!.uid)!{
        }else if mykey == ""{
            FollowButton.follow(uid: UserKey)
        }else{
            FollowButton.unfollow(uid: UserKey)
        }
    }
    func reloadFollowButton(){
        let Database = FIRDatabase.database().reference()
        let recentUesrsQuery = (Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/").queryOrdered(byChild: "user").queryEqual(toValue: self.UserKey))
        recentUesrsQuery.observe(.value, with: { snapshot in
            self.mykey = ""
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.mykey = snap.key
                }
            }
            if self.UserKey == (FIRAuth.auth()?.currentUser!.uid)!{
                self.FollowButton.setTitle("Me", for: .normal)
                self.FollowButton.setTitleColor(UIColor.blue, for: .normal)
            }else if self.mykey == ""{
                self.FollowButton.setTitle("Follow", for: .normal)
                self.FollowButton.setTitleColor(UIColor.black, for: .normal)
            }else{
                self.FollowButton.setTitle("UnFollow", for: .normal)
                self.FollowButton.setTitleColor(UIColor.red, for: .normal)
            }
        })
    }
    func loadData(){
        let User = database.child("user").child(UserKey)
        database.child("user/" + self.UserKey + "/followers").observe(.value, with: { snapshot in
            if let snap = snapshot as? FIRDataSnapshot {
                var num = snap.value as! Int
                if num == -1{
                    num = 0
                }
                self.FollowerButton.setTitle(String(num), for: .normal)
                self.reloadFollowButton()
            }
        })
        database.child("user/" + self.UserKey + "/follows").observe(.value, with: { snapshot in
            if let snap = snapshot as? FIRDataSnapshot {
                var num = snap.value as! Int
                if num == -1{
                    num = 0
                }
                self.FollowIngButton.setTitle(String(num), for: .normal)
            }
        })
        reloadFollowButton()
        database.child("user/" + self.UserKey + "/posts").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.postkeys = []
                for snap in snapshots {
                    if let post = snap.value as? String {
                        self.postkeys.insert(post, at: 0)
                    }
                }
                if self.postkeys.isEmpty{}else{
                    let post = self.postkeys[0]
                    self.database.child("post/" + post! + "/").observe(.value, with: { snapshot in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            var apost = Dictionary<String, AnyObject>()
                            for snap in snapshots{
                                apost[snap.key] = snap.value as AnyObject?
                            }
                            self.mypost.append(apost)
                        }
                    })
                }
            }
        })
        User.observe(FIRDataEventType.value, with: { snapshot in
            let postUser = (snapshot.value! as AnyObject!)["username"] as! String
            self.ProfileLabel.text = postUser
            let recentUesrsQuery = (self.database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/").queryOrdered(byChild: self.UserKey))
            recentUesrsQuery.observe(.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        self.mykey = snap.key
                        self.reloadFollowButton()
                    }
                }
            })
        }, withCancel: { error in
        })
        DispatchQueue.global().async(execute: {
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
            let autorsprofileRef = storageRef.child("\(self.UserKey)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)!
                    DispatchQueue.main.async(execute:{
                        self.ProfileImageButton.setBackgroundImage(viewImg, for: .normal)
                    });
                }
            }
        });
    }
}
