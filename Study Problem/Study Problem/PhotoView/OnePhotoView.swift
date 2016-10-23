//
//  OnePhotoView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/10/23.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class OnePhotoView: UIView {

    @IBOutlet var ImageViews: UIButton!
    var delegate :ShowImageDelegate!
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    private func setup(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(show))
        //ImageViews.forEach({$0.addGestureRecognizer(tapGestureRecognizer)})
        ImageViews.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc private func show(){
        delegate.show()
    }
    class func instance() -> OnePhotoView{
        return UINib(nibName: "OnePhotoView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! OnePhotoView
    }
    func setImage(images:[UIImage]){
        ImageViews.setBackgroundImage(images[0], for: .normal)
    }

}
