//Chat function is not included in the version 1.x .

////
////  ChatUserAddViewController.swift
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
//class ChatUserAddViewController: UIViewController,UITableViewDelegate{
//    var Database = FIRDatabaseReference.init()
//    var Users = [String!]()
//    @IBOutlet var tableView :UITableView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        Database = FIRDatabase.database().reference()
//        UserSerch(uid: (FIRAuth.auth()?.currentUser!.uid)!)
//        let nib  = UINib(nibName: "ChatTableViewCell", bundle:nil)
//        self.tableView.register(nib, forCellReuseIdentifier:"ChatUserCell")
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 73
//           }
//    @IBAction func closeButton(){
//    self.navigationController?.popViewController(animated: true)
//    }
//}
