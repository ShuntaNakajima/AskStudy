//
//  ChatViewControllerTableView.swift
//  
//
//  Created by nakajimashunta on 2016/08/16.
//
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

extension ChatViewController{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoom.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = chatRoom[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatUserCell") as! ChatTableViewCell
        let currentUser = Database.child("user").child((user["user"] as? String)!)
        currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            let chatUser = snapshot.value!.objectForKey("username") as! String
            cell.profileLabel.text = chatUser
            }, withCancelBlock: { error in
                print(error.description)
        })
        let profileimageclass = ProfileImageClass()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var viewImg = UIImage!()
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\((user["user"] as? String)!)/profileimage.png")
            autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)
                    if profileimageclass.selectFaction((user["user"] as? String)!).isEmpty{
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.profileImage.setBackgroundImage(viewImg!, forState: UIControlState.Normal)
                            cell.layoutSubviews()
                            profileimageclass.appendFaction((user["user"] as? String)!, img: viewImg)
                        });
                    }else{
                        let profile = profileimageclass.selectFaction((user["user"] as? String)!)
                        cell.profileImage.setBackgroundImage(profile[0].image!, forState: UIControlState.Normal)
                        cell.layoutSubviews()
                    }
                }
            }
        });
        return cell
    }
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
    selectedChatRoomId = chatRoom[indexPath.row]["chatroom"] as? String!
         performSegueWithIdentifier("toChatView", sender: self)
    }
}
