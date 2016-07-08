//
//  MainViewControllerTableViewClass.swift
//  
//
//  Created by nakajimashunta on 2016/07/07.
//
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class MainViewControllerTableViewClass:MainViewController{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! postTableViewCell
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
        let currentUser = Database.child("user").child((postDictionary!["author"] as? String)!)
        currentUser.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            let postUser = snapshot.value!.objectForKey("username") as! String
            cell.profileLabel.text = postUser
            }, withCancelBlock: { error in
                print(error.description)
        })
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
        let autorsprofileRef = storageRef.child("\((postDictionary!["author"] as? String)!)/profileimage.png")
        autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                let viewImg = data.flatMap(UIImage.init)
                let resizedSize = CGSizeMake(30, 30)
                UIGraphicsBeginImageContext(resizedSize)
                viewImg!.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
                cell.profileImage.image = viewImg
            }
        }
        return cell
    }
    override func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let post = posts[indexPath.row]
        let postDictionary = post as? Dictionary<String, AnyObject>
        selectpost = postDictionary!["key"] as! String!
        if selectpost != nil {
            performSegueWithIdentifier("viewPost",sender: nil)
        }
    }
    

}
