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

extension UserDetailModalViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = myPosts[indexPath.row]
        let cell: ModalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserPostCell") as! ModalTableViewCell
        cell.replyscountLabel.text = String(post["reply"] as! Int!)
        cell.subjectLabel.text = post["subject"] as? String!
        let postdate = post["date"] as! String!
        cell.dateLabel.text = Date().offset(toDate: (postdate?.postDate())!)
        cell.textView.text = post["text"] as? String
        let currentUser = ref.child("user").child(post["author"] as! String)
        currentUser.observe(FIRDataEventType.value, with: { snapshot in
            
            let postUser = (snapshot.value! as AnyObject)["username"] as! String
            cell.profileLabel.text = postUser
            
        }, withCancel: { error in
            
            print(error)
        })
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath:IndexPath) {
        let post = myPosts[indexPath.row]
        selectedPost = post["key"] as! String
        if selectedPost != nil {
            
            performSegue(withIdentifier: "viewPost",sender: nil)
        }
    }
}
