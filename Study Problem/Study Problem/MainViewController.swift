//
//  MainViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import BubbleTransition
import JTSImageViewController
class MainViewController: UIViewController,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate{
    var Database = FIRDatabaseReference.init()
    var selectpost : Dictionary<String, AnyObject> = [:]
    var selectpostID : String!
    var posts = [Dictionary<String, AnyObject>]()
    var segueUser = ""
    var longState = false
    var refreshControl:UIRefreshControl!
    let transition = BubbleTransition()
    var number = 10
    @IBOutlet var tableView :UITableView!
    @IBOutlet var postButton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser == nil{
            let viewController:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewControllers")
            self.present(viewController, animated: true, completion: nil)
        }
        let nib  = UINib(nibName: "postTableViewCell", bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier:"PostCell")
        Database = FIRDatabase.database().reference()
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        reloadData()
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
        let color = UserDefaults.standard
        let colorop : String? = color.object(forKey: "id") as! String?
        UITabBar.appearance().tintColor = UIColor.ThemeBlue()
        UINavigationBar.appearance().barTintColor = UIColor.ThemeBlue()
        if let color = colorop{
            switch color{
            case "yellow":
                UITabBar.appearance().tintColor = UIColor.ThemeYellow()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeYellow()
            case "lightblue":
                UITabBar.appearance().tintColor = UIColor.ThemeLightBlue()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeLightBlue()
            case "blue":
                UITabBar.appearance().tintColor = UIColor.ThemeBlue()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeBlue()
            case "red":
                UITabBar.appearance().tintColor = UIColor.ThemeRed()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeRed()
            case "green":
                UITabBar.appearance().tintColor = UIColor.ThemeGreen()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeGreen()
            case "orange":
                UITabBar.appearance().tintColor = UIColor.ThemeOrange()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeOrange()
            case "purple":
                UITabBar.appearance().tintColor = UIColor.ThemePurple()
                UINavigationBar.appearance().barTintColor = UIColor.ThemePurple()
            default:
                UITabBar.appearance().tintColor = UIColor.ThemeBlue()
                UINavigationBar.appearance().barTintColor = UIColor.ThemeBlue()
            }
            self.navigationController?.navigationBar.barTintColor = UINavigationBar.appearance().barTintColor
            self.tabBarController?.tabBar.tintColor = UITabBar.appearance().tintColor
        }
        postButton.backgroundColor = UITabBar.appearance().tintColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewPost") {
            let vpVC: ViewpostViewController = (segue.destination as? ViewpostViewController)!
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
    func reloadData(){
        Database.child("post").queryLimited(toLast: UInt(number)).observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts = []
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key as AnyObject?
                        self.posts.insert(postDictionary, at: 0)
                    }
                }
                self.refreshControl.endRefreshing()
            }
            self.tableView.reloadData()
        })
    }
    func showUserData(sender:UIButton){
        let row = sender.tag
        segueUser = posts[row]["author"] as! String
        let UDMC: UserDetailModalViewController = (self.presentedViewController as? UserDetailModalViewController)!
        UDMC.UserKey = self.segueUser
    }
    func refresh(){
        reloadData()
    }
}

