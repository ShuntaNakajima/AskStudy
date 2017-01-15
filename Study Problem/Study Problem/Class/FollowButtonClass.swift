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
    }
    
    func follow(uid:String!){
        Database = FIRDatabase.database().reference()
        var followingUserfollower = 0
        var myFollow = 0
        Database.child("user/" + uid + "/followers").observeSingleEvent(of: .value, with: { snapshot in
            followingUserfollower = (snapshot.value as! Int)
            let newFollowUserFollowerChild = self.Database.child("user/" + uid + "/followers")
            newFollowUserFollowerChild.setValue(followingUserfollower + 1)
        })
        Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follows").observeSingleEvent(of: .value, with: { snapshot in
            myFollow = (snapshot.value as! Int)
            let follows = self.Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/follows")
            follows.setValue(myFollow + 1)
        })
        let newFollowChild = Database.child("user/" + uid + "/follower/").childByAutoId().child("user")
        newFollowChild.setValue("\((FIRAuth.auth()?.currentUser!.uid)!)")
        let mynewFollowChild = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/follow/").childByAutoId().child("user")
        mynewFollowChild.setValue(uid)
    }
    
    func unfollow(uid:String!){
        Database = FIRDatabase.database().reference()
        let recentUsersQuery = (Database.child("user/" + uid + "/follower").queryOrdered(byChild: "user").queryEqual(toValue: (FIRAuth.auth()?.currentUser!.uid)!))
        var key = ""
        recentUsersQuery.observeSingleEvent(of: .value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    key = snap.key
                    self.Database.child("user/" + uid + "/follower/" + key).removeValue()
                }
            }
        })
        let myrecentUesrsQuery = (Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/").queryOrdered(byChild: "user").queryEqual(toValue: uid))
        var mykey = ""
        myrecentUesrsQuery.observeSingleEvent(of: .value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    mykey = snap.key
                    self.Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follow/" + mykey).removeValue()
                }
            }
        })
        var followingUserfollower = 0
        var myFollow = 0
        Database.child("user/" + uid + "/followers").observeSingleEvent(of: .value, with: { snapshot in
            followingUserfollower = (snapshot.value as! Int)
            let newFollowUserFollowerChild = self.Database.child("user/" + uid + "/followers")
            newFollowUserFollowerChild.setValue(followingUserfollower - 1)
        })
        Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/follows").observeSingleEvent(of: .value, with: { snapshot in
            myFollow = (snapshot.value as! Int)
            let follows = self.Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/follows")
            follows.setValue(myFollow - 1)
        })
    }
}
