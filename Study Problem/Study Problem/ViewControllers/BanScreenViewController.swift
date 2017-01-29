//
//  BanScreenViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2017/01/15.
//  Copyright © 2017年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase

class BanScreenViewController: UIViewController,CAAnimationDelegate {
    @IBOutlet var label:UILabel!
    @IBOutlet var timeLabel : UILabel!
    @IBOutlet var reasonLabel:UILabel!
    
    let database = FIRDatabase.database().reference()
    var fromColors = [Any?]()
    var gradient : CAGradientLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradient = CAGradientLayer()
        self.gradient?.frame = self.view.bounds
        self.gradient?.colors = [ UIColor.ThemePurple().cgColor, UIColor.ThemeRed().cgColor]
        self.view.layer.insertSublayer(self.gradient!, at: 0)
        getState()
    }
    override func viewDidAppear(_ animated: Bool) {
        animateLayer()
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        animateLayer()
    }
    func animateLayer(){
        let toColors: [AnyObject] = [ UIColor.ThemeBlue().cgColor, UIColor.ThemeLightBlue().cgColor]
        let fromColors: [AnyObject] = [ UIColor.ThemePurple().cgColor, UIColor.ThemeRed().cgColor]
        self.gradient?.colors = toColors
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = fromColors
        animation.toValue = toColors
        animation.duration = 18.00
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.autoreverses = true
        animation.repeatCount = 10
        animation.delegate = self
        self.gradient?.add(animation, forKey:"animateGradient")
    }
    func getState(){
        var myStatus = [Dictionary<String, AnyObject>]()
        let recentUesrsQuery = (database.child("ban").queryOrdered(byChild: "uid").queryEqual(toValue: FIRAuth.auth()?.currentUser!.uid))
        recentUesrsQuery.observe(.value, with: { snapshot in
            
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots{
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key as AnyObject?
                        myStatus.append(postDictionary)
                    }
                }
            }
            let df:DateFormatter = DateFormatter()
            df.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
            df.dateFormat = "yyyy/MM/dd HH:mm:ss"
          self.reasonLabel.text = myStatus.last?["reason"] as! String!
            self.timeLabel.text = df.string(from: (myStatus.last?["date"] as! String!).postDate())
            if myStatus.last?["date"] as! String! == "never"{
                self.label.text = "Your are banned for"
        }
        }
    )
    }
}
