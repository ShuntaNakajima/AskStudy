//
//  MainCellUiimageViewClass.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/06/26.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
class MainCellUiimageView: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action:  #selector(MainCellUiimageView.showUser(sender:)), for: .touchUpInside)
        self.updateLayout()
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(MainCellUiimageView.showUser(sender:)), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.updateLayout()
    }
    
    func updateLayout(){
        self.layer.cornerRadius=25
        self.layer.masksToBounds=true
        self.setTitle("", for: UIControlState.normal)
        self.setBackgroundImage(UIImage(named: "noimage.gif")!, for: .normal)
    }
    
    func showUser(sender:UIButton){
        let modalViewController = UserDetailModalViewController(nibName: "UserDetailModalViewController", bundle: nil)
        modalViewController.view.frame = CGRect(x:0,y:0,width: UIScreen.main.bounds.size.width - 40,height: UIScreen.main.bounds.size.height - 380)
        print( modalViewController.view.frame)
        modalViewController.modalPresentationStyle = .custom
        modalViewController.transitioningDelegate = self
        self.superview!.window?.rootViewController!.present(modalViewController, animated: true, completion: nil)
    }
}
extension MainCellUiimageView: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: forPresented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source sourceControllersource: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning(isPresent: true, atButton: self)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning(isPresent: false, atButton: self)
    }
}
