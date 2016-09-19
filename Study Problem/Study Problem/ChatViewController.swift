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

class ChatViewController: UIViewController,UITableViewDelegate {
    @IBOutlet var tableView:UITableView!
    @IBOutlet var addUserButton:UIBarButtonItem!
    var selectedChatRoomId = String()
    var Database = FIRDatabaseReference.init()
    var chatRoom = [Dictionary<String, AnyObject>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib  = UINib(nibName: "ChatTableViewCell", bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier:"ChatUserCell")
        tableView.delegate = self
        tableView.dataSource = self
        Database = FIRDatabase.database().reference()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("chats").queryOrdered(byChild: "user").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                print(snapshots)
                self.chatRoom = []
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key as AnyObject?
                        self.chatRoom.insert(postDictionary, at: 0)
                    }
                }
                print(self.chatRoom)
                 self.tableView.reloadData()
            }
        })
    }
    @IBAction func AddUserButtonPushed(){
        let chatViewController = ChatViewController()
        self.present(chatViewController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UINavigationBar.appearance().barTintColor
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toChatView") {
            let chatView = (segue.destination as? ChatUserSelectViewController)!
            chatView.ChatRoomId = selectedChatRoomId
        }
    }
}
