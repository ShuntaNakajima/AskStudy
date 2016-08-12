//
//  FollowButtonClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/04.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FollowButtonClass: UIButton {
    var Database = FIRDatabaseReference.init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateLayout()
    }
    override func awakeFromNib() {
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateLayout()
    }
    func updateLayout(){
        self.layer.cornerRadius=45
        self.layer.masksToBounds=true
    }
    func follow(uid:String!){
        Database = FIRDatabase.database().reference()
        var followingUserfollower = 0
        var myFollow = 0
        Database.child("user/" + uid + "/followers").observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot.children as? FIRDataSnapshot {
                followingUserfollower = (snap as! Int)
            }
        })
        Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follows").observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot.children as? FIRDataSnapshot {
                myFollow = (snap as! Int)
            }
        })
        let newFollowChild = Database.child("user/\(uid)/follower/").childByAutoId()
        newFollowChild.setValue("\((FIRAuth.auth()?.currentUser!.uid)!)")
        let newFollowUserFollowerChild = Database.child("user/\(uid)/followers")
        newFollowUserFollowerChild.setValue(followingUserfollower + 1)
        let mynewFollowChild = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/follow/").childByAutoId()
         mynewFollowChild.setValue("\(uid)")
        let follows = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/follows")
        follows.setValue(myFollow + 1)
    }
    func unfollow(uid:String!){
        Database = FIRDatabase.database().reference()
        let recentUsersQuery = (Database.child("user/" + uid + "/follower/").queryEqualToValue(FIRAuth.auth()?.currentUser!.uid))
        var key = ""
        recentUsersQuery.observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot.children as? FIRDataSnapshot {
                key = snap.key
            }
        })
        Database.child("user/" + uid + "/follower/" + key).removeValue()
        let myrecentUesrsQuery = (Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/").queryEqualToValue(uid))
        var mykey = ""
        myrecentUesrsQuery.observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot.children as? FIRDataSnapshot {
                mykey = snap.key
            }
        })
        Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/" + mykey).removeValue()
        var followingUserfollower = 0
        var myFollow = 0
        Database.child("user/" + uid + "/followers").observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot.children as? FIRDataSnapshot {
                followingUserfollower = (snap as! Int)
            }
        })
        Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follows").observeEventType(.Value, withBlock: { snapshot in
            if let snap = snapshot.children as? FIRDataSnapshot {
                myFollow = (snap as! Int)
            }
        })
        let newFollowUserFollowerChild = Database.child("user/\(uid)/followers")
        newFollowUserFollowerChild.setValue(followingUserfollower - 1)
        let follows = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/follows")
        follows.setValue(myFollow - 1)
    }
}
