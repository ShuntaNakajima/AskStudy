//
//  PostMainTableViewCell.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/16.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import WebImage
import JTSImageViewController
import Firebase

class PostMainTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView : MainCellUiimageView!
    @IBOutlet var usernameLabel:UILabel!
    @IBOutlet var postLabel:UILabel!
    @IBOutlet var imageview:UIButton!
    
    var viewcontroller = UIViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
//    
//    func setImage(postkey:String,replykey:String,on:UIViewController){
//        viewcontroller = on
//            SDWebImageManager.shared().imageCache?.queryDiskCache(forKey: postkey
//                , done: { (image,type: SDImageCacheType) -> Void in
//                    if image != nil{
//                        self.imageview.setBackgroundImage(image, for: .normal)
//                    }else{
//                        let storage = FIRStorage.storage()
//                        let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post/").child(postkey).child("reply")
//                        let autorsprofileRef = storageRef.child("\(replykey).png")
//                        autorsprofileRef.downloadURL{(URL,error) -> Void in
//                            if error != nil {
//                                print(error)
//                            } else {
//                                SDWebImageManager.shared().downloadImage(with: URL!,
//                                                                         options: SDWebImageOptions.cacheMemoryOnly,
//                                                                         progress: nil,
//                                                                         completed: {(image, error, a, c, s) in
//                                                                            SDWebImageManager.shared().imageCache.store(image, forKey: postkey)
//                                                                            self.imageview.setBackgroundImage(image, for: .normal)
//                                })
//                            }
//                        }
//                    }
//                self.imageview.addTarget(self, action: #selector(self.showImage(index:)), for: .touchUpInside)
//            })
//    }
    func showImage(index:UIImageView){
        let imageInfo = JTSImageInfo()
        imageInfo.image = imageview.currentBackgroundImage
        imageInfo.referenceRect = self.imageview.frame
        imageInfo.referenceView = self.imageview.superview
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
        imageViewer?.show(from: viewcontroller, transition: JTSImageViewControllerTransition.fromOriginalPosition)
    }
    
}
