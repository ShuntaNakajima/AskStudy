//
//  ViewpostViewControllerTableView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/07/07.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension ViewpostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if postDic.count == 0 {
            return 0
        }else {
            return self.replies.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 1{
            
            let itemcell: ItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemTableViewCell
            itemcell.DateLable.text = postDic["date"] as! String!
         let BestAnswer = postDic["BestAnswer"] as? String
            if BestAnswer == ""{
                itemcell.StateLabel.text = "open"
            }else{
                itemcell.StateLabel.text = "closed"
            }
            return itemcell
        }
        if indexPath.row == 0{
            
            let cell: PostTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
            let postDictionary = postDic
            for i in cell.view.subviews{
                i.removeFromSuperview()
            }
            cell.replyscountLabel.text = String(postDictionary["reply"] as! Int!)
            cell.subjectLabel.text = postDictionary["subject"] as? String!
            let postdate = postDictionary["date"] as! String!
            cell.dateLabel.text = Date().offset(toDate: (postdate?.postDate())!)
            cell.mainCellLabel.text = postDictionary["text"] as? String
            let currentUser = ref.child("user").child((postDictionary["author"] as? String)!)
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
                let autorsprofileRef = storageRef.child("\((postDictionary["author"] as? String)!)/profileimage.png")
                autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                    if error != nil {
                        print("\(error)")
                    } else {
                        viewImg = data.flatMap(UIImage.init)!
                        DispatchQueue.main.async(execute: {
                            cell.profileImage.setBackgroundImage(viewImg, for: UIControlState.normal)
                            cell.layoutSubviews()
                        })
                    }
                }
            })
            cell.view.translatesAutoresizingMaskIntoConstraints = false
            cell.setNib(photos: postDictionary["Photo"] as! Int,key:postDictionary["key"] as! String,on:self)
            cell.profileImage.tag = indexPath.row
            cell.profileImage.addTarget(self, action: #selector(MainViewController.showUserData(sender:)), for: .touchUpInside)
            return cell
            
        }else if replies[indexPath.row - 2]["author"] as? String != FIRAuth.auth()?.currentUser!.uid {
            
            let replycell = tableView.dequeueReusableCell(withIdentifier: "ReplysCell") as! ReplysTableViewCell
            replycell.profileImageView.tag = indexPath.row
            replycell.profileImageView.addTarget(self, action: #selector(ViewpostViewController.showUserData(sender:)), for: .touchUpInside)
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
            let autorsprofileRef = storageRef.child("\((self.replies[indexPath.row - 2]["author"] as? String)!)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { data, error in
                if error != nil {
                    
                    print("\(error)")
                } else {
                    
                    viewImg = data.flatMap(UIImage.init)!
                    replycell.profileImageView.setBackgroundImage(viewImg, for: UIControlState.normal)
                    replycell.layoutSubviews()
                }
            }
            if postDic["author"] as? String == FIRAuth.auth()?.currentUser!.uid{
                replycell.setBestAnser.isHidden = false
            }else{
                replycell.setBestAnser.isHidden = true
            }
            let bestAnswer = postDic["BestAnswer"] as? String
            if bestAnswer == ""{
                replycell.setBestAnser.tag = indexPath.row - 2
                replycell.setBestAnser.addTarget(self, action: #selector(bestAnswer(sender:)), for: .touchUpInside)
            }else{
                if postDic["BestAnswer"] as? String == replies[indexPath.row - 2]["key"] as? String{
                    replycell.setBestAnser.setTitle("✔︎", for: .normal)
                    replycell.setBestAnser.setTitleColor(UIColor.themeGreenThin(), for: .normal)
                }else{
                    replycell.setBestAnser.isHidden = true
                }
            }
            replycell.postLabel.text = replies[indexPath.row - 2]["text"] as? String
            let currentUser = ref.child("user").child(replies[indexPath.row - 2]["author"] as! String)
            currentUser.observe(.value, with: { (snapshot: FIRDataSnapshot) in
                replycell.usernameLabel.text! = (snapshot.value! as AnyObject)["username"] as! String
            })
            return replycell
            
        }else{
            
            let myreplycell: MyReplysTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MyReplysCell") as! MyReplysTableViewCell
            myreplycell.postLabel.text = replies[indexPath.row - 2]["text"] as? String
            let currentUser = ref.child("user").child(replies[indexPath.row - 2]["author"] as! String)
            currentUser.observe(.value, with: { snapshot in
                myreplycell.usernameLabel.text! = (snapshot.value! as AnyObject)["username"] as! String
            })
            
            myreplycell.profileImageView.tag = indexPath.row
            myreplycell.profileImageView.addTarget(self, action: #selector(showUserData(sender:)), for: .touchUpInside)
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
            let autorsprofileRef = storageRef.child("\((self.replies[indexPath.row - 2]["author"] as? String)!)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { data, error in
                if error != nil {
                    print("\(error)")
                }else{
                    viewImg = data.flatMap(UIImage.init)!
                    myreplycell.profileImageView.setBackgroundImage(viewImg, for: UIControlState.normal)
                    myreplycell.layoutSubviews()
                }}
            return myreplycell
        }
    }
    
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1{
            
        }else if indexPath.row == 0{
            
            toReply = postDic["author"] as! String
        }else{
            
            toReply = replies[indexPath.row - 2]["author"] as! String
            textView.becomeFirstResponder()
        }
    }
}
