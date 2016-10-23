//
//  TwoImageView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/10/23.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import JTSImageViewController
class TwoView: UIView {
    @IBOutlet var imageViews:[UIButton]!
    var delegate:ShowImageDelegate!
    var viewcontroller:UIViewController!
    var images = [UIImage]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    class func instance() -> TwoView{
        return UINib(nibName: "TwoImageView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! TwoView
    }
    func setImage(images:[UIImage],on:UIViewController){
        viewcontroller = on
        self.images = images
        for (index,image) in images.enumerated(){
            imageViews[index].setBackgroundImage(image, for: .normal)
            imageViews[index].addTarget(self, action: #selector(showImage(index:)), for: .touchUpInside)
        }
    }
    func showImage(index:UIImageView){
        print(index.tag)
        let imageInfo = JTSImageInfo()
        let animage = images[index.tag]
        imageInfo.image = animage
        imageInfo.referenceRect = (self.imageViews[index.tag].frame)
        imageInfo.referenceView = self.imageViews[index.tag].superview
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
        imageViewer?.show(from: viewcontroller, transition: JTSImageViewControllerTransition.fromOriginalPosition)
    }
}
