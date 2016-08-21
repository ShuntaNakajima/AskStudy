//
//  ChatUserSerchClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/18.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
extension ChatUserAddViewController{
    func UserSerch(uid:String!){
        let recentUesr = Database.child("user/" + uid + "/follow/")
        recentUesr.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap1 in snapshots {
                    if var postDictionary = snap1.value as? Dictionary<String, AnyObject> {
                       self.FollowerSerch(postDictionary["user"] as! String!)
                    }
                }
            }
        })
}
    func FollowerSerch(uid:String!){
        let recentUesr = self.Database.child("user/" + uid + "/follower/").queryOrderedByChild("user").queryEqualToValue( (FIRAuth.auth()?.currentUser!.uid)!)
        recentUesr.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap2 in snapshots {
                    print(snapshots)
                    if var postDictionary = snap2.value as? Dictionary<String, AnyObject> {
                        let recentUesr = self.Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/chats/").queryOrderedByChild("user").queryEqualToValue(uid)
                        recentUesr.observeEventType(.Value, withBlock: { snapshot in
                            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                                print(snapshots)
                                    if snapshots == []{
                                    self.Users.insert(uid, atIndex: 0)
                                        self.tableView.reloadData()
                                }
                            }
                        })
                    }
                }
            }
        })
    }
}
