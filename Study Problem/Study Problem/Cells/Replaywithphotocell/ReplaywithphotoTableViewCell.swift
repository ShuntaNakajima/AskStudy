//
//  ReplaywithphotoTableViewCell.swift
//  Study Problem
//
//  Created by nakajimashunta on 2017/02/14.
//  Copyright © 2017年 ShuntaNakajima. All rights reserved.
//

import UIKit
import JTSImageViewController

class ReplaywithphotoTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView : MainCellUiimageView!
    @IBOutlet var usernameLabel:UILabel!
    @IBOutlet var postLabel:UILabel!
    @IBOutlet var setBestAnser:UIButton!
    @IBOutlet var imagebutton:UIButton!
    
    var vc=UIViewController()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setimage(vc:UIViewController,post:String,uid:String){
        self.vc = vc
        DataCacheNetwork().cachereplayimage(post:post,uid:uid, success: {image in
            self.imagebutton.setBackgroundImage(image, for: UIControlState.normal)
            self.layoutSubviews()
            self.imagebutton.addTarget(self, action: #selector(self.showImage(index:)), for: .touchUpInside)
        })
    }
    func showImage(index:UIImageView){
        let imageInfo = JTSImageInfo()
        imageInfo.image = imagebutton.currentBackgroundImage
        imageInfo.referenceRect = (self.imagebutton.frame)
        imageInfo.referenceView = self.imagebutton.superview
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
        imageViewer?.show(from: vc, transition: JTSImageViewControllerTransition.fromOriginalPosition)
    }
}
