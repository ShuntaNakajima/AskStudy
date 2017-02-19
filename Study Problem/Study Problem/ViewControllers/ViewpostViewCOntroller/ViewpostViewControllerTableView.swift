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
            let itemcell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemTableViewCell
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
            let postDictionary = postDic
            for i in cell.view.subviews{
                i.removeFromSuperview()
            }
            cell.replyscountLabel.text = String(postDictionary["reply"] as! Int!)
            cell.subjectLabel.text = postDictionary["subject"] as? String!
            let postdate = postDictionary["date"] as! String!
            let now = Date()
            cell.dateLabel.text = now.offset(toDate: (postdate?.postDate())!)
            cell.textView.text = postDictionary["text"] as? String
            cell.menuButton.tag = indexPath.row
            cell.menuButton.addTarget(self, action: #selector(ViewpostViewController.option(sender:)), for: .touchUpInside)
            network.loadusername(uid: (postDictionary["author"] as? String)!,success: {username in
                cell.profileLabel.text = username
            })
            network.cacheuserimage(uid: (postDictionary["author"] as? String)!, success: {image in
                cell.profileImage.setBackgroundImage(image, for: UIControlState.normal)
                cell.layoutSubviews()
            })
            cell.view.translatesAutoresizingMaskIntoConstraints = false
            cell.setNib(photos: postDictionary["Photo"] as! Int,key:postDictionary["key"] as! String,on:self)
            cell.profileImage.tag = indexPath.row
            cell.profileImage.addTarget(self, action: #selector(MainViewController.showUserData(sender:)), for: .touchUpInside)
            return cell
        }else if replys[indexPath.row - 2]["photos"] as! Int == 1{
            let replycell = tableView.dequeueReusableCell(withIdentifier: "ReplyswithphotoCell") as! ReplaywithphotoTableViewCell
            replycell.profileImageView.tag = indexPath.row
            replycell.profileImageView.addTarget(self, action: #selector(ViewpostViewController.showUserData(sender:)), for: .touchUpInside)
            network.loadusername(uid: replys[indexPath.row - 2]["author"] as! String,success: {username in
                replycell.usernameLabel.text = username
            })
            network.cacheuserimage(uid: replys[indexPath.row - 2]["author"] as! String, success: {image in
                replycell.profileImageView.setBackgroundImage(image, for: UIControlState.normal)
                replycell.layoutSubviews()
            })
            replycell.setimage(vc: self, post: postDic["key"] as! String, uid: replys[indexPath.row - 2]["key"] as! String)
            if postDic["author"] as? String == FIRAuth.auth()?.currentUser!.uid{
                replycell.setBestAnser.isHidden = false
            }else{
                replycell.setBestAnser.isHidden = true
            }
            let BestAnswer = postDic["BestAnswer"] as? String
            if replys[indexPath.row - 2]["author"] as? String == FIRAuth.auth()?.currentUser!.uid{
                replycell.setBestAnser.isHidden = true
            }
            else if BestAnswer == ""{
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
            return replycell
        }else{
            let replycell = tableView.dequeueReusableCell(withIdentifier: "ReplysCell") as! ReplysTableViewCell
            replycell.profileImageView.tag = indexPath.row
            replycell.profileImageView.addTarget(self, action: #selector(ViewpostViewController.showUserData(sender:)), for: .touchUpInside)
            network.loadusername(uid: replys[indexPath.row - 2]["author"] as! String,success: {username in
                replycell.usernameLabel.text = username
            })
            network.cacheuserimage(uid: replys[indexPath.row - 2]["author"] as! String, success: {image in
                replycell.profileImageView.setBackgroundImage(image, for: UIControlState.normal)
                replycell.layoutSubviews()
            })
            if postDic["author"] as? String == FIRAuth.auth()?.currentUser!.uid{
                replycell.setBestAnser.isHidden = false
            }else{
                replycell.setBestAnser.isHidden = true
            }
            let BestAnswer = postDic["BestAnswer"] as? String
            if replys[indexPath.row - 2]["author"] as? String == FIRAuth.auth()?.currentUser!.uid{
            replycell.setBestAnser.isHidden = true
            }
            else if BestAnswer == ""{
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
            return replycell
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
