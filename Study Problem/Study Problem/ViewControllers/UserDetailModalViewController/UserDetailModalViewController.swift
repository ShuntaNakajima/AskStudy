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
    
    @IBOutlet var profileImageButton: ProfileImageButtonClass!
    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var followButton: FollowButtonClass!
    @IBOutlet var followingButton: UIButton!
    @IBOutlet var followerButton: UIButton!
    @IBOutlet var userPostButton: UIButton!
    @IBOutlet var userGropeButton: UIButton!
    var userKey = ""
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var myKey: String = ""
    var postKeys: [String] = []
    var myPosts: [[String: AnyObject]] = []
    var selectedPost: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitButton.layer.cornerRadius = 15
        exitButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    @IBAction func exitButtonPushed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func follow(){
        if self.userKey == (FIRAuth.auth()?.currentUser!.uid)!{
        }else if myKey == ""{
            
            FollowButtonClass().follow(uid: userKey)
        }else{
            
            FollowButtonClass().unfollow(uid: userKey)
        }
    }
    
    func reloadFollowButton(){
        
        let recentUesrsQuery = ref.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/").queryOrdered(byChild: "user").queryEqual(toValue: self.userKey)
        recentUesrsQuery.observe(.value, with: { snapshot in
            self.myKey = ""
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    self.myKey = snap.key
                }
            }
            if self.userKey == (FIRAuth.auth()?.currentUser!.uid)!{
                
                self.followButton.setTitle("Me", for: .normal)
                self.followButton.setTitleColor(UIColor.blue, for: .normal)
            }else if self.myKey == "" {
                
                self.followButton.setTitle("Follow", for: .normal)
                self.followButton.setTitleColor(UIColor.black, for: .normal)
            }else{
                
                self.followButton.setTitle("UnFollow", for: .normal)
                self.followButton.setTitleColor(UIColor.red, for: .normal)
            }
        })
    }
    
    func loadData(){
        
        let userRef = ref.child("user").child(userKey)
        ref.child("user/" + self.userKey + "/followers").observe(.value, with: { snapshot in
            
            var num = snapshot.value as! Int
            if num == -1 {
                num = 0
            }
            self.followerButton.setTitle(String(num), for: .normal)
            self.reloadFollowButton()
            
        })
        ref.child("user/" + self.userKey + "/follows").observe(.value, with: { snapshot in
            
            var num = snapshot.value as! Int
            if num == -1 {
                num = 0
            }
            self.followingButton.setTitle(String(num), for: .normal)
            
        })
        reloadFollowButton()
        ref.child("user/" + self.userKey + "/posts").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.postKeys = []
                for snap in snapshots {
                    if let post = snap.value as? String {
                        
                        self.postKeys.insert(post, at: 0)
                    }
                }
                
                if self.postKeys.isEmpty{}else{
                    let post = self.postKeys[0]
                    
                    self.ref.child("post/" + post + "/").observe(.value, with: { snapshot in
                        if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                            var apost = Dictionary<String, AnyObject>()
                            for snap in snapshots{
                                apost[snap.key] = snap.value as AnyObject?
                            }
                            self.myPosts.append(apost)
                        }
                    })
                }
            }
        })
        userRef.observe(FIRDataEventType.value, with: { snapshot in
            
            let postUser = (snapshot.value! as AnyObject!)["username"] as! String
            self.profileLabel.text = postUser
            let recentUesrsQuery = self.ref.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/").queryOrdered(byChild: self.userKey)
            recentUesrsQuery.observe(.value, with: { snapshot in
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    for snap in snapshots {
                        self.myKey = snap.key
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
            let autorsprofileRef = storageRef.child("\(self.userKey)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { data, error in
                
                if error != nil {
                    
                    print("\(error)")
                }else {
                    
                    viewImg = data.flatMap(UIImage.init)!
                    DispatchQueue.main.async(execute:{
                        self.profileImageButton.setBackgroundImage(viewImg, for: .normal)
                    })
                }
            }
        });
    }
}
