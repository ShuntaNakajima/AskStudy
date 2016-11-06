//
//  OnePhotoView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/10/23.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import JTSImageViewController
import SDWebImage

class OnePhotoView: UIView {
    
    @IBOutlet var imageViews:[UIButton]!
    var delegate:ShowImageDelegate!
    var viewcontroller:UIViewController!
    var images = [URL]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageViews.forEach{$0.imageView?.contentMode = UIViewContentMode.scaleAspectFill}
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func instance() -> OnePhotoView{
        return UINib(nibName: "OnePhotoView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! OnePhotoView
    }
    func setImage(images:[URL],on:UIViewController){
        viewcontroller = on
        self.images = images
        for (index,image) in images.enumerated(){
            imageViews[index].imageView?.contentMode = UIViewContentMode.redraw
            imageViews[index].sd_setBackgroundImage(with: image, for: .normal)
            imageViews[index].addTarget(self, action: #selector(showImage(index:)), for: .touchUpInside)
        }
    }
    func resetview(on:UIViewController){
        viewcontroller = on
        var imags = [UIImage]()
        imags.append(UIImage(named: "Gay.png")!)
        for (index,image) in images.enumerated(){
            imageViews[index].imageView?.contentMode = UIViewContentMode.redraw
            imageViews[index].sd_setBackgroundImage(with: image, for: .normal)
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
