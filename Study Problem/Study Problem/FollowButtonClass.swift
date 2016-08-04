//
//  FollowButtonClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/04.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FollowButtonClass: UIButton {
    var Database = FIRDatabaseReference.init()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.updateLayout()
    }
    override func awakeFromNib() {
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateLayout()
    }
    func updateLayout(){
        self.layer.cornerRadius=10
        self.layer.masksToBounds=true
    }
    func follow(uid:String!){
        Database = FIRDatabase.database().reference()
        let newFollowChild = Database.child("user/\(uid)/follower/").childByAutoId()
        newFollowChild.setValue("\((FIRAuth.auth()?.currentUser!.uid)!)")
        let mynewFollowChild = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/follow/").childByAutoId()
         mynewFollowChild.setValue("\(uid)")
    }
}
