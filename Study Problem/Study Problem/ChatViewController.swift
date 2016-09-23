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
import DZNEmptyDataSet

class ChatViewController: UIViewController,UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource {
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
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
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
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "star.gif")
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let str = "You don't have any Chats"
        let font = UIFont.systemFont(ofSize: 14.0, weight: 2.0)
        return NSAttributedString(
            string: str,
            attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.black]
        )
    }
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        let str = "How to add Chat?"
        let font = UIFont.systemFont(ofSize: 10.0, weight: 2.0)
        return NSAttributedString(
            string: str,
            attributes: [NSFontAttributeName: font,NSForegroundColorAttributeName: UIColor.white]
        )
    }
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        let viewController:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "MainNavigationViewController")
        self.present(viewController, animated: true, completion: nil)
    }
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UINavigationBar.appearance().barTintColor
    }
}
