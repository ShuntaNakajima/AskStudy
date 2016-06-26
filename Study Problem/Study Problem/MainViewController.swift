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
            
            // The snapshot is a current look at our jok
          
            
            print(snapshot.value)
            
            self.posts = []
            let nib  = UINib(nibName: "postTableViewCell", bundle:nil)
            self.tableView.registerNib(nib, forCellReuseIdentifier:"PostCell")
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                
                for snap in snapshots {
                    
                    // Make our jokes array for the tableView.
                    
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        
                        
                        // Items are returned chronologically, but it's more fun with the newest jokes first.
                        //            Dictionary<String, AnyObject> = [
                        //                "text": postText!,
                        //                "subject": subjectTextfield.text!,
                        //                "replay":0,
                        //                "author": currentUserId
                        //            ]
                        //postディクショなりの内容
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
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        // We are using a custom cell.
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! postTableViewCell
        
        // Send the single joke to configureCell() in JokeCellTableViewCell.
        let postDictionary = post as? Dictionary<String, AnyObject>
        
        cell.replyscountLabel.text = String(postDictionary!["reply"] as! Int!)
        cell.subjectLabel.text = postDictionary!["subject"] as? String!
        let postdate = postDictionary!["date"] as! String!
        let date_formatter: NSDateFormatter = NSDateFormatter()
        date_formatter.locale     = NSLocale(localeIdentifier: "ja")
        date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let change_date:NSDate = date_formatter.dateFromString(postdate)!
        let now = NSDate()
        cell.dateLabel.text = now.offset(change_date)
        cell.textView.text = postDictionary!["text"] as? String
        let userdata = UserData().readimage((postDictionary!["author"] as? String)!)
        if userdata.0 == "noset"{
            let currentUser = Database.child("user").child((postDictionary!["author"] as? String)!)
            
            currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
                print(snapshot)
                
                let postUser = snapshot.value!.objectForKey("username") as! String
                
                
                print("Username: \(postUser)")
                let storage = FIRStorage.storage()
                let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
                let autorsprofileRef = storageRef.child("\((postDictionary!["author"] as? String)!)/profileimage.png")
                autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                    if error != nil {
                        // Uh-oh, an error occurred!
                        print(error)
                    } else {
                        
                        
                        let viewImg = data.flatMap(UIImage.init)
                        let resizedSize = CGSizeMake(30, 30)
                        UIGraphicsBeginImageContext(resizedSize)
                        viewImg!.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
                        //                    var sv = cell.profileImage.superview!
                        //                    sv.removeConstraints(sv.constraints)
                        
                        
                        cell.profileImage.image = viewImg
                        let data = UserData()
                        data.id = (postDictionary!["author"] as! String)
                        data.username =  postUser
                        
                        if let imagedata = UIImagePNGRepresentation(viewImg!) {
                            data.image = imagedata
                        }
                        
                        data.setimage()
                    }
                }
                cell.profileLabel.text = postUser
                
                }, withCancelBlock: { error in
                    print(error.description)
            })
        }else{
            let image: UIImage? = UIImage(data: userdata.2)
            cell.profileLabel.text = userdata.1
            cell.profileImage.image = image
            
        }
        
        return cell
        
        
        
    }
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let post = posts[indexPath.row]
        let postDictionary = post as? Dictionary<String, AnyObject>
        selectpost = postDictionary!["key"] as! String!
        
        if selectpost != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            performSegueWithIdentifier("viewPost",sender: nil)
        }
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "viewPost") {
            let vpVC: ViewpostViewController = (segue.destinationViewController as? ViewpostViewController)!
            // SubViewController のselectedImgに選択された画像を設定する
            vpVC.post = selectpost
        }
    }
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        return 175
    //    }
    
    @IBAction func test(){
        // print("adfsdadfsdafs")
        self.slideMenuController()?.openLeft()
    }
    
    
}
