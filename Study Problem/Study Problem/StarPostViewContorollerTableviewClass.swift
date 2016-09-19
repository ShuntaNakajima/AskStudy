//
//  StarPostViewContorollerTableviewClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/30.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//


import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

extension StarPostViewController:UITableViewDataSource,UITableViewDelegate{


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! postTableViewCell
        let postDictionary = post as? Dictionary<String, AnyObject>
        cell.replyscountLabel.text = String(postDictionary!["reply"] as! Int!)
        cell.subjectLabel.text = postDictionary!["subject"] as? String!
        let postdate = postDictionary!["date"] as! String!
        let now = Date()
        cell.dateLabel.text = now.offset(toDate: (postdate?.postDate())!)
        cell.textView.text = postDictionary!["text"] as? String
        let currentUser = Database.child("user").child((postDictionary!["author"] as? String)!)
        currentUser.observe(FIRDataEventType.value, with: { snapshot in
            let postUser = (snapshot.value! as AnyObject)["username"] as! String
            cell.profileLabel.text = postUser
            }, withCancel: { (error: Error) in
                print(error)
        })
        DispatchQueue.global().async(execute:{
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\((postDictionary!["author"] as? String)!)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)!
                    DispatchQueue.main.async(execute: {
                        cell.profileImage.setBackgroundImage(viewImg, for: UIControlState.normal)
                        cell.layoutSubviews()
                    });
                }
            }
        });
        cell.profileImage.tag = indexPath.row
        cell.profileImage.addTarget(self, action: #selector(StarPostViewController.showUserData(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        let post = posts[indexPath.row]
        let postDictionary = post as? Dictionary<String, AnyObject>
        selectpost = postDictionary!["key"] as! String!
        if selectpost != nil {
            performSegue(withIdentifier: "viewStarPost",sender: nil)
        }
    }
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath == nil {
        } else if recognizer.state == UIGestureRecognizerState.began  {
            if longState == false{
                longState = true
                let Database = FIRDatabase.database().reference()
                let recentUesrsQuery = Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("stars").queryOrdered(byChild: "userstars").queryEqual(toValue: self.posts[indexPath!.row]["key"] as! String!)
                recentUesrsQuery.observe(.value, with: { snapshot in
                    var mykey = ""
                    print(snapshot.value)
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        print(snapshots)
                        for snap in snapshots {
                            mykey = snap.key
                        }
                    }
                    if mykey == ""{
                        if self.longState == true{
                            let newFollowChild = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/stars/").childByAutoId().child("userstars")
                            newFollowChild.setValue(self.posts[indexPath!.row]["key"] as! String!)
                            let anImage = UIImage(named: "star.gif")
                            ToastView.showText(text: "Star", image: anImage!, imagePosition: .Left, duration:.Short)
                            self.longState = false
                        }
                    }else{
                        if self.longState == true{
                            Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/stars/").child(mykey).child("userstars").removeValue()
                            if self.posts.count == 1{
                                self.posts = []
                                self.tableView.reloadData()
                            }else{
                                self.reload()
                            }
                            let anImage = UIImage(named: "star.gif")
                            ToastView.showText(text: "UnStar", image: anImage!, imagePosition: .Left, duration:.Short)
                            self.longState = false
                        }
                    }
                })
            }
        }
    }
}

