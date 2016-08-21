//
//  ChatViewController.swift
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

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet var tableView:UITableView!
    @IBOutlet var addUserButton:UIBarButtonItem!
    var selectedChatRoomId = String!()
    var Database = FIRDatabaseReference.init()
    var chatRoom = [Dictionary<String, AnyObject>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib  = UINib(nibName: "ChatTableViewCell", bundle:nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier:"ChatUserCell")
        tableView.delegate = self
        tableView.dataSource = self
        Database = FIRDatabase.database().reference()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("chats").queryOrderedByChild("user").observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print(snapshots)
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key
                        self.chatRoom.insert(postDictionary, atIndex: 0)
                    }
                }
                print(self.chatRoom)
                 self.tableView.reloadData()
            }
        })
    }
    @IBAction func AddUserButtonPushed(){
        let chatViewController = ChatViewController()
        self.presentViewController(chatViewController, animated: true, completion: nil)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toChatView") {
            let chatView = (segue.destinationViewController as? ChatUserSelectViewController)!
            chatView.ChatRoomId = selectedChatRoomId
        }
    }
}
