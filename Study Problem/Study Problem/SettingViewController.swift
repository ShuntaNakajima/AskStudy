//
//  SettingViewController.swift
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
import RSKImageCropper
import SVProgressHUD

class SettingViewController: UITableViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate  ,RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource,UITextFieldDelegate{
    
    //var Database = Firebase(url: "https://studyproblemfirebase.firebaseio.com/")
    @IBOutlet var profileimage:UIButton!
    @IBOutlet var usernameTextField:UITextField!
    @IBOutlet var emailTextField:UITextField!
    var Database = FIRDatabaseReference.init()
    let user = FIRAuth.auth()?.currentUser
    let storage = FIRStorage.storage()
    var profileImages : UIImage! = nil
    var profileRef : FIRStorageReference!
    var profileReforig : FIRStorageReference!
    var userDic=Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        emailTextField.delegate = self
        tableView.scrollEnabled = false
        let storageRef = storage.referenceForURL("gs://studyproblemfirebase.appspot.com")
        profileRef = storageRef.child("\(FIRAuth.auth()?.currentUser!.uid as String!)/profileimage.png")
        profileReforig = storageRef.child("\(FIRAuth.auth()?.currentUser!.uid as String!)/profileimageorig.png")
        profileimage.setBackgroundImage(profileImages, forState: .Normal)
        profileimage.layer.cornerRadius=35
        profileimage.clipsToBounds=true
        //        reportbutton.layer.cornerRadius=42
        //        reportbutton.clipsToBounds=true
        profileimage.layer.borderWidth = 2
        profileimage.layer.borderColor = UIColor.whiteColor().CGColor
        Database = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
        Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).observeEventType(.Value, withBlock: { snapshot in
                    if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                        let key = snapshot.key
                        postDictionary["key"] = key
                        self.userDic = postDictionary
                        self.usernameTextField.text = self.userDic["username"] as! String?
                        self.emailTextField.text = self.userDic["email"] as! String?
                    }
                self.tableView.reloadData()
            })

    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        profileRef.dataWithMaxSize(1 * 1028 * 1028) { (data, error) -> Void in
            if error != nil {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                
                let Image = data.flatMap(UIImage.init)
                self.profileimage.setBackgroundImage(Image!, forState: .Normal)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func logoutbutton(){
        try! FIRAuth.auth()!.signOut()
        let viewController:UIViewController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewControllers")
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    @IBAction func profileimageeditButton(){
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        let cameraAction = UIAlertAction(title: "Take a photo", style: .Default) {
            action in self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Choose from library", style: .Default) {
            action in self.openLibrary()
        }
        let cancelAction = UIAlertAction(title: "Choose from library", style: .Cancel) {
            action in
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : AnyObject]) {
        // イメージ表示
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.Circle)
        imageCropVC.delegate = self // 必須（下で実装）
        imageCropVC.dataSource = self
        self.navigationController?.pushViewController(imageCropVC, animated: true)
        
        let efitco = SettingViewController()
        efitco.hidesBottomBarWhenPushed = true
        // 選択画面閉じる
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        let viewImg = croppedImage
        let resizedSize = CGSizeMake(50, 50)
        UIGraphicsBeginImageContext(resizedSize)
        viewImg.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let metadata = FIRStorageMetadata()
        
        
        
        //firebaseにプロフィールイメージをアップロードする
        let data: NSData = UIImagePNGRepresentation(resizedImage!)!
        let uploadTask = profileRef.putData(data, metadata: metadata) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                
            }
            
        }
        uploadTask.observeStatus(.Progress) { snapshot in
            // Upload reported progress
            
            if let progress = snapshot.progress {
                let percentComplete = 50 * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
                SVProgressHUD.showWithStatus("\(percentComplete)/100")
            }
        }
        uploadTask.observeStatus(.Success) { snapshot in
            let metadatas = FIRStorageMetadata()
            let data: NSData = UIImagePNGRepresentation(croppedImage)!
            let uploadTasks = self.profileReforig.putData(data, metadata: metadatas) { metadatas, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    
                }
                
            }
            uploadTasks.observeStatus(.Progress) { snapshot in
                // Upload reported progress
                
                if let progress = snapshot.progress {
                    let percentComplete = 50 * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
                    SVProgressHUD.showWithStatus("\(50 + percentComplete)/100")
                }
            }
            uploadTasks.observeStatus(.Success) { snapshot in
                SVProgressHUD.showSuccessWithStatus("Successful!")
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) { SVProgressHUD.dismiss() }
                self.profileimage.setBackgroundImage(resizedImage, forState: .Normal)
            }
            
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    func imageCropViewControllerCustomMaskRect(controller: RSKImageCropViewController) -> CGRect {
        
        var maskSize: CGSize
        var width, height: CGFloat!
        
        width = self.view.frame.width
        
        
        
        height = self.view.frame.width / 1
        //正方形
        
        maskSize = CGSizeMake(self.view.frame.width, height)
        
        let viewWidth: CGFloat = CGRectGetWidth(controller.view.frame)
        let viewHeight: CGFloat = CGRectGetHeight(controller.view.frame)
        
        let maskRect: CGRect = CGRectMake((viewWidth - maskSize.width) * 0.5, (viewHeight - maskSize.height) * 0.5, maskSize.width, maskSize.height)
        return maskRect
    }
    
    // トリミングしたい領域を描画
    func imageCropViewControllerCustomMaskPath(controller: RSKImageCropViewController) -> UIBezierPath {
        let rect: CGRect = controller.maskRect
        
        let point1: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))
        let point2: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))
        let point3: CGPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))
        let point4: CGPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))
        
        let square: UIBezierPath = UIBezierPath()
        square.moveToPoint(point1)
        square.addLineToPoint(point2)
        square.addLineToPoint(point3)
        square.addLineToPoint(point4)
        square.closePath()
        
        return square
        
    }
    
    func imageCropViewControllerCustomMovementRect(controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    func openLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
    }
    @IBAction func updateProfile(){
        SVProgressHUD.show()
        let user = FIRAuth.auth()?.currentUser
        user?.updateEmail(emailTextField.text!) { error in
            if let error = error {
               print(error)
                 SVProgressHUD.dismiss()
            } else {
                            self.Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("username").setValue(self.usernameTextField?.text!)
                        self.Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).child("email").setValue(self.emailTextField.text!)
                        let alert = UIAlertView()
                        alert.title = "Update Successful!"
                        alert.addButtonWithTitle("OK")
                        alert.show();
                        SVProgressHUD.dismiss()
        }

    }
}
}
