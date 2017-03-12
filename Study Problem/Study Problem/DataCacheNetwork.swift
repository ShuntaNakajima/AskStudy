//
//  DataCacheNetwork.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/11/20.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//
import Firebase
import SVProgressHUD
import TrueTime
import WebImage
class DataCacheNetwork{
    func loadCache(limit:Int,success:@escaping ([Dictionary<String, AnyObject>]) -> Void,loadedimage:@escaping () -> Void){
        let database = FIRDatabase.database().reference()
        var posts = [Dictionary<String, AnyObject>]()
        var photos = [Dictionary<String, AnyObject>]()
        database.child("post").queryLimited(toLast: UInt(limit)).observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                posts = []
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key as AnyObject?
                        posts.insert(postDictionary, at: 0)
                    }
                }
            }
            for j in posts{
                var aphoto=Dictionary<String, AnyObject>()
                aphoto["key"] = j["key"]
                aphoto["Photo"] = j["Photo"]
                if j["Photo"] as! Int! != 0{
                    photos.append(aphoto)
                }
            }
            success(posts)
        })
    }
    
    func loadusername(uid:String,success:@escaping (String!) -> Void){
        let database = FIRDatabase.database().reference()
        var username = String()
        let user = database.child("user").child(uid)
        user.observe(FIRDataEventType.value, with: { snapshot in
            username = (snapshot.value! as AnyObject)["username"] as! String
            success(username)
        }, withCancel: { (error) in
            print(error)
        })
    }
    
    func checkUser(client:TrueTimeClient,vc:Any,success:@escaping () -> Void){
        if FIRAuth.auth()?.currentUser != nil{
        let database = FIRDatabase.database().reference()
            SVProgressHUD.show(withStatus: NSLocalizedString("loading userstate",comment:""))
        var now = Date()
        client.fetchIfNeeded { result in
            switch result {
            case let .success(referenceTime):
                now = referenceTime.now()
                var myStatus = [Dictionary<String, AnyObject>]()
                let recentUesrsQuery = (database.child("ban").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser!.uid))
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
                    if myStatus.last?["date"] as? String != nil{
                    let date = (myStatus.last?["date"] as! String!).postDate()
                    if date.offset(toDate: now) != "Just"{
                        let storyboard = UIStoryboard(name: "BanScreenStoryboard", bundle: nil)
                        let viewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "BanScreenStoryboard")
                        (vc as AnyObject).present(viewController, animated: true, completion: nil)
                    }
                    }
                    SVProgressHUD.show(withStatus: NSLocalizedString("loading data from database",comment:""))
                    success()
                    
                })
            case let .failure(error):
                print("Error! \(error)")
            }
            }}
    }
    
    func cacheuserimage(uid:String!,success:@escaping (UIImage) -> Void){
        _ = SDWebImageManager.shared().imageCache?.queryDiskCache(forKey: uid
            , done: { (image,type: SDImageCacheType) -> Void in
                if image != nil {
                    success(image!)
                }else{
                    let storage = FIRStorage.storage()
                    let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
                    let autorsprofileRef = storageRef.child("/\(uid!)/profileimage.png")
                    autorsprofileRef.downloadURL{(URL,error) -> Void in
                        if error != nil {
                            let image = UIImage(named:"noimage.gif")
                            success(image!)
                        } else {
                            SDWebImageManager.shared().downloadImage(with: URL!,
                                                                     options: SDWebImageOptions.cacheMemoryOnly,
                                                                     progress: nil,
                                                                     completed: {(image, error, a, c, s) in
                                                                        SDWebImageManager.shared().imageCache.store(image, forKey: uid)
                                                                        success(image!)
                            })
                        }
                    }
                }
        })
}
    func cachereplayimage(post:String,uid:String,success:@escaping (UIImage) -> Void){
        _ = SDWebImageManager.shared().imageCache?.queryDiskCache(forKey: post + uid
            , done: { (image,type: SDImageCacheType) -> Void in
                if image != nil {
                    success(image!)
                }else{
                    let storage = FIRStorage.storage()
                    let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post/\(post)/reply")
                    let autorsprofileRef = storageRef.child("\(uid).png")
                    autorsprofileRef.downloadURL{(URL,error) -> Void in
                        if error != nil {
                            let image = UIImage(named:"noimage.gif")
                            success(image!)
                        } else {
                            SDWebImageManager.shared().downloadImage(with: URL!,
                                                                     options: SDWebImageOptions.cacheMemoryOnly,
                                                                     progress: nil,
                                                                     completed: {(image, error, a, c, s) in
                                                                        SDWebImageManager.shared().imageCache.store(image, forKey: post + uid)
                                                                        success(image!)
                            })
                        }
                    }
                }
        })
    }
}
