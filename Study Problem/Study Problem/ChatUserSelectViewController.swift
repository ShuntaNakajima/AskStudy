//
//  ChatUserSelectViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/16.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import JSQMessagesViewController

class ChatUserSelectViewController: JSQMessagesViewController {
    var Database = FIRDatabaseReference.init()
    var ChatRoomId = ""
    var messages: [JSQMessage]?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    
    func setupFirebase() {
        Database.child("chatroom").child(ChatRoomId).child("chat").queryLimited(toLast: 25).observe(.value, with: { (snapshot) in
            self.messages = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
            if snapshots != []{
            let text = postDictionary["text"] as? String
            let sender = postDictionary["from"] as? String
            let name = postDictionary["name"] as? String
            let message = JSQMessage(senderId: sender, displayName: name, text: text)
            self.messages?.append(message!)
            self.finishReceivingMessage()
                        }
                    }
            }
            }
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputToolbar!.contentView!.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        Database = FIRDatabase.database().reference()
        
        //自分のsenderId, senderDisokayNameを設定
      DispatchQueue.global().async(execute: {
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\((FIRAuth.auth()?.currentUser!.uid)!)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)!
                        DispatchQueue.main.async(execute: {
                            self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: viewImg, diameter: 60)
                        });
                }
            }});
       DispatchQueue.global().async(execute: {
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\((FIRAuth.auth()?.currentUser!.uid)!)/profileimage.png")
            autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)!
                    DispatchQueue.main.async(execute: {
                        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: viewImg, diameter: 60)
                    });
                }
        }
        });
        self.senderId = (FIRAuth.auth()?.currentUser!.uid)!
        self.senderDisplayName = (FIRAuth.auth()?.currentUser!.uid)!
        
        //吹き出しの設定
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        self.outgoingBubble = bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        
        Database.child("chatroom").child(ChatRoomId).child("user").queryOrdered(byChild: "user").observe(.value, with: { (snapshot) in
            print(snapshot)
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        if postDictionary["uesr"] as! String! != (FIRAuth.auth()?.currentUser!.uid)!{
                            DispatchQueue.main.async(execute: {
                                var viewImg = UIImage()
                                let storage = FIRStorage.storage()
                                let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com")
                                let autorsprofileRef = storageRef.child("\(postDictionary["uesr"] as! String!)/profileimage.png")
                                autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                                    if error != nil {
                                        print(error)
                                    } else {
                                        viewImg = data.flatMap(UIImage.init)!
                                        DispatchQueue.main.async(execute: {
                                            self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: viewImg, diameter: 60)
                                        });
                                    }
                                }
                            });
                        }
                    }
                }
            }
        })
        //メッセージデータの配列を初期化
        self.messages = []
        setupFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sendボタンが押された時に呼ばれる
     func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        //メッセジの送信処理を完了する(画面上にメッセージが表示される)
        self.finishReceivingMessage(animated: true)
        
        //firebaseにデータを送信、保存する
        let post1 = ["from": senderId, "name": senderDisplayName, "text":text]
        let post1Ref = Database.child("chatroom").child(ChatRoomId).child("chat").childByAutoId()
        post1Ref.setValue(post1)
         self.finishSendingMessage(animated: true)
    }
    
    //アイテムごとに参照するメッセージデータを返す
  func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages?[indexPath.item]
    }
    
    //アイテムごとのMessageBubble(背景)を返す
 func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    //アイテムごとにアバター画像を返す
 func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    //アイテムの総数を返す
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.messages?.count)!
    }


}
