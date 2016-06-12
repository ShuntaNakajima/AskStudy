//
//  ImageClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/06/12.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import RealmSwift



class UserData: Object {
    dynamic var id:String = ""
    dynamic var username:String = ""
    dynamic var image = NSData()

    
    func setimage(){
        let realm = try! Realm()
        try! realm.write() {
            realm.add(self)
        }
    }
   
    
    func readimage(user:String!) -> (String!,String!, NSData){
        let realm = try! Realm()
        if let user = realm.objects(UserData).filter("id == '\(user)'").first{
            
            return (user.id,user.username,user.image)
        }else{
            var noimage = NSData()
            if let imagedata = UIImagePNGRepresentation(UIImage(named: "noimage.gif")!) {
                noimage = imagedata
            }
            return ("noset","none",noimage)
        }
    }
}

