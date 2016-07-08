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
    @IBOutlet var tableView :UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Database = FIRDatabase.database().reference()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        Database.child("post").observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            self.posts = []
            let nib  = UINib(nibName: "postTableViewCell", bundle:nil)
            self.tableView.registerNib(nib, forCellReuseIdentifier:"PostCell")
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key
                        self.posts.insert(postDictionary, atIndex: 0)
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! postTableViewCell
        return cell
    }
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
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
