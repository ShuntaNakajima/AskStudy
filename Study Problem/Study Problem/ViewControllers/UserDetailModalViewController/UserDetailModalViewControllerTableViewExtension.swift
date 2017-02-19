//
//  UserDetailModalViewControllerTableViewExtension.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/10.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import UIKit
import Firebase
extension UserDetailModalViewController:UITableViewDelegate,UITableViewDataSource{
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mypost.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = mypost[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPostCell") as! ModalTableViewCell
        let postDictionary = post
        cell.replyscountLabel.text = String(postDictionary["reply"] as! Int!)
        cell.subjectLabel.text = postDictionary["subject"] as? String!
        let postdate = postDictionary["date"] as! String!
        let now = Date()
        cell.dateLabel.text = now.offset(toDate: (postdate?.postDate())!)
        cell.textView.text = postDictionary["text"] as? String
        let currentUser = database.child("user").child((postDictionary["author"] as? String)!)
        currentUser.observe(FIRDataEventType.value, with: { snapshot in
            let postUser = (snapshot.value! as AnyObject)["username"] as! String
            cell.profileLabel.text = postUser
        }, withCancel: { (error) in
            print(error)
        })
        return cell
    }
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        let post = mypost[indexPath.row]
        let postDictionary = post
        selectpost = postDictionary["key"] as! String!
        if selectpost != nil {
            performSegue(withIdentifier: "viewPost",sender: nil)
        }
    }
}
