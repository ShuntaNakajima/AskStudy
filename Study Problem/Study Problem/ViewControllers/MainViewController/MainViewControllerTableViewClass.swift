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
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        for i in cell.view.subviews{
            i.removeFromSuperview()
        }
        cell.view.translatesAutoresizingMaskIntoConstraints = false
        cell.setNib(photos: post["Photo"] as! Int,key:post["key"] as! String,on:self)
        cell.replyscountLabel.text = String(post["reply"] as! Int!)
        cell.subjectLabel.text = post["subject"] as? String!
        cell.menuButton.tag = indexPath.row
        cell.menuButton.addTarget(self, action: #selector(MainViewController.option(sender:)), for: .touchUpInside)
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
        cell.profileImage.tag = indexPath.row
        cell.profileImage.addTarget(self, action: #selector(MainViewController.showUserData(sender:)), for: .touchUpInside)
        return cell
    }
    func option(sender:UIButton){
                let row = sender.tag
        if posts[row]["author"] as? String == FIRAuth.auth()?.currentUser!.uid{
        let alert = UIAlertController(title: NSLocalizedString("Option", comment: ""), message: NSLocalizedString("Are you sure report this Post?", comment: ""), preferredStyle: UIAlertControllerStyle.actionSheet)
        let action = UIAlertAction(title: NSLocalizedString("Report", comment: ""), style: .default, handler:{(_) in
self.reportPost(row: row)
        })
        let delete = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default, handler:{(_) in
            self.delete(row: row)
        })
        let cancelaction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(delete)
        alert.addAction(cancelaction)
        present(alert, animated: true, completion: nil)
        }else{
            reportPost(row: row)
        }
    }
    func reportPost(row:Int){
        let alert = UIAlertController(title: NSLocalizedString("Report Post", comment: ""), message: NSLocalizedString("Are you sure report this Post?", comment: ""), preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: NSLocalizedString("Report", comment: ""), style: .default, handler:{(_) in
            let newreport: Dictionary<String, Any> = [
                "reportPost":self.posts[row]["key"] as! String!,
                "reportUser":FIRAuth.auth()?.currentUser?.uid as Any
            ]
            self.database.child("report").childByAutoId().setValue(newreport)
        })
        let cancelaction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelaction)
        present(alert, animated: true, completion: nil)
    }
    func delete(row:Int){
        let alert = UIAlertController(title: NSLocalizedString("Delete",comment:""), message: NSLocalizedString("Are you sure delete this Post?",comment:""), preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: NSLocalizedString("Delete",comment:""), style: .default, handler:{(_) in
            self.database.child("post").child(self.posts[row]["key"] as! String!).removeValue()
        })
        let cancelaction = UIAlertAction(title: NSLocalizedString("Cancel",comment:""), style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelaction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        let post = posts[indexPath.row]
        selectpost = post
        selectpostID = post["key"] as! String!
            performSegue(withIdentifier: "viewPost",sender: nil)
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
                            let anImage = UIImage(named: "star.gif")
                            _ = ToastView.showText(text: NSLocalizedString("UnStar",comment:""), image: anImage!, imagePosition: .Left, duration:.Short)
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
            reloadData(success: {_ in})
        }
        if indexPath?.row == realnumber - 2{
            realnumber = number
            tableView.reloadData()
        }
    }
}
