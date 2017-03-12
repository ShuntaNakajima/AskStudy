//
//  SearchViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/09/21.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet

class SearchViewController: UIViewController,  UISearchBarDelegate ,UIGestureRecognizerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    var searchBar: UISearchBar!
    let database = FIRDatabase.database().reference()
    var posts = [Dictionary<String, AnyObject>]()
    var longState = false
    var refreshControl:UIRefreshControl!
    var selectpost : Dictionary<String, AnyObject> = [:]
    var selectpostID : String!
    var segueUser = ""
    @IBOutlet var tableView :UITableView!
   // @IBOutlet var segucon:UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        let nib  = UINib(nibName: "PostTableViewCell", bundle:nil)
        self.tableView.register(nib, forCellReuseIdentifier:"PostCell")
        let nib2  = UINib(nibName: "ChatTableViewCell", bundle:nil)
        self.tableView.register(nib2, forCellReuseIdentifier:"ChatUserCell")
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: (string: NSLocalizedString("Reload",comment:"")))
        self.refreshControl.addTarget(self, action: #selector(SearchViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(SearchViewController.cellLongPressed(recognizer:)))
        longPressRecognizer.allowableMovement = 0
        longPressRecognizer.minimumPressDuration = 0.4
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
      //  segucon.addTarget(self, action: #selector(SearchViewController.segmentedControlChanged(sender:)), for: UIControlEvents.valueChanged)
    }
    private func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            self.navigationItem.hidesBackButton = true
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = NSLocalizedString("Search",comment:"")
            searchBar.showsCancelButton = true
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
            searchBar.becomeFirstResponder()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {// textDidChange
        reload(searchText: searchText)
    }
    func reload(searchText:String){
        self.tableView.contentOffset = CGPoint(x:0,y: -self.tableView.contentInset.top)
      //  if segucon.selectedSegmentIndex == 0{
            database.child("post").queryOrdered(byChild: "text").queryStarting(atValue:searchText).queryEnding(atValue: searchText+"\u{f8ff}").observeSingleEvent(of: .value, with: { snapshot in
                self.posts = []
                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    for snap in snapshots {
                        if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                            let key:String! = snapshot.key
                            postDictionary["key"] = key as AnyObject?
                            self.posts.append(postDictionary)
                            self.tableView.reloadData()
                        }
                    }
                }
                self.tableView.reloadData()
            })
        //}else{
//            database.child("user").queryOrdered(byChild: "username").queryStarting(atValue:searchText).queryEnding(atValue: searchText+"\u{f8ff}").observeSingleEvent(of: .value, with: { snapshot in
//                self.posts = []
//                if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
//                    for snap in snapshots {
//                        if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
//                            let key = snap.key
//                            postDictionary["key"] = key as AnyObject?
//                            self.posts.append(postDictionary)
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//                self.tableView.reloadData()
//            })
        //}
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {// clicked cancel button
        searchBar.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {// clicked serch button
        searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    func segmentedControlChanged(sender: UISegmentedControl) {
        reload(searchText: searchBar.text!)
    }
    func refresh(){
        reload(searchText: searchBar.text!)
        self.refreshControl.endRefreshing()
    }
    func showUserData(sender:UIButton){
        let row = sender.tag
       // if segucon.selectedSegmentIndex == 0{
            segueUser = posts[row]["author"] as! String
//        }else{
//            segueUser = posts[row]["key"] as! String
//        }
        let UDMC: UserDetailModalViewController = (self.presentedViewController as? UserDetailModalViewController)!
        UDMC.UserKey = self.segueUser
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "viewSarchPost") {
            let vpVC: ViewpostViewController = (segue.destination as? ViewpostViewController)!
            vpVC.postDic = selectpost
            vpVC.post = selectpostID
        }
    }
}
