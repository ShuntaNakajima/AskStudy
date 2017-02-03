//
//  MainViewControllerBanExtension.swift
//  Study Problem
//
//  Created by nakajimashunta on 2017/01/15.
//  Copyright © 2017年 ShuntaNakajima. All rights reserved.
//

import Foundation
import Firebase
import TrueTime
import SVProgressHUD

extension MainViewController{
    func CheckUser(){
        SVProgressHUD.show(withStatus: "loading userstate")
        var now = Date()
        client.fetchIfNeeded { result in
            switch result {
            case let .success(referenceTime):
                now = referenceTime.now()
                var myStatus = [Dictionary<String, AnyObject>]()
                let recentUesrsQuery = (self.database.child("ban").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser!.uid))
                recentUesrsQuery.observe(.value, with: { snapshot in
                    
                    if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                        for snap in snapshots{
                            if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                                let key = snap.key
                                postDictionary["key"] = key as AnyObject?
                                myStatus.append(postDictionary)
                            }
                        }
                    }
                    let date = (myStatus.last?["date"] as! String!).postDate()
                    if date.offset(toDate: now) != "Just"{
                        let storyboard = UIStoryboard(name: "BanScreenStoryboard", bundle: nil)
                        let viewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "BanScreenStoryboard")
                        self.present(viewController, animated: true, completion: nil)
                    }
                    SVProgressHUD.show(withStatus: "loading data from database")
                    DataCacheNetwork.loadCache(limit: self.number, success: {posts in
                        self.posts = posts
                        SVProgressHUD.dismiss()
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                    })
                })
            case let .failure(error):
                print("Error! \(error)")
            }
        }
    }
}
