//Chat function is not included in the version 1.x .

////
////  ChatUserSerchClass.swift
////  Study Problem
////
////  Created by nakajimashunta on 2016/08/18.
////  Copyright © 2016年 ShuntaNakajima. All rights reserved.
////
//
//import UIKit
//import FirebaseStorage
//import FirebaseAuth
//import FirebaseDatabase
//extension ChatUserAddViewController{
//    func UserSerch(uid:String!){
//        let recentUesr = Database.child("user/" + uid + "/follow/")
//        recentUesr.observe(.value, with: { snapshot in
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap1 in snapshots {
//                    if var postDictionary = snap1.value as? Dictionary<String, AnyObject> {
//                       self.FollowerSerch(uid: (postDictionary["user"] as! String!)!)
//                    }
//                }
//            }
//        })
//}
//    func FollowerSerch(uid:String!){
//        let recentUesr = self.Database.child("user/" + uid! + "/follower/").queryOrdered(byChild: "user").queryEqual( toValue: (FIRAuth.auth()?.currentUser!.uid)!)
//        recentUesr.observe(.value, with: { snapshot in
//            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                for snap2 in snapshots {
//                    print(snapshots)
//                    if (snap2.value as? Dictionary<String, AnyObject>) != nil {
//                        let recentUesr = self.Database.child("user/" + (FIRAuth.auth()?.currentUser!.uid)! + "/chats/").queryOrdered(byChild: "user").queryEqual(toValue: uid)
//                        recentUesr.observe(.value, with: { snapshot in
//                            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                                print(snapshots)
//                                    if snapshots == []{
//                                    self.Users.insert(uid, at: 0)
//                                        self.tableView.reloadData()
//                                }
//                            }
//                        })
//                    }
//                }
//            }
//        })
//    }
//}
