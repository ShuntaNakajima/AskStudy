//
//  DataCacheNetwork.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/11/20.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//
import Firebase
import WebImage
import SVProgressHUD
import TrueTime
class DataCacheNetwork{
    func loadCache(limit:Int,success:@escaping ([Dictionary<String, AnyObject>]) -> Void){
        let database = FIRDatabase.database().reference()
        var posts = [Dictionary<String, AnyObject>]()
        var photos = [Dictionary<String, AnyObject>]()
        var imagePhotos = [URL]()
        var pass = [String]()
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
            for i in photos{
                let count = i["Photo"] as? Int!
                for j in 0...count! - 1{
                    let storage = FIRStorage.storage()
                    let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post")
                    let autorsprofileRef = storageRef.child("\(i["key"]!)/\(j).png")
                    autorsprofileRef.downloadURL{(URL,error) -> Void in
                        if error != nil {
                            print(error)
                        } else {
                            imagePhotos.append(URL!)
                            pass.append("\(i["key"]!)/\(j)")
                        }
                        for (index,url) in imagePhotos.enumerated(){
                            SDWebImageManager.shared().downloadImage(with: url,
                                                                     options: SDWebImageOptions.cacheMemoryOnly,
                                                                     progress: nil,
                                                                     completed: {(image, error, a, c, s) in
                                                                        SDWebImageManager.shared().imageCache.store(image, forKey: pass[index])
                            })
                        }
                        success(posts)
                    }
                }
            }
            success(posts)
        })
    }
    
    func loadusername(uid:String!) -> String!{
        let database = FIRDatabase.database().reference()
        var username = String()
        let user = database.child("user").child(uid)
        user.observe(FIRDataEventType.value, with: { snapshot in
            username = (snapshot.value! as AnyObject)["username"] as! String
        }, withCancel: { (error) in
            print(error)
        })
        return username
    }
    
    func checkUser(client:TrueTimeClient,vc:Any,success:@escaping () -> Void){
        let database = FIRDatabase.database().reference()
        SVProgressHUD.show(withStatus: "loading userstate")
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
                    let date = (myStatus.last?["date"] as! String!).postDate()
                    if date.offset(toDate: now) != "Just"{
                        let storyboard = UIStoryboard(name: "BanScreenStoryboard", bundle: nil)
                        let viewController:UIViewController = storyboard.instantiateViewController(withIdentifier: "BanScreenStoryboard")
                        (vc as AnyObject).present(viewController, animated: true, completion: nil)
                    }
                    SVProgressHUD.show(withStatus: "loading data from database")
                    success()
                })
            case let .failure(error):
                print("Error! \(error)")
            }
        }
    }
}
