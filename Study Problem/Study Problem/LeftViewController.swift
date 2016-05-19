//
//  LeftViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase
enum LeftMenu: Int {
    case Main = 0
    case Post
    case Mypost
    case Joinpost
    case Follow
    case Notice
    case Setting
}
protocol LeftMenuProtocol : class {
    func changeViewController(menu: LeftMenu)
}
class LeftViewController: UIViewController,LeftMenuProtocol {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backview: UIImageView!
    @IBOutlet weak var nameLabel:UILabel!
     var Database = FIRDatabase.database().reference()
    
    var menus = ["Main", "Post", "Mypost", "Joinpost", "Follow", "Notice" ,"Setting"]
    var mainViewController: UIViewController!
    var postViewController: UIViewController!
    var mypostViewController: UIViewController!
    var joinpostViewController: UIViewController!
    var followViewController: UIViewController!
    var noticeViewController: UIViewController!
    var settingViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(Database.authData)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil && Database.authData != nil {
//            Database.unauth()
//        }
        //if NSUserDefaults.standardUserDefaults().valueForKey("uid") == nil && Database.authData == nil {
        if FIRAuth.auth()?.currentUser == nil {
            let viewController:UIViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewControllers")
            self.presentViewController(viewController, animated: true, completion: nil)
            
        }else{
       
                self.nameLabel.text = FIRAuth.auth()?.currentUser?.displayName
           
        }
        tableView.registerNib(UINib(nibName: "MenusTableViewCell", bundle: nil), forCellReuseIdentifier: "MenusTableViewCell")
        
        //        let blurEffect = UIBlurEffect(style: .Light)
        //        var visualEffectView = UIVisualEffectView(effect: blurEffect)
        //        visualEffectView.frame = backview.bounds
        //        backview.addSubview(visualEffectView)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
        self.mainViewController = UINavigationController(rootViewController: mainViewController)
        
        let postViewController = storyboard.instantiateViewControllerWithIdentifier("PostViewController") as! PostViewController
        self.postViewController = UINavigationController(rootViewController: postViewController)
        
        let mypostViewController = storyboard.instantiateViewControllerWithIdentifier("MypostViewController") as! MypostViewController
        self.mypostViewController = UINavigationController(rootViewController: mypostViewController)
        
        let joinpostViewController = storyboard.instantiateViewControllerWithIdentifier("JoinpostViewController") as! JoinpostViewController
        self.joinpostViewController = UINavigationController(rootViewController: joinpostViewController)
        let followViewController = storyboard.instantiateViewControllerWithIdentifier("FollowViewController") as! FollowViewController
        self.followViewController = UINavigationController(rootViewController: followViewController)
        let noticeViewController = storyboard.instantiateViewControllerWithIdentifier("NoticeViewController") as! NoticeViewController
        self.noticeViewController = UINavigationController(rootViewController: noticeViewController)
        let settingViewController = storyboard.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
        self.settingViewController = UINavigationController(rootViewController: settingViewController)
        // self.tableView.registerCellClass(MenuTableViewCell.self)
        var nib  = UINib(nibName: "MenusTableViewCell", bundle:nil)
        tableView.registerNib(nib, forCellReuseIdentifier:"MenuCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */ func changeViewController(menu: LeftMenu) {
        switch menu {
        case .Main:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .Post:
            self.slideMenuController()?.changeMainViewController(self.postViewController, close: true)
        case .Mypost:
            self.slideMenuController()?.changeMainViewController(self.mypostViewController, close: true)
        case .Joinpost:
            self.slideMenuController()?.changeMainViewController(self.joinpostViewController, close: true)
        case .Follow:
            self.slideMenuController()?.changeMainViewController(self.followViewController, close: true)
        case .Notice:
            self.slideMenuController()?.changeMainViewController(self.noticeViewController, close: true)
        case .Setting:
            self.slideMenuController()?.changeMainViewController(self.settingViewController, close: true)
            
            
        }
    }
    
}
extension LeftViewController : UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Main, .Post, .Mypost, .Joinpost, .Follow, .Notice ,.Setting:
                return 50
            }
        }
        return 0
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.item) {
            switch menu {
            case .Main, .Post, .Mypost, .Joinpost, .Follow, .Notice ,.Setting:
                //let cell = MenuTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: MenuTableViewCell.identifier)
                let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! MenusTableViewCell
                //cell.setData(menus[indexPath.row])
                //switch menus[indexPath.row] {
                // case "Main":
                //                    cell.MenuImage.image = UIImage(named:"1")
                //                    case "Post":
                //                    cell.MenuImage.image = UIImage(named:"2")
                //                    case "Mypost":
                //                    cell.MenuImage.image = UIImage(named:"3")
                //                    case "Joinpost":
                //                    cell.MenuImage.image = UIImage(named:"4")
                //                    case "Follow":
                //                    cell.MenuImage.image = UIImage(named:"5")
                //                    case "Notice":
                //                    cell.MenuImage.image = UIImage(named:"6")
                //                    case "Setting":
                //                    cell.MenuImage.image = UIImage(named:"7")
                // default:
                //     break
                //}
                cell.MenuLablel.text = menus[indexPath.row]
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let menu = LeftMenu(rawValue: indexPath.item) {
            self.changeViewController(menu)
        }
    }
}

extension LeftViewController: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}
