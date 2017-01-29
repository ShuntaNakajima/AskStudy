//
//  MainViewControllerTableViewClass.swift
//
//
//  Created by nakajimashunta on 2016/07/07.
//
//
import Foundation
import UIKit
import Firebase
import SVProgressHUD

extension MainViewController:UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.view.translatesAutoresizingMaskIntoConstraints = false
        cell.setNib(photos: post["Photo"] as! Int,key:post["key"] as! String,on:self)
        cell.replyscountLabel.text = String(post["reply"] as! Int!)
        cell.subjectLabel.text = post["subject"] as? String!
        cell.menuButton.tag = indexPath.row
        cell.menuButton.addTarget(self, action: #selector(MainViewController.reportPost(sender:)), for: .touchUpInside)
        let postdate = post["date"] as! String!
        let now = Date()
        cell.dateLabel.text = now.offset(toDate: (postdate?.postDate())!)
        cell.textView.text = post["text"] as? String
        let currentUser = database.child("user").child((post["author"] as? String)!)
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
            let autorsprofileRef = storageRef.child("\((post["author"] as? String)!)/profileimage.png")
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
        cell.profileImage.addTarget(self, action: #selector(MainViewController.showUserData(sender:)), for: .touchUpInside)
        return cell
    }
    
    func reportPost(sender:UIButton){
        let row = sender.tag
        let alert = UIAlertController(title: "Report Post", message: "Are you sure report this Post?", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Report", style: .default, handler:{(_) in
            let newreport: Dictionary<String, Any> = [
                "reportPost":self.posts[row]["key"] as! String!,
                "reportUser":FIRAuth.auth()?.currentUser?.uid
            ]
            self.database.child("report").childByAutoId().setValue(newreport)
        })
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelaction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        let post = posts[indexPath.row]
        selectpost = post
        selectpostID = post["key"] as! String!
        if selectpost != nil {
            performSegue(withIdentifier: "viewPost",sender: nil)
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
                            _ = ToastView.showText(text: "Star", image: anImage!, imagePosition: .Left, duration:.Short)
                            self.longState = false
                        }
                    }else{
                        if self.longState == true{
                            database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/stars/").child(mykey).child("userstars").removeValue()
                            let anImage = UIImage(named: "star.gif")
                            _ = ToastView.showText(text: "UnStar", image: anImage!, imagePosition: .Left, duration:.Short)
                            self.longState = false
                        }
                    }
                })
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = tableView.contentOffset.y + tableView.frame.height
        let x = tableView.contentOffset.x
        let offset = CGPoint(x:x,y:y)
        let indexPath = tableView.indexPathForRow(at: offset)
        if indexPath?.row == number - 5{
            number = number + 1
            // SVProgressHUD.show()
            reloadData(success: {_ in})
        }
        if indexPath?.row == realnumber - 1{
            realnumber = number
            tableView.reloadData()
        }
    }
}
