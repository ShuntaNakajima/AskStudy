//
//  BestAnswer.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/10/09.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//


import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import DKImagePickerController
import Photos
import AVKit

extension ViewpostViewController{
    func bestAnswer(sender:UIButton){
        let row = sender.tag
        let reply = replys[row]
        let alert = UIAlertController(title: "BestAnswer", message: "Are you sure set best answer and close this post?", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler:{(_) in
            self.Database.child("post").child(self.post).child("BestAnswer").setValue((reply["key"] as? String!)!)
        })
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelaction)
        present(alert, animated: true, completion: nil)
    }
    
}

