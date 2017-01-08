//
//  MainViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//
import UIKit
import Firebase
import BubbleTransition
import JTSImageViewController
import SVProgressHUD
import WebImage

class MainViewController: UIViewController, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate {
    
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    var selectedPost : Dictionary<String, AnyObject> = [:]
    var selectpostID : String!
    var posts: [Dictionary<String, AnyObject>] = []
    var longState: Bool = false
    let transition: BubbleTransition = BubbleTransition()
    var limitNumber: Int = 10
    
    @IBOutlet var tableView :UITableView!
    @IBOutlet var postButton:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser == nil{
            let viewController:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewControllers")
            self.present(viewController, animated: true, completion: nil)
        }
        let nib: UINib = UINib(nibName: "postTableViewCell", bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier:"PostCell")
        
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let refreshControl: UIRefreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Reload")
        refreshControl.addTarget(self, action: #selector(reloadData), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        let longPressRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed(recognizer:)))
        longPressRecognizer.allowableMovement = 0
        longPressRecognizer.minimumPressDuration = 0.4
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
        postButton.layer.cornerRadius=30
        postButton.layer.masksToBounds=true
        postButton.setTitle("", for: UIControlState.normal)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            
            let ud: UserDefaults = UserDefaults.standard
            if ud.bool(forKey: "firstLaunch") {
                
                ud.set(false, forKey: "firstLaunch")
                let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "PageViewController")
                self.present(viewController, animated: true, completion: nil)
            }else if FIRAuth.auth()?.currentUser == nil {
                
                let viewController: UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewControllers")
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.isHidden = true
        SVProgressHUD.show()
        let userDefaults: UserDefaults = UserDefaults.standard
        let themeColorString: String? = userDefaults.string(forKey: "id")
        UITabBar.appearance().tintColor = UIColor.themeBlue()
        UINavigationBar.appearance().barTintColor = UIColor.themeBlue()
        
        if let color: String = themeColorString {
            switch color{
            case "yellow":
                UITabBar.appearance().tintColor = UIColor.themeYellow()
                UINavigationBar.appearance().barTintColor = UIColor.themeYellow()
            case "lightblue":
                UITabBar.appearance().tintColor = UIColor.themeLightBlue()
                UINavigationBar.appearance().barTintColor = UIColor.themeLightBlue()
            case "blue":
                UITabBar.appearance().tintColor = UIColor.themeBlue()
                UINavigationBar.appearance().barTintColor = UIColor.themeBlue()
            case "red":
                UITabBar.appearance().tintColor = UIColor.themeRed()
                UINavigationBar.appearance().barTintColor = UIColor.themeRed()
            case "green":
                UITabBar.appearance().tintColor = UIColor.themeGreen()
                UINavigationBar.appearance().barTintColor = UIColor.themeGreen()
            case "orange":
                UITabBar.appearance().tintColor = UIColor.themeOrange()
                UINavigationBar.appearance().barTintColor = UIColor.themeOrange()
            case "purple":
                UITabBar.appearance().tintColor = UIColor.themePurple()
                UINavigationBar.appearance().barTintColor = UIColor.themePurple()
            default:
                UITabBar.appearance().tintColor = UIColor.themeBlue()
                UINavigationBar.appearance().barTintColor = UIColor.themeBlue()
            }
        }
        postButton.backgroundColor = UITabBar.appearance().tintColor
        reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "viewPost") {
            
            let vpVC: ViewpostViewController = segue.destination as! ViewpostViewController
            vpVC.postDic = selectedPost
            vpVC.post = selectpostID
        }else if (segue.identifier == "toPost") {
            
            let controller = segue.destination
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = postButton.center
        transition.bubbleColor = UITabBar.appearance().tintColor
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.transitionMode = .dismiss
        transition.startingPoint = postButton.center
        transition.bubbleColor = UITabBar.appearance().tintColor
        return transition
    }
    
    func reloadData() {
        
        DataCacheNetwork().loadCache(limit: limitNumber, success: { posts in
            
            self.posts = posts
            SVProgressHUD.dismiss()
            self.tableView.isHidden = false
            self.tableView.reloadData()
        })
    }
    
    func showUserData(sender:UIButton) {
        
        let row = sender.tag
        let segueUser = posts[row]["author"] as! String
        let viewcontroller: UserDetailModalViewController = self.presentedViewController as! UserDetailModalViewController
        viewcontroller.userKey = segueUser
    }
}

