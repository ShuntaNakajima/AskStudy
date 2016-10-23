//
//  ThreeImageView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/10/23.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class ThreeView: UIView {
    @IBOutlet var imageViews:[UIButton]!
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
        imageViews.forEach({$0.addGestureRecognizer(tapGestureRecognizer)})
    }
    @objc private func show(){
        delegate.show()
    }
    class func instance() -> ThreeView{
        return UINib(nibName: "ThreeImageView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! ThreeView
    }
    func setImage(images:[UIImage]){
        for (index,image) in images.enumerated(){
            imageViews[index].setBackgroundImage(image, for: .normal)
        }
    }
}
