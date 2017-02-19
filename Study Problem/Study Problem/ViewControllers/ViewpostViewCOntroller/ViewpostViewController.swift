//
//  ViewpostViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/15.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import DKImagePickerController
import Photos
import AVKit
import SVProgressHUD

class ViewpostViewController: UIViewController,UITextViewDelegate {
    let database = FIRDatabase.database().reference()
    var post : String!
    var newpost : FIRDatabase!
    var replys = [Dictionary<String, AnyObject>]()
    var postDic = Dictionary<String, AnyObject>()
    var toreply : String!
    var keyboradheight : CGFloat!
    var myTextView: UITextView!
    var toolbar:UIToolbar!
    var collectionview:UICollectionView!
    let storage = FIRStorage.storage()
    var profileRef : FIRStorageReference!
        var assets: [DKAsset]? = []
     let network = DataCacheNetwork()
    @IBOutlet var tableView :UITableView!
    @IBOutlet var imageview:UIImageView!
    @IBOutlet var imgview:UIView!
    @IBOutlet var imglabel:UILabel!
    @IBOutlet var imgbutton:UIButton!
    @IBOutlet var closebutton:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgview.isHidden = true
        self.imageview.isHidden = true
        self.imglabel.isHidden = true
        self.imgbutton.isHidden = true
        self.closebutton.isHidden = true
        tableView.estimatedRowHeight = 20
        tableView.rowHeight = UITableViewAutomaticDimension
        let mainnib  = UINib(nibName: "PostTableViewCell", bundle:nil)
        self.tableView.register(mainnib, forCellReuseIdentifier:"PostCell")
        let itemnib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        self.tableView.register(itemnib, forCellReuseIdentifier: "ItemCell")
        let replysnib  = UINib(nibName: "ReplysTableViewCell", bundle:nil)
        self.tableView.register(replysnib, forCellReuseIdentifier:"ReplysCell")
        let myreplysnib  = UINib(nibName: "ReplaywithphotoTableViewCell", bundle:nil)
        self.tableView.register(myreplysnib, forCellReuseIdentifier:"ReplyswithphotoCell")
        toolbar = UIToolbar(frame: CGRect(x:0,y:self.view.bounds.size.height - 30.0,width:self.view.bounds.size.width, height:30.0))
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = UIColor.white
        toolbar.backgroundColor = UIColor.black
        let button3: UIBarButtonItem = UIBarButtonItem(title: "send", style:.plain, target: nil, action: #selector(tappedToolBarBtn))
        let button1: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "PhotoMini.png"), style: .plain, target: nil, action: #selector(addButton(sender:)))
        let buttonGap: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.items = [button1, buttonGap, button3]
        self.view.addSubview(toolbar)
        myTextView = UITextView(frame: CGRect(x:55,y:0 ,width:self.view.frame.width - 110,height: 30))
        myTextView.layer.borderWidth = 0.5
        myTextView.font = UIFont.systemFont(ofSize: 15)
        myTextView.delegate = self
        myTextView.text = "Type here"
        myTextView.textColor = UIColor.lightGray
        toolbar.addSubview(self.myTextView)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(ViewpostViewController.handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        database.child("post/" + post).observe(.value, with: { (snapshot:FIRDataSnapshot) in
            if snapshot.children.allObjects is [FIRDataSnapshot] {
                if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                    let key = snapshot.key
                    postDictionary["key"] = key as AnyObject?
                    guard let BestAnswer = postDictionary["BestAnswer"] as? String else{return}
                    if BestAnswer == ""{
                        self.toolbar.isHidden = false
                        self.tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30))
                    }else{
                        self.toolbar.isHidden = true
                        self.tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                    }
                    self.postDic = postDictionary
                    self.tableView.reloadData()
                }
            }
        })
        database.child("post/" + post + "/replys").observe(.value, with: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.replys = []
                for snap in snapshots {
                    if var postDictionary = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        postDictionary["key"] = key as AnyObject?
                        self.replys.append(postDictionary)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        self.closebutton.backgroundColor = UINavigationBar.appearance().barTintColor
            myTextView.resignFirstResponder()
            self.view.transform = CGAffineTransform.identity
            toolbar.frame = (frame: CGRect(x:0,y: self.view.bounds.size.height - 30.0,width: self.view.bounds.size.width,height:30.0))
            myTextView.frame = (frame: CGRect(x:55,y:0 ,width:self.view.frame.width - 110,height: 30))
            tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30))
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        if assets! != []{
        self.closebutton.isHidden = false
        }
        return true
    }
    func handleKeyboardWillShowNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let transform = CGAffineTransform(translationX: 0, y: -keyboardScreenEndFrame.size.height)
        self.keyboradheight = keyboardScreenEndFrame.size.height
        self.view.transform = transform
        tableView.frame = (frame: CGRect(x: 0, y: keyboardScreenEndFrame.size.height, width: self.view.frame.width, height: self.view.frame.height - keyboardScreenEndFrame.size.height - 30))
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if myTextView.text == "Type here"{
            myTextView.text = ""
            myTextView.textColor = UIColor.black
        }
    }
    func tappedToolBarBtn(){
        let replyText = myTextView.text
        if replyText != "" && replyText != "Type here" {
            myTextView.resignFirstResponder()
            self.view.transform = CGAffineTransform.identity
            toolbar.frame = (frame: CGRect(x:0,y: self.view.bounds.size.height - 30.0,width: self.view.bounds.size.width,height:30.0))
            myTextView.frame = (frame: CGRect(x:55,y:0 ,width:self.view.frame.width - 110,height: 30))
            myTextView.text = "Type here"
            myTextView.textColor = UIColor.lightGray
            tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30))
            let newreply: Dictionary<String, AnyObject> = [
                "text": replyText! as AnyObject,
                "author": (FIRAuth.auth()?.currentUser?.uid)! as AnyObject,
                "photos": assets?.count as AnyObject
            ]
            let firebasenewreply = database.child("post/" + post + "/replys").childByAutoId()
            firebasenewreply.setValue(newreply)
            var replaycount = postDic["reply"] as! Int
            replaycount = replaycount + 1
            let firebasenewreplyscount = database.child("post/" + post + "/reply")
            firebasenewreplyscount.setValue(replaycount)
            uploadImage(key: firebasenewreply.key)
            self.imgview.isHidden = true
            self.imageview.isHidden = true
            self.imglabel.isHidden = true
            self.imgbutton.isHidden = true
            self.closebutton.isHidden = true
            self.navigationController?.navigationBar.isHidden = false
            self.assets = []
        }
    }
    func addButton(sender: AnyObject) {
        myTextView.resignFirstResponder()
        self.view.transform = CGAffineTransform.identity
        toolbar.frame = (frame: CGRect(x:0,y: self.view.bounds.size.height - 30.0,width: self.view.bounds.size.width,height:30.0))
        myTextView.frame = (frame: CGRect(x:55,y:0 ,width:self.view.frame.width - 110,height: 30))
        tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30))
        showImagePickerWithAssetType(
            .allPhotos,
            sourceType: .both,
            maxSelectableCount: 1,
            allowsLandscape: false,
            singleSelect: false
        )}

    func textViewDidChange(_ textView: UITextView){
        self.closebutton.isHidden = false
        let maxHeight = 140.0
        let size:CGSize = myTextView.sizeThatFits(myTextView.frame.size)
        if (size.height.native <= maxHeight) {
            myTextView.frame.size.height = size.height
            toolbar.frame = (frame: CGRect(x:0,y: self.view.bounds.size.height - size.height,width: self.view.bounds.size.width,height: size.height))
            myTextView.frame = (frame: CGRect(x:55,y:0 ,width:self.view.frame.width - 110,height: size.height))
            tableView.frame = (frame: CGRect(x: 0, y: keyboradheight!, width: self.view.frame.width, height: self.view.frame.height - keyboradheight! - size.height))
        }
    }
    func showUserData(sender:UIButton){
        let row = sender.tag
        var segueUser = ""
        if row == 1{}else if row == 0{
            segueUser = postDic["author"] as! String
        }else{
            segueUser = replys[row - 2]["author"] as! String
        }
        let UDMC: UserDetailModalViewController = (self.presentedViewController as? UserDetailModalViewController)!
        UDMC.UserKey = segueUser
    }
    func option(sender:UIButton){
        let row = sender.tag
        if postDic["author"] as? String == FIRAuth.auth()?.currentUser!.uid{
            let alert = UIAlertController(title: "Option", message: "Are you sure report this Post?", preferredStyle: UIAlertControllerStyle.actionSheet)
            let action = UIAlertAction(title: "Report", style: .default, handler:{(_) in
                self.reportPost(row: row)
            })
            let delete = UIAlertAction(title: "Delete", style: .default, handler:{(_) in
                self.delete(row: row)
            })
            let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(delete)
            alert.addAction(cancelaction)
            present(alert, animated: true, completion: nil)
        }else{
            reportPost(row: row)
        }
    }
    func reportPost(row:Int){
        let alert = UIAlertController(title: "Report Post", message: "Are you sure report this Post?", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Report", style: .default, handler:{(_) in
            let newreport: Dictionary<String, Any> = [
                "reportPost":self.postDic["key"] as! String!,
                "reportUser":FIRAuth.auth()?.currentUser?.uid as Any
            ]
            self.database.child("report").childByAutoId().setValue(newreport)
        })
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelaction)
        present(alert, animated: true, completion: nil)
    }
    func delete(row:Int){
        let alert = UIAlertController(title: "Delete", message: "Are you sure delete this Post?", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Delete", style: .default, handler:{(_) in
            self.database.child("post").child(self.postDic["key"] as! String!).removeValue()
        })
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelaction)
        present(alert, animated: true, completion: nil)
    }
}
extension ViewpostViewController{
    func showImagePickerWithAssetType(_ assetType: DKImagePickerControllerAssetType,
                                      sourceType: DKImagePickerControllerSourceType = .both,
                                      maxSelectableCount: Int,
                                      allowsLandscape: Bool,
                                      singleSelect: Bool) {
        
        let pickerController = DKImagePickerController()
        pickerController.assetType = assetType
        pickerController.allowsLandscape = allowsLandscape
        pickerController.maxSelectableCount = maxSelectableCount
        pickerController.sourceType = sourceType
        pickerController.singleSelect = singleSelect
        pickerController.defaultSelectedAssets = self.assets
        pickerController.didSelectAssets = { [unowned self] (assets: [DKAsset]) in
            self.assets = assets
            if self.assets! != []{
                self.imgview.isHidden = false
                self.imageview.isHidden = false
                self.imglabel.isHidden = false
                self.imgbutton.isHidden = false
                self.navigationController?.navigationBar.isHidden = true
            assets[0].fetchFullScreenImage(false, completeBlock: { images, info in
                self.imageview.image = images
            })
            }
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        self.present(pickerController, animated: true) {}
    }
    func uploadImage(key:String!){
        for (_,asset) in assets!.enumerated(){
            asset.fetchFullScreenImage(false, completeBlock: { image, info in
                let metadata = FIRStorageMetadata()
                //firebaseにプロフィールイメージをアップロードする
                let data: NSData = UIImagePNGRepresentation(image!)! as NSData
                let storageRef = self.storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post/").child(self.postDic["key"] as! String!)
                self.profileRef = storageRef.child("reply/\(key!).png")
                let uploadTask = self.profileRef.put(data as Data, metadata: metadata) { metadata, error in
                    if (error != nil) {
                    } else {
                    }
                }
                uploadTask.observe(.progress) { snapshot in
                    if let progress = snapshot.progress {
                        let number = 100
                        let percentComplete = number * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
                        SVProgressHUD.show(withStatus: "\(percentComplete)/100")
                    }
                }
                uploadTask.observe(.success) { snapshot in
                        SVProgressHUD.showSuccess(withStatus: "Successful!")
                        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline:delayTime, execute:{ SVProgressHUD.dismiss() })
                }
            })
        }
    }
    @IBAction func cancelbuttonPushed(){
        self.imgview.isHidden = true
        self.imageview.isHidden = true
        self.imglabel.isHidden = true
        self.imgbutton.isHidden = true
        self.closebutton.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.assets = []
    }
    @IBAction func close(){
        myTextView.resignFirstResponder()
        self.view.transform = CGAffineTransform.identity
        toolbar.frame = (frame: CGRect(x:0,y: self.view.bounds.size.height - 30.0,width: self.view.bounds.size.width,height:30.0))
        myTextView.frame = (frame: CGRect(x:55,y:0 ,width:self.view.frame.width - 110,height: 30))
        tableView.frame = (frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 30))
    }
}
