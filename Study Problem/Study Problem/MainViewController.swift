//
//  MainViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//
import UIKit
import SlideMenuControllerSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import RealmSwift

class MainViewController: UIViewController {
    var Database = FIRDatabaseReference.init()
    var selectpost : String!
    var posts = [Dictionary<String, AnyObject>]()
    var images = [UIImage]()
    @IBOutlet var tableView :UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib  = UINib(nibName: "postTableViewCell", bundle:nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier:"PostCell")
        Database = FIRDatabase.database().reference()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        Database.child("post").observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.images = []
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key
                        self.posts.insert(postDictionary, atIndex: 0)
                    }
                    self.tableView.reloadData()
                }
                for i in self.posts{
                    let storage = FIRStorage.storage()
                    let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
                    let autorsprofileRef = storageRef.child("\((i["author"] as? String)!)/profileimage.png")
                    autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                        if error != nil {
                            print(error)
                        } else {
                            let viewImg = data.flatMap(UIImage.init)
                            self.images.append(viewImg!)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "viewPost") {
            let vpVC: ViewpostViewController = (segue.destinationViewController as? ViewpostViewController)!
            vpVC.post = selectpost
        }
    }
    @IBAction func test(){
        self.slideMenuController()?.openLeft()
    }
}
