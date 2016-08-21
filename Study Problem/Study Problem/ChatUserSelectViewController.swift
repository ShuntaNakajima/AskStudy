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
        Database.child("chatroom").child(ChatRoomId).child("chat").queryLimitedToLast(25).observeEventType(.Value, withBlock: { (snapshot) in
            self.messages = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
            if snapshots != []{
            let text = postDictionary["text"] as? String
            let sender = postDictionary["from"] as? String
            let name = postDictionary["name"] as? String
            let message = JSQMessage(senderId: sender, displayName: name, text: text)
            self.messages?.append(message)
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
        let profileimageclass = ProfileImageClass()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var viewImg = UIImage!()
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\((FIRAuth.auth()?.currentUser!.uid)!)/profileimage.png")
            autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)
                    if profileimageclass.selectFaction((FIRAuth.auth()?.currentUser!.uid)!).isEmpty{
                        dispatch_async(dispatch_get_main_queue(), {
                            profileimageclass.appendFaction((FIRAuth.auth()?.currentUser!.uid)!, img: viewImg)
                        });
                    }else{
                        let profile = profileimageclass.selectFaction((FIRAuth.auth()?.currentUser!.uid)!)
                         self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage((profile[0].image!), diameter: 60)
                    }
                }
            }
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var viewImg = UIImage!()
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\((FIRAuth.auth()?.currentUser!.uid)!)/profileimage.png")
            autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)
                    if profileimageclass.selectFaction((FIRAuth.auth()?.currentUser!.uid)!).isEmpty{
                        dispatch_async(dispatch_get_main_queue(), {
                            profileimageclass.appendFaction((FIRAuth.auth()?.currentUser!.uid)!, img: viewImg)
                        });
                    }else{
                        let profile = profileimageclass.selectFaction((FIRAuth.auth()?.currentUser!.uid)!)
                        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage((profile[0].image!), diameter: 60)
                    }
                }
            }
        });
        self.senderId = (FIRAuth.auth()?.currentUser!.uid)!
        self.senderDisplayName = (FIRAuth.auth()?.currentUser!.uid)!
        
        //吹き出しの設定
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        self.outgoingBubble = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        
        Database.child("chatroom").child(ChatRoomId).child("user").queryOrderedByChild("user").observeEventType(.Value, withBlock: { (snapshot) in
            self.messages = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        if postDictionary["uesr"] as! String! != (FIRAuth.auth()?.currentUser!.uid)!{
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                                var viewImg = UIImage!()
                                let storage = FIRStorage.storage()
                                let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
                                let autorsprofileRef = storageRef.child("\(postDictionary["uesr"] as! String!)/profileimage.png")
                                autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                                    if error != nil {
                                        print(error)
                                    } else {
                                        viewImg = data.flatMap(UIImage.init)
                                        if profileimageclass.selectFaction((postDictionary["uesr"] as! String!)!).isEmpty{
                                            dispatch_async(dispatch_get_main_queue(), {
                                                profileimageclass.appendFaction(postDictionary["uesr"] as! String!, img: viewImg)
                                            });
                                        }else{
                                            let profile = profileimageclass.selectFaction((postDictionary["uesr"] as! String!)!)
                                            self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage((profile[0].image!), diameter: 60)
                                        }
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
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        //メッセジの送信処理を完了する(画面上にメッセージが表示される)
        self.finishReceivingMessageAnimated(true)
        
        //firebaseにデータを送信、保存する
        let post1 = ["from": senderId, "name": senderDisplayName, "text":text]
        let post1Ref = Database.child("chatroom").child(ChatRoomId).child("chat").childByAutoId()
        post1Ref.setValue(post1)
         self.finishSendingMessageAnimated(true)
    }
    
    //アイテムごとに参照するメッセージデータを返す
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages?[indexPath.item]
    }
    
    //アイテムごとのMessageBubble(背景)を返す
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
    }
    
    //アイテムごとにアバター画像を返す
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    //アイテムの総数を返す
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.messages?.count)!
    }


}
