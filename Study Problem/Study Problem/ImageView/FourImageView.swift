//
//  FourImageView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/10/23.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import JTSImageViewController
import WebImage
import Firebase

class FourView: UIView {
    @IBOutlet var imageViews:[UIButton]!
    var delegate:ShowImageDelegate!
    var viewcontroller:UIViewController!
    var images = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func instance() -> FourView{
        return UINib(nibName: "FourImageView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! FourView
    }
    func cancelReload(){
        for (index,image) in images.enumerated(){
            imageViews[index].sd_cancelImageLoad(for: .normal)
        }
    }
    func setImage(images:[String],on:UIViewController){
        viewcontroller = on
        self.images = images
        for (index,imagestring) in images.enumerated(){
            imageViews[index].imageView?.contentMode = UIViewContentMode.scaleAspectFill
            SDWebImageManager.shared().imageCache.queryDiskCache(forKey: imagestring
                , done: { (image,type: SDImageCacheType) -> Void in
                    if image != nil{
                        self.imageViews[index].setBackgroundImage(image, for: .normal)
                    }else{
                        let storage = FIRStorage.storage()
                        let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post")
                        let autorsprofileRef = storageRef.child("\(imagestring).png")
                        autorsprofileRef.downloadURL{(URL,error) -> Void in
                            if error != nil {
                                print(error)
                            } else {
                                SDWebImageManager.shared().downloadImage(with: URL!,
                                                                         options: SDWebImageOptions.cacheMemoryOnly,
                                                                         progress: nil,
                                                                         completed: {(image, error, a, c, s) in
                                                                            SDWebImageManager.shared().imageCache.store(image, forKey: imagestring)
                                                                            self.imageViews[index].setBackgroundImage(image, for: .normal)
                                })
                            }
                        }
                    }
                    self.imageViews[index].imageView?.contentMode = UIViewContentMode.scaleAspectFill
                    self.imageViews[index].addTarget(self, action: #selector(self.showImage(index:)), for: .touchUpInside)
            })
        }
    }
    func showImage(index:UIImageView){
        let imageInfo = JTSImageInfo()
        imageInfo.image = imageViews[index.tag].currentBackgroundImage
        imageInfo.referenceRect = (self.imageViews[index.tag].frame)
        imageInfo.referenceView = self.imageViews[index.tag].superview
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
        imageViewer?.show(from: viewcontroller, transition: JTSImageViewControllerTransition.fromOriginalPosition)
    }
}
