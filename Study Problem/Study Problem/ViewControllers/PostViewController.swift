//
//  PostViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import Photos
import AVKit
import DKImagePickerController
import JTSImageViewController
import SVProgressHUD


class PostViewController: UIViewController ,UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate{
    @IBOutlet var textView:UITextView!
    
    var Database = FIRDatabaseReference.init()
    
    @IBOutlet var subjectTextfield:UITextField!
    @IBOutlet var closebutton:UIButton!
    @IBOutlet var postbutton:UIButton!
    @IBOutlet var previewView: UICollectionView?
    @IBOutlet var photobutton:UIButton!
    
    let storage = FIRStorage.storage()
    var profileImages : UIImage! = nil
    var profileRef : FIRStorageReference!
    var profileReforig : FIRStorageReference!
    var assets: [DKAsset]?
    var currentUserId = ""
    var pickOption = ["Japanese", "Mathematics", "Science", "Sociology", "English","Other"]
    var photos = [UIImage]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UITabBar.appearance().tintColor
        self.previewView?.backgroundColor = UITabBar.appearance().tintColor
        self.closebutton.setTitleColor(UITabBar.appearance().tintColor, for: .normal)
        self.postbutton.setTitleColor(UITabBar.appearance().tintColor, for: .normal)
        self.photobutton.setTitleColor(UITabBar.appearance().tintColor, for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Database = FIRDatabase.database().reference()
        
        self.currentUserId = (FIRAuth.auth()?.currentUser!.uid)!
        previewView?.delegate = self
        previewView?.dataSource = self
        print("Username: \(self.currentUserId)")
        closebutton.layer.cornerRadius=30
        closebutton.layer.masksToBounds=true
        postbutton.layer.cornerRadius=25
        postbutton.layer.masksToBounds=true
        
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.text = "Type here"
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        subjectTextfield.inputView = pickerView
        subjectTextfield.inputAccessoryView = setToolBar()
        textView.inputAccessoryView = setKeyBoardToolBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func donePressedKey(sender: UIBarButtonItem){
        textView.resignFirstResponder()
    }
    
    func donePressed(sender: UIBarButtonItem) {
        subjectTextfield.resignFirstResponder()
    }
    
    func tappedToolBarBtn(sender: UIBarButtonItem) {
        subjectTextfield.text = "Japanese"
        subjectTextfield.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectTextfield.text = pickOption[row]
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type here"{
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func setToolBar() -> UIToolbar{
        let toolBar = UIToolbar(frame: CGRect(x:0,y: self.view.frame.size.height/6,width: self.view.frame.size.width,height: 40.0))
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.white
        let defaultButton = UIBarButtonItem(title: "Japanese", style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedToolBarBtn))
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressed))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        label.font = UIFont(name: "Helvetica", size: 12)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "Pick Subject"
        label.textAlignment = NSTextAlignment.center
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        return toolBar
    }
    
    func setKeyBoardToolBar() -> UIToolbar{
        let toolBarKeyBoard = UIToolbar(frame: CGRect(x:0,y: self.view.frame.size.height/6,width: self.view.frame.size.width,height: 40.0))
        toolBarKeyBoard.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBarKeyBoard.barStyle = UIBarStyle.blackTranslucent
        toolBarKeyBoard.tintColor = UIColor.white
        toolBarKeyBoard.backgroundColor = UIColor.white
        let doneButtonKey = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(donePressedKey))
        let flexSpaces = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolBarKeyBoard.setItems([flexSpaces,flexSpaces,flexSpaces,flexSpaces,doneButtonKey], animated: true)
        return toolBarKeyBoard
    }
    
    @IBAction func post(){
        let postText = textView.text
        if postText != "" && subjectTextfield.text != "" {
            let date_formatter: DateFormatter = DateFormatter()
            date_formatter.locale     = NSLocale(localeIdentifier: "ja") as Locale!
            date_formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            let photoCount:Int = assets?.count ?? 0
            let newJoke: Dictionary<String, AnyObject> = [
                "text": postText! as AnyObject,
                "subject": subjectTextfield.text! as AnyObject,
                "now" : true as AnyObject,
                "reply":0 as AnyObject,
                "author": currentUserId as AnyObject,
                "date": date_formatter.string(from: NSDate() as Date) as AnyObject,
                "BestAnswer": "" as AnyObject,
                "Photo": photoCount as AnyObject
            ]
            let firebaseNewJoke = Database.child("post/").childByAutoId()
            if assets?.count != nil{
                uploadImage(key: firebaseNewJoke.key)
            }
            firebaseNewJoke.setValue(newJoke)
            let firebaseUserPost = Database.child("user/\((FIRAuth.auth()?.currentUser!.uid)!)/posts/").childByAutoId()
            firebaseUserPost.setValue(firebaseNewJoke.key)
            let alert = UIAlertController(title: title, message: "Post Succeeded", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: {(action: UIAlertAction!) -> Void in
                self.textView.text = "Type here"
                self.textView.textColor = UIColor.lightGray
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButton(sender: AnyObject) {
        showImagePickerWithAssetType(
            .allPhotos,
            sourceType: .both,
            maxSelectableCount: 4,
            allowsLandscape: false,
            singleSelect: false
        )}
}

extension PostViewController: UICollectionViewDataSource, UICollectionViewDelegate{
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
            self.previewView?.reloadData()
        }
        if UI_USER_INTERFACE_IDIOM() == .pad {
            pickerController.modalPresentationStyle = .formSheet
        }
        self.present(pickerController, animated: true) {}
    }
    
    func playVideo(_ asset: AVAsset) {
        let avPlayerItem = AVPlayerItem(asset: asset)
        
        let avPlayer = AVPlayer(playerItem: avPlayerItem)
        let player = AVPlayerViewController()
        player.player = avPlayer
        
        avPlayer.play()
        
        self.present(player, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource, UITableViewDelegate methods
    
    struct Demo {
        static let titles = [
            ["Pick All", "Pick photos only", "Pick videos only", "Pick All (only photos or videos)"],
            ["Take a picture"],
            ["Hides camera"],
            ["Allows landscape"],
            ["Single select"]
        ]
        static let types: [DKImagePickerControllerAssetType] = [.allAssets, .allPhotos, .allVideos, .allAssets]
    }
    
    
    // MARK: - UICollectionViewDataSource, UICollectionViewDelegate methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = self.assets![indexPath.row]
        var cell: UICollectionViewCell?
        var imageView: UIImageView?
        
        if asset.isVideo {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellVideo", for: indexPath)
            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImage", for: indexPath)
            imageView = cell?.contentView.viewWithTag(1) as? UIImageView
        }
        
        if let cell = cell, let imageView = imageView {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let tag = indexPath.row + 1
            cell.tag = tag
            asset.fetchFullScreenImage(false, completeBlock: { image, info in
                if cell.tag == tag {
                    imageView.image = image
                    imageView.contentMode = UIViewContentMode.scaleAspectFit
                }
            })
        }
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = assets![indexPath.row]
        image.fetchFullScreenImage(false, completeBlock: { images, info in
            let imageInfo = JTSImageInfo()
            imageInfo.image = images
            imageInfo.referenceRect = (self.previewView?.frame)!
            imageInfo.referenceView = self.previewView?.superview
            
            let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.image, backgroundStyle: JTSImageViewControllerBackgroundOptions.blurred)
            imageViewer?.show(from: self, transition: JTSImageViewControllerTransition.fromOriginalPosition)
        })
    }
    func uploadImage(key:String!){
        for (index,asset) in assets!.enumerated(){
            asset.fetchFullScreenImage(false, completeBlock: { image, info in
                let metadata = FIRStorageMetadata()
                //firebaseにプロフィールイメージをアップロードする
                let data: NSData = UIImagePNGRepresentation(image!)! as NSData
                let storageRef = self.storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post")
                self.profileRef = storageRef.child("\(key!)/\(index).png")
                let uploadTask = self.profileRef.put(data as Data, metadata: metadata) { metadata, error in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                    }
                }
                uploadTask.observe(.progress) { snapshot in
                    // Upload reported progress
                    
                    if let progress = snapshot.progress {
                        let number = 100/self.assets!.count
                        let percentComplete = number * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
                        SVProgressHUD.show(withStatus: "\(index*number + percentComplete)/100")
                    }
                }
                uploadTask.observe(.success) { snapshot in
                    if index == self.assets!.count - 1{
                        SVProgressHUD.showSuccess(withStatus: "Successful!")
                        let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline:delayTime, execute:{ SVProgressHUD.dismiss() })
                    }
                }
            })
        }
    }
}
