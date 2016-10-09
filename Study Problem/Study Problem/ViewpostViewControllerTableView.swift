//
//  ViewpostViewControllerTableView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/07/07.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

extension ViewpostViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if postDic.count == 0 {
            return 0
        } else{
            return self.replys.count + 2
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1{
            let itemcell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! itemTableViewCell
            itemcell.ReplycountLabel!.text = String(postDic["reply"] as! Int!)
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
            let maincell = tableView.dequeueReusableCell(withIdentifier: "postMainCell") as! PostMainTableViewCell
            if postDic["author"] as? String != nil{
                maincell.postLabel!.text = postDic["text"] as! String!
                let currentUser = Database.child("user").child(postDic["author"] as! String)
                currentUser.observe(FIRDataEventType.value, with: { snapshot in
                    maincell.usernameLabel.text = (snapshot.value! as AnyObject)["username"] as? String
                })
                maincell.profileImageView.tag = indexPath.row
                maincell.profileImageView.addTarget(self, action: #selector(ViewpostViewController.showUserData(sender:)), for: .touchUpInside)
                var viewImg = UIImage()
                let storage = FIRStorage.storage()
                let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com")
                let autorsprofileRef = storageRef.child("\((self.postDic["author"] as? String)!)/profileimage.png")
                autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        viewImg = data.flatMap(UIImage.init)!
                        maincell.profileImageView.setBackgroundImage(viewImg, for: UIControlState.normal)
                        maincell.layoutSubviews()
                    }
                }
            }
            return maincell
        }else if replys[indexPath.row - 2]["author"] as? String != FIRAuth.auth()?.currentUser!.uid{
            let replycell = tableView.dequeueReusableCell(withIdentifier: "ReplysCell") as! ReplysTableViewCell
            replycell.profileImageView.tag = indexPath.row
            replycell.profileImageView.addTarget(self, action: #selector(ViewpostViewController.showUserData(sender:)), for: .touchUpInside)
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\((self.replys[indexPath.row - 2]["author"] as? String)!)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
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
            let BestAnswer = postDic["BestAnswer"] as? String
            if BestAnswer == ""{
                replycell.setBestAnser.tag = indexPath.row - 2
                replycell.setBestAnser.addTarget(self, action: #selector(ViewpostViewController.bestAnswer(sender:)), for: .touchUpInside)
            }else{
                if postDic["BestAnswer"] as? String == replys[indexPath.row - 2]["key"] as? String{
                    replycell.setBestAnser.setTitle("✔︎", for: .normal)
                    replycell.setBestAnser.setTitleColor(UIColor.ThemeGreenThin(), for: .normal)
                }else{
                    replycell.setBestAnser.isHidden = true
                }
            }
            replycell.postLabel.text = replys[indexPath.row - 2]["text"] as? String
            let currentUser = Database.child("user").child(replys[indexPath.row - 2]["author"] as! String)
            currentUser.observe(.value, with: { (snapshot: FIRDataSnapshot) in
                replycell.usernameLabel.text! = (snapshot.value! as AnyObject)["username"] as! String
            })
            return replycell
        }else{
            let myreplycell = tableView.dequeueReusableCell(withIdentifier: "MyReplysCell") as! MyReplysTableViewCell
            myreplycell.postLabel.text = replys[indexPath.row - 2]["text"] as? String
            let currentUser = Database.child("user").child(replys[indexPath.row - 2]["author"] as! String)
            currentUser.observe(.value, with: { (snapshot: FIRDataSnapshot) in
                myreplycell.usernameLabel.text! = (snapshot.value! as AnyObject)["username"] as! String
            })
            
            myreplycell.profileImageView.tag = indexPath.row
            myreplycell.profileImageView.addTarget(self, action: #selector(ViewpostViewController.showUserData(sender:)), for: .touchUpInside)
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\((self.replys[indexPath.row - 2]["author"] as? String)!)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
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
            toreply = postDic["author"] as! String
        }else{
            toreply = replys[indexPath.row - 2]["author"] as! String
            myTextView.becomeFirstResponder()
        }
    }
}
