//
//  StarPostViewContorollerTableviewClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/30.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//


import Foundation
import UIKit
import Firebase

extension StarPostViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        for i in cell.view.subviews{
            i.removeFromSuperview()
        }
        cell.replyscountLabel.text = String(post["reply"] as! Int!)
        cell.subjectLabel.text = post["subject"] as? String!
        let postdate = post["date"] as! String!
        let now = Date()
        cell.dateLabel.text = now.offset(toDate: (postdate?.postDate())!)
        cell.textView.text = post["text"] as? String
        network.loadusername(uid: (post["author"] as? String)!,success: {username in
            cell.profileLabel.text = username
        })
        network.cacheuserimage(uid: (post["author"] as? String)!, success: {image in
            cell.profileImage.setBackgroundImage(image, for: UIControlState.normal)
            cell.layoutSubviews()
        })
        cell.view.translatesAutoresizingMaskIntoConstraints = false
        cell.setNib(photos: post["Photo"] as! Int,key:post["key"] as! String,on:self)
        cell.profileImage.tag = indexPath.row
        cell.profileImage.addTarget(self, action: #selector(self.showUserData(sender:)), for: .touchUpInside)
        return cell
    }
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        let post = posts[indexPath.row]
        selectpost = post["key"] as! String!
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
                let database = FIRDatabase.database().reference()
                let recentUesrsQuery = database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("stars").queryOrdered(byChild: "userstars").queryEqual(toValue: self.posts[indexPath!.row]["key"] as! String!)
                recentUesrsQuery.observe(.value, with: { snapshot in
                    var mykey = ""
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots {
                            mykey = snap.key
                        }
                    }
                    if mykey == ""{
                        if self.longState == true{
                            let newFollowChild = database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/stars/").childByAutoId().child("userstars")
                            newFollowChild.setValue(self.posts[indexPath!.row]["key"] as! String!)
                            let anImage = UIImage(named: "star.gif")
                            _ = ToastView.showText(text: NSLocalizedString("Star",comment:""), image: anImage!, imagePosition: .Left, duration:.Short)
                            self.longState = false
                        }
                    }else{
                        if self.longState == true{
                            database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/stars/").child(mykey).child("userstars").removeValue()
                            if self.posts.count == 1{
                                self.posts = []
                                self.tableView.reloadData()
                            }else{
                                self.reload()
                            }
                            let anImage = UIImage(named: "star.gif")
                            _ = ToastView.showText(text: NSLocalizedString("UnStar",comment:""), image: anImage!, imagePosition: .Left, duration:.Short)
                            self.longState = false
                        }
                    }
                })
            }
        }
    }
    
}

