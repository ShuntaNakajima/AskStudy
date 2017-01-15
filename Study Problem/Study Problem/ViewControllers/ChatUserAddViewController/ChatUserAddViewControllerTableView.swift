//Chat function is not included in the version 1.x .

////
////  ChatUserAddViewControllerTableView.swift
////  Study Problem
////
////  Created by nakajimashunta on 2016/08/17.
////  Copyright © 2016年 ShuntaNakajima. All rights reserved.
////
//
//import UIKit
//import FirebaseStorage
//import FirebaseAuth
//import FirebaseDatabase
//
//extension ChatUserAddViewController:UITableViewDataSource{
//     @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath){
//        let user = Users[indexPath.row]
//        guard let userStr = user else{return}
//        let firebaseRoomRef = Database.child("chatroom/").childByAutoId()
//        let firebaseRoomUser = firebaseRoomRef.child("user").childByAutoId().child("user")
//        firebaseRoomUser.setValue((FIRAuth.auth()?.currentUser!.uid)!)
//         let firebaseRoomUser2 = firebaseRoomRef.child("user").childByAutoId().child("user")
//        firebaseRoomUser2.setValue(user)
//        let firebaseRef = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/chats/").childByAutoId()
//        let chatDetile = ["user":user!,"chatroom":firebaseRoomRef.key] as [String : Any]
//    firebaseRef.setValue(chatDetile)
//        let firebaseRef2 = Database.child("user/\(userStr)/chats/").childByAutoId()
//        let chatDetile2 = ["user":(FIRAuth.auth()?.currentUser!.uid)!,"chatroom":firebaseRoomRef.key] as [String : Any]
//        firebaseRef2.setValue(chatDetile2)
//        self.navigationController!.popViewController(animated: true)
//    }
//    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Users.count
//    }
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let user = Users[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserCell") as! ChatTableViewCell
//        print(Users)
//        cell.profileImage.layer.borderColor = UIColor.white.cgColor
//        cell.profileImage.layer.cornerRadius=27.5
//        cell.profileImage.layer.masksToBounds=true
//        cell.profileImage.setTitle("", for: UIControlState.normal)
//        cell.profileImage.setBackgroundImage(UIImage(named: "noimage.gif")!, for: .normal)
//        
//        let currentUser = Database.child("user").child(user!)
//        currentUser.observe(FIRDataEventType.value, with: { snapshot in
//            let chatUser = (snapshot.value! as AnyObject)["username"] as! String
//            cell.profileLabel.text = chatUser
//            }, withCancel: { (error) in
//                print(error)
//        })
//        DispatchQueue.global().async(execute: {
//            var viewImg = UIImage()
//            let storage = FIRStorage.storage()
//            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
//            let autorsprofileRef = storageRef.child("\(user)/profileimage.png")
//            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
//                if error != nil {
//                    print(error)
//                } else {
//                    viewImg = data.flatMap(UIImage.init)!
//                    DispatchQueue.main.async(execute: {
//                        cell.profileImage.setBackgroundImage(viewImg, for: UIControlState.normal)
//                        cell.layoutSubviews()
//                    });
//                }
//            }
//        });
//        return cell
//
//}
//}
