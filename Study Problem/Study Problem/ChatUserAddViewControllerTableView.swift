//
//  ChatUserAddViewControllerTableView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/17.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

extension ChatUserAddViewController{
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let user = Users[indexPath.row]
        let firebaseRoomRef = Database.child("chatroom/").childByAutoId()
        let firebaseRoomUser = firebaseRoomRef.child("user").childByAutoId().child("user")
        firebaseRoomUser.setValue((FIRAuth.auth()?.currentUser!.uid)!)
         let firebaseRoomUser2 = firebaseRoomRef.child("user").childByAutoId().child("user")
        firebaseRoomUser2.setValue(user)
        let firebaseRef = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/chats/").childByAutoId()
        let chatDetile = ["user":user,"chatroom":firebaseRoomRef.key]
    firebaseRef.setValue(chatDetile)
        let firebaseRef2 = Database.child("user/\(user)/chats/").childByAutoId()
        let chatDetile2 = ["user":(FIRAuth.auth()?.currentUser!.uid)!,"chatroom":firebaseRoomRef.key]
        firebaseRef2.setValue(chatDetile2)
        self.navigationController?.popViewControllerAnimated(true)
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Users.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = Users[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatUserCell") as! ChatTableViewCell
        print(Users)
        cell.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        cell.profileImage.layer.cornerRadius=27.5
        cell.profileImage.layer.masksToBounds=true
        cell.profileImage.setTitle("", forState: UIControlState.Normal)
        cell.profileImage.setBackgroundImage(UIImage(named: "noimage.gif")!, forState: .Normal)

        let currentUser = Database.child("user").child(user)
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
            let autorsprofileRef = storageRef.child("\(user)/profileimage.png")
            autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)
                    if profileimageclass.selectFaction(user).isEmpty{
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.profileImage.setBackgroundImage(viewImg!, forState: UIControlState.Normal)
                            cell.layoutSubviews()
                            profileimageclass.appendFaction(user, img: viewImg)
                        });
                    }else{
                        let profile = profileimageclass.selectFaction(user)
                        cell.profileImage.setBackgroundImage(profile[0].image!, forState: UIControlState.Normal)
                        cell.layoutSubviews()
                    }
                }
            }
        });
        return cell

}
}
