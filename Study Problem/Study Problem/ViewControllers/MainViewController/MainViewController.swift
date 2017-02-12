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
import TrueTime

class MainViewController: UIViewController,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate{
    let network = DataCacheNetwork()
    let database = FIRDatabase.database().reference()
    var selectpost : Dictionary<String, AnyObject> = [:]
    var selectpostID : String!
    var posts = [Dictionary<String, AnyObject>]()
    var segueUser = ""
    var longState = false
    var refreshControl:UIRefreshControl!
    let transition = BubbleTransition()
     let client = TrueTimeClient.sharedInstance
    
    var number = 10
    var realnumber = 10
    @IBOutlet var tableView :UITableView!
    @IBOutlet var postButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        client.start()
        if FIRAuth.auth()?.currentUser == nil{
            let viewController:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewControllers")
            self.present(viewController, animated: true, completion: nil)
        }
        let nib  = UINib(nibName: "PostTableViewCell", bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier:"PostCell")
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Reload")
        self.refreshControl.addTarget(self, action: #selector(MainViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MainViewController.cellLongPressed(recognizer:)))
        longPressRecognizer.allowableMovement = 0
        longPressRecognizer.minimumPressDuration = 0.4
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
        postButton.layer.cornerRadius=30
        postButton.layer.masksToBounds=true
        postButton.setTitle("", for: UIControlState.normal)
         self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName: UIFont(name: "Pacifico", size: 28)!]
        self.navigationController?.navigationBar.topItem?.title = "AskStudy"
        network.checkUser(client:client,vc:self, success: {_ in
            self.reloadData(success: {_ in
                self.tableView.reloadData()
            })
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let ud = UserDefaults.standard
            if ud.bool(forKey: "firstLaunch") {
                ud.set(false, forKey: "firstLaunch")
                let viewController:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "PageViewController")
                self.present(viewController, animated: true, completion: nil)
            }else if FIRAuth.auth()?.currentUser == nil{
                let viewController:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewControllers")
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UINavigationBar.appearance().barTintColor
        self.tabBarController?.tabBar.tintColor = UITabBar.appearance().tintColor
        ChangeColor.getColor()
        self.navigationController?.navigationBar.barTintColor = UINavigationBar.appearance().barTintColor
        self.tabBarController?.tabBar.tintColor = UITabBar.appearance().tintColor
        postButton.backgroundColor = UITabBar.appearance().tintColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewPost") {
            let vpVC: ViewpostViewController = segue.destination as! ViewpostViewController
            vpVC.postDic = selectpost
            vpVC.post = selectpostID
        }else if (segue.identifier == "toPost"){
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
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?{
        transition.transitionMode = .dismiss
        transition.startingPoint = postButton.center
        transition.bubbleColor = UITabBar.appearance().tintColor
        return transition
    }
    func reloadData(success:@escaping() -> Void){
        network.loadCache(limit: number, success: {posts in
            self.posts = posts
            self.tableView.isHidden = false
            SVProgressHUD.dismiss()
            success()
        },loadedimage:{_ in
            success()
        })
    }
    func showUserData(sender:UIButton){
        let row = sender.tag
        segueUser = posts[row]["author"] as! String
        let UDMC: UserDetailModalViewController = (self.presentedViewController as? UserDetailModalViewController)!
        UDMC.UserKey = self.segueUser
    }
    func refresh(){
        reloadData(success: {_ in})
    }
}

