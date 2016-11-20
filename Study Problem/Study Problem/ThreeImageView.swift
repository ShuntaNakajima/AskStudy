//
//  ThreeImageView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/10/23.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import JTSImageViewController
import SDWebImage
class ThreeView: UIView {
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
    class func instance() -> ThreeView{
        return UINib(nibName: "ThreeImageView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ThreeView
    }
    func cancelReload(){
        for (index,image) in images.enumerated(){
            imageViews[index].sd_cancelImageLoad(for: .normal)
        }
    }
    func setImage(images:[String],on:UIViewController){
        viewcontroller = on
        self.images = images
        for (index,image) in images.enumerated(){
            imageViews[index].imageView?.contentMode = UIViewContentMode.scaleAspectFill
            SDWebImageManager.shared().imageCache.queryDiskCache(forKey: image
                , done: { (image,type: SDImageCacheType) -> Void in
                    self.imageViews[index].setBackgroundImage(image, for: .normal)
            })
            imageViews[index].addTarget(self, action: #selector(showImage(index:)), for: .touchUpInside)
        }
    }

    func showImage(index:UIImageView){
        print(index.tag)
        let imageInfo = JTSImageInfo()
        imageInfo.image = imageViews[index.tag].currentBackgroundImage
        imageInfo.referenceRect = (self.imageViews[index.tag].frame)
        imageInfo.referenceView = self.imageViews[index.tag].superview
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
        imageViewer?.show(from: viewcontroller, transition: JTSImageViewControllerTransition.fromOriginalPosition)
    }
}
