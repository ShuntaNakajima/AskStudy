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

extension MainViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post: [String: AnyObject] = posts[indexPath.row]
        
        cell.view.translatesAutoresizingMaskIntoConstraints = false
        cell.setNib(photos: post["Photo"] as! Int,key: post["key"] as! String, on:self)
        cell.replyscountLabel.text = String(post["reply"] as! Int!)
        cell.subjectLabel.text = post["subject"] as! String!
        let postdate: String = post["date"] as! String
        cell.dateLabel.text = Date().offset(toDate: postdate.postDate())
        cell.textView.text = post["text"] as? String
        let currentUserRef: FIRDatabaseReference = ref.child("user").child(post["author"] as! String)
        currentUserRef.observe(FIRDataEventType.value, with: { snapshot in
            
            let postUser: String = (snapshot.value! as AnyObject)["username"] as! String
            cell.profileLabel.text = postUser
        }, withCancel: { error in
            
            print(error.localizedDescription)
        })
        
        DispatchQueue.global().async(execute: {
            
            let storage: FIRStorage = FIRStorage.storage()
            let storageRef: FIRStorageReference = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
            let autorsprofileRef: FIRStorageReference = storageRef.child("\(post["author"] as! String)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { data, error in
                
                if error != nil {
                    
                    print("\(error?.localizedDescription)")
                } else {
                    
                    let viewImg = data.flatMap(UIImage.init)!
                    DispatchQueue.main.async(execute: {
                        
                        cell.profileImage.setBackgroundImage(viewImg, for: UIControlState.normal)
                        cell.layoutSubviews()
                    })
                }
            }
        })
        cell.profileImage.tag = indexPath.row
        cell.profileImage.addTarget(self, action: #selector(MainViewController.showUserData(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        
        let post = posts[indexPath.row]
        selectedPost = post
        selectpostID = post["key"] as! String
        performSegue(withIdentifier: "viewPost",sender: nil)
    }
    
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        
        let point = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath == nil {
        } else if recognizer.state == UIGestureRecognizerState.began  {
            if longState == false{
                longState = true
                
                let recentUesrsQuery = ref.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("stars").queryOrdered(byChild: "userstars").queryEqual(toValue: self.posts[indexPath!.row]["key"] as! String)
                
                recentUesrsQuery.observe(.value, with: { snapshot in
                    
                    var snapKey: String = ""
                    
                    if let snapshots: [FIRDataSnapshot] = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        
                        for snap in snapshots {
                            
                            snapKey = snap.key
                        }
                    }
                    if snapKey == "" {
                        
                        if self.longState {
                            
                            let newFollowChild = self.ref.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/stars/").childByAutoId().child("userstars")
                            newFollowChild.setValue(self.posts[indexPath!.row]["key"] as! String!)
                            let image: UIImage = UIImage(named: "star.gif")!
                            _ = ToastView.showText(text: "Star", image: image, imagePosition: .Left, duration: .Short)
                            self.longState = false
                        }
                    }else{
                        
                        if self.longState {
                            
                            self.ref.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/stars/").child(snapKey).child("userstars").removeValue()
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
        let offset = CGPoint(x: x, y: y)
        let indexPath = tableView.indexPathForRow(at: offset)
        if indexPath?.row == limitNumber - 1 {
            limitNumber = limitNumber + 10
            reloadData()
        }
    }
}
