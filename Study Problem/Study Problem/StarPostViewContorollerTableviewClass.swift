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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! postTableViewCell
        let postDictionary = post as? Dictionary<String, AnyObject>
        cell.replyscountLabel.text = String(postDictionary!["reply"] as! Int!)
        cell.subjectLabel.text = postDictionary!["subject"] as? String!
        let postdate = postDictionary!["date"] as! String!
        let now = NSDate()
        cell.dateLabel.text = now.offset(postdate.postDate())
        cell.textView.text = postDictionary!["text"] as? String
        let currentUser = Database.child("user").child((postDictionary!["author"] as? String)!)
        currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            let postUser = snapshot.value!.objectForKey("username") as! String
            cell.profileLabel.text = postUser
            }, withCancelBlock: { error in
                print(error.description)
        })
        let profileimageclass = ProfileImageClass()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var viewImg = UIImage!()
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\((postDictionary!["author"] as? String)!)/profileimage.png")
            autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)
                    if profileimageclass.selectFaction((postDictionary!["author"] as? String)!).isEmpty{
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.profileImage.setBackgroundImage(viewImg!, forState: UIControlState.Normal)
                            cell.layoutSubviews()
                            profileimageclass.appendFaction((postDictionary!["author"] as? String)!, img: viewImg)
                        });
                    }else{
                        let profile = profileimageclass.selectFaction((postDictionary!["author"] as? String)!)
                        cell.profileImage.setBackgroundImage(profile[0].image!, forState: UIControlState.Normal)
                        cell.layoutSubviews()
                    }
                }
            }
        });
        cell.profileImage.tag = indexPath.row
        cell.profileImage.addTarget(self, action: "showUserData:", forControlEvents: .TouchUpInside)
        return cell
    }
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let post = posts[indexPath.row]
        let postDictionary = post as? Dictionary<String, AnyObject>
        selectpost = postDictionary!["key"] as! String!
        if selectpost != nil {
            performSegueWithIdentifier("viewStarPost",sender: nil)
        }
    }
}

