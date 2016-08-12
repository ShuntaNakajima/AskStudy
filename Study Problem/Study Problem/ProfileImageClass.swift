//
//  ProfileImageClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/12.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
var profileImageDec = [(uid:String!,image:UIImage!)]()
class ProfileImageClass{
    var timer:NSTimer? = nil
    func startReload(){
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(180, target: self, selector:#selector(ProfileImageClass.reloadImage(_:)), userInfo: nil,repeats: true)
        }
    }
    func deleteFaction(Faction: String){
        profileImageDec = profileImageDec.filter({$0.uid != Faction})
    }
    func selectFaction(Faction: String) -> [(uid:String!,image:UIImage!)] {
        let faction:[(uid:String!,image:UIImage!)] = profileImageDec.filter({$0.uid == Faction})
        return faction
    }
    func appendFaction(Faction: String!,img:UIImage!){
        profileImageDec.append(uid:Faction,image:img)
    }
    @objc func reloadImage(timer: NSTimer){
        for (uid, img) in profileImageDec{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var viewImg = UIImage()
            let storage = FIRStorage.storage()
            let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
            let profileRef = storageRef.child("\(uid)/profileimage.png")
            profileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
                if error != nil {
                    print(error)
                } else {
                    viewImg = data.flatMap(UIImage.init)!
                    dispatch_async(dispatch_get_main_queue(), {
                       self.appendFaction(uid, img: viewImg)
                    });
                }
            }
        });
        }
    }
    func stopTimer(){
        if timer != nil {
            timer?.invalidate(); timer = nil
        }
    }
}
