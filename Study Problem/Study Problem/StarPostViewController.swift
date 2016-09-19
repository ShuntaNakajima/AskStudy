//
//  StarPostViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/30.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class StarPostViewController:UIViewController,UIGestureRecognizerDelegate{
    var Database = FIRDatabaseReference.init()
    var selectpost : String!
    var posts = [Dictionary<String, AnyObject>]()
    var segueUser = ""
    var longState = false
    @IBOutlet var tableView :UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib  = UINib(nibName: "postTableViewCell", bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier:"PostCell")
        Database = FIRDatabase.database().reference()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(StarPostViewController.cellLongPressed(recognizer:)))
        longPressRecognizer.allowableMovement = 0
        longPressRecognizer.minimumPressDuration = 0.4
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     reload()
    }
    func reload(){
        Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("stars").observeSingleEvent(of: .value, with: { snapshot in
            self.posts = []
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key as AnyObject?
                        self.Database.child("post").child(postDictionary["userstars"] as! String!).observeSingleEvent(of:.value, with: { (snapshot:FIRDataSnapshot) in
                            if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                                let key = snapshot.key
                                postDictionary["key"] = key as AnyObject?
                                self.posts.append(postDictionary)
                            }
                            self.tableView.reloadData()
                        })
                    }
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewStarPost") {
            let vpVC: ViewpostViewController = (segue.destination as? ViewpostViewController)!
            vpVC.post = selectpost
        }
    }
    @IBAction func Post(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "PostViewController") as! PostViewController
        self.present(vc, animated: true, completion: nil)
    }
    func showUserData(sender:UIButton){
        let row = sender.tag
        segueUser = posts[row]["author"] as! String
        let UDMC: UserDetailModalViewController = (self.presentedViewController as? UserDetailModalViewController)!
        UDMC.UserKey = segueUser
    }
}
