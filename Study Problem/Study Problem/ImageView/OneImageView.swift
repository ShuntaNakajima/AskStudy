 //
//  OneImageView.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/10/23.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit

class OneImageView: UIView {
    @IBOutlet var ImageViews: UIImageView!
    var delegate :ShowImageDelegate!
    override init(frame: CGRect) {
        super.init(frame:frame)
        Bundle.main.loadNibNamed("OneImageView", owner: self, options: nil)
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
    class func instance() -> OneImageView{
        return UINib(nibName: "OneImageView", bundle: nil).instantiate(withOwner: self, options: nil)[0] as! OneImageView
    }
    func setImage(images:[UIImage]){
        ImageViews.image = images[0]
    }
}

