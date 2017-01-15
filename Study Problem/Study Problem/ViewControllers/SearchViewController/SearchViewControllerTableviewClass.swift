//
//  SearchViewControllerTableviewClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/09/23.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import DZNEmptyDataSet

extension SearchViewController:UITableViewDataSource,UITableViewDelegate{
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
         if segucon.selectedSegmentIndex == 0{
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
            }, withCancel: { (error) in
                print(error)
        })
        DispatchQueue.global().async(execute:{
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
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
        cell.profileImage.addTarget(self, action: #selector(SearchViewController.showUserData(sender:)), for: .touchUpInside)
        return cell
         }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserCell") as! ChatTableViewCell
            cell.profileLabel.text = post["username"] as? String!
            DispatchQueue.global().async(execute:{
                var viewImg = UIImage()
                let storage = FIRStorage.storage()
                let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
                let key = post["key"] as? String!
                let autorsprofileRef = storageRef.child("\(key!!)/profileimage.png")
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
            cell.profileImage.addTarget(self, action: #selector(SearchViewController.showUserData(sender:)), for: .touchUpInside)
            return cell

        }
    }
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        if segucon.selectedSegmentIndex == 0{
        let post = posts[indexPath.row]
        let postDictionary = post as? Dictionary<String, AnyObject>
        selectpost = postDictionary!
        selectpostID = postDictionary!["key"] as! String!
        if selectpost != nil {
            searchBar.resignFirstResponder()
            performSegue(withIdentifier: "viewSarchPost",sender: nil)
        }
        }
    }
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        if segucon.selectedSegmentIndex == 0{
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
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "No result"
        let font = UIFont.systemFont(ofSize: 14.0, weight: 2.0)
        return NSAttributedString(
            string: str,
            attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.black]
        )
    }
}
