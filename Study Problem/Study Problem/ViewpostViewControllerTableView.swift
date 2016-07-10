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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replys.count + 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 1{
            let itemcell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! itemTableViewCell
            itemcell.ReplycountLabel!.text = String(postDic["reply"] as! Int!)
            itemcell.DateLable.text = postDic["date"] as! String!
            return itemcell
        }
        if indexPath.row == 0{
            let maincell = tableView.dequeueReusableCellWithIdentifier("postMainCell") as! PostMainTableViewCell
            if postDic["author"] as? String != nil{
                maincell.postLabel!.text = postDic["text"] as! String!
                let currentUser = Database.child("user").child(postDic["author"] as! String)
                currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                    maincell.usernameLabel.text = snapshot.value!.objectForKey("username") as! String
                })
             maincell.profileImageView.image = self.postimage
            }
            return maincell
        }else if replys[indexPath.row - 2]["author"] as? String != FIRAuth.auth()?.currentUser!.uid{
            let replycell = tableView.dequeueReusableCellWithIdentifier("ReplysCell") as! ReplysTableViewCell
            if replyImages != []{
                replycell.profileImageView.image = self.replyImages[indexPath.row - 2]
            }
            replycell.postLabel.text = replys[indexPath.row - 2]["text"] as? String
            let currentUser = Database.child("user").child(replys[indexPath.row - 2]["author"] as! String)
            currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                replycell.usernameLabel.text = snapshot.value!.objectForKey("username") as! String
            })
            return replycell
        }else{
            let myreplycell = tableView.dequeueReusableCellWithIdentifier("MyReplysCell") as! MyReplysTableViewCell
            myreplycell.postLabel.text = replys[indexPath.row - 2]["text"] as? String
            let currentUser = Database.child("user").child(replys[indexPath.row - 2]["author"] as! String)
            currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                myreplycell.usernameLabel.text = snapshot.value!.objectForKey("username") as! String
            })
            if replyImages != []{
                myreplycell.profileImageView.image = self.replyImages[indexPath.row - 2]
            }
            return myreplycell
        }
    }
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        if indexPath.row == 0{
            toreply = postDic["author"] as! String
        }else{
            toreply = replys[indexPath.row - 2]["author"] as! String
            myTextView.becomeFirstResponder()
        }
    }
}
