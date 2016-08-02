//
//  UserDetailModalViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/02.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class UserDetailModalViewController: UIViewController {
var UserKey = ""
    @IBOutlet var ProfileImageButton:UIButton!
    @IBOutlet var ProfileLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(UserKey)
        ProfileImageButton.layer.cornerRadius=40
        ProfileImageButton.layer.masksToBounds=true
        ProfileImageButton.setTitle("", forState: UIControlState.Normal)
        ProfileImageButton.setBackgroundImage(UIImage(named: "noimage.gif")!, forState: .Normal)
         let Database = FIRDatabase.database().reference()
        let User = Database.child("user").child(UserKey)
        User.observeEventType(FIRDataEventType.Value, withBlock: { snapshot in
            let postUser = snapshot.value!.objectForKey("username") as! String
            self.ProfileLabel.text = postUser
            }, withCancelBlock: { error in
                print(error.description)
        })
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var viewImg = UIImage!()
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
            let autorsprofileRef = storageRef.child("\(self.UserKey)/profileimage.png")
            autorsprofileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)
                    dispatch_async(dispatch_get_main_queue(), {
                self.ProfileImageButton.setBackgroundImage(viewImg!, forState: .Normal)
                    });
                }
            }
        });
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
