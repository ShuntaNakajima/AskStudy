//Chat function is not included in the version 1.x .

////
////  ChatViewControllerTableView.swift
////  
////
////  Created by nakajimashunta on 2016/08/16.
////
////
//
//
//import UIKit
//import Firebase
//import FirebaseAuth
//import FirebaseStorage
//import FirebaseDatabase
//
//extension ChatViewController:UITableViewDataSource{
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chatRoom.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let user = chatRoom[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserCell") as! ChatTableViewCell
//        let currentUser = Database.child("user").child((user["user"] as? String)!)
//        currentUser.observe(FIRDataEventType.value, with: { snapshot in
//            let chatUser = (snapshot.value! as AnyObject)["username"] as! String
//            cell.profileLabel.text = chatUser
//            }, withCancel: {(error) in
//                print(error)
//        })
//        DispatchQueue.global().async(execute:  {
//            var viewImg = UIImage()
//            let storage = FIRStorage.storage()
//            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
//            let autorsprofileRef = storageRef.child("\((user["user"] as? String)!)/profileimage.png")
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
//            }})
//        return cell
//    }
//    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
//    selectedChatRoomId = (chatRoom[indexPath.row]["chatroom"] as? String!)!
//         performSegue(withIdentifier: "toChatView", sender: self)
//    }
//}
