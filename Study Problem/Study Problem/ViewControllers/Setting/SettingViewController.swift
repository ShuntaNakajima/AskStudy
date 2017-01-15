//
//  SettingViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/05/13.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Firebase
import RSKImageCropper
import SVProgressHUD

class SettingViewController: UITableViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate  ,RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource,UITextFieldDelegate{
    //var Database = Firebase(url: "https://studyproblemfirebase.firebaseio.com/")
    @IBOutlet var profileimage:UIButton!
    @IBOutlet var emailTextField:UILabel!
    @IBOutlet var usernameTextField:UILabel!
    @IBOutlet var usernameTextFieldincell:UILabel!
     @IBOutlet var gradeTextField:UILabel!
    var Database = FIRDatabaseReference.init()
    let user = FIRAuth.auth()?.currentUser
    let storage = FIRStorage.storage()
    var profileImages : UIImage! = nil
    var profileRef : FIRStorageReference!
    var profileReforig : FIRStorageReference!
    var userDic=Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
        profileRef = storageRef.child("\((FIRAuth.auth()?.currentUser!.uid as String!)!)/profileimage.png")
        profileReforig = storageRef.child("\(FIRAuth.auth()?.currentUser!.uid as String!)/profileimageorig.png")
        profileimage.setBackgroundImage(profileImages, for: .normal)
        profileimage.layer.cornerRadius=35
        profileimage.clipsToBounds=true
        //        reportbutton.layer.cornerRadius=42
        //        reportbutton.clipsToBounds=true
        profileimage.layer.borderWidth = 2
        profileimage.layer.borderColor = UIColor.white.cgColor
        Database = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
        Database.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).observe(.value, with: { snapshot in
            if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                postDictionary["key"] = key as AnyObject?
                self.userDic = postDictionary
                self.usernameTextField.text = self.userDic["username"] as! String?
                self.usernameTextFieldincell.text = self.userDic["username"] as! String?
                self.emailTextField.text = self.userDic["email"] as! String?
                self.gradeTextField.text = self.userDic["grade"] as! String?
            }
            self.tableView.reloadData()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
            if error != nil {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                
                let Image = data.flatMap(UIImage.init)
                self.profileimage.setBackgroundImage(Image!, for: .normal)
            }
        }
        self.tabBarController?.tabBar.tintColor = UITabBar.appearance().tintColor
        self.navigationController?.navigationBar.topItem?.title = "AskStudy"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutbutton(){
        try! FIRAuth.auth()!.signOut()
        let viewController:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewControllers")
        self.present(viewController, animated: true, completion: nil)
    }
    @IBAction func profileimageeditButton(){
        let alertController = UIAlertController(title: "Change ProfileImage", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) {
            action in self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Choose from library", style: .default) {
            action in self.openLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
            action in
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // イメージ表示
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
        imageCropVC.delegate = self // 必須（下で実装）
        imageCropVC.dataSource = self
        imageCropVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(imageCropVC, animated: true)
        // 選択画面閉じる
        self.dismiss(animated: true, completion: nil)
        
    }
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
    }
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        let viewImg = croppedImage
        let resizedSize = CGSize(width:50,height: 50)
        UIGraphicsBeginImageContext(resizedSize)
        viewImg.draw(in: CGRect(x:0,y: 0,width: resizedSize.width,height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let metadata = FIRStorageMetadata()
         //firebaseにプロフィールイメージをアップロードする
        let data: NSData = UIImagePNGRepresentation(resizedImage!)! as NSData
        let uploadTask = profileRef.put(data as Data, metadata: metadata) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                
            }
            
        }
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            
            if let progress = snapshot.progress {
                let percentComplete = 50 * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
                SVProgressHUD.show(withStatus: "\(percentComplete)/100")
            }
        }
        uploadTask.observe(.success) { snapshot in
            let metadatas = FIRStorageMetadata()
            let data: NSData = UIImagePNGRepresentation(croppedImage)! as NSData
            let uploadTasks = self.profileReforig.put(data as Data, metadata: metadatas) { metadatas, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    
                }
                
            }
            uploadTasks.observe(.progress) { snapshot in
                // Upload reported progress
                
                if let progress = snapshot.progress {
                    let percentComplete = 50 * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
                    SVProgressHUD.show(withStatus: "\(50 + percentComplete)/100")
                }
            }
            uploadTasks.observe(.success) { snapshot in
                SVProgressHUD.showSuccess(withStatus: "Successful!")
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline:delayTime, execute:{ SVProgressHUD.dismiss() })
                self.profileimage.setBackgroundImage(resizedImage, for: .normal)
            }
            
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        
        var maskSize: CGSize
        var width, height: CGFloat!
        
        width = self.view.frame.width
        
        
        
        height = self.view.frame.width / 1
        //正方形
        
        maskSize = CGSize(width:self.view.frame.width,height: height)
        
        let viewWidth: CGFloat = controller.view.frame.width
        let viewHeight: CGFloat = controller.view.frame.height
        
        let maskRect: CGRect = CGRect(x:(viewWidth - maskSize.width) * 0.5, y:(viewHeight - maskSize.height) * 0.5, width:maskSize.width,height: maskSize.height)
        return maskRect
    }
    
    // トリミングしたい領域を描画
    func imageCropViewControllerCustomMaskPath(_ controller: RSKImageCropViewController) -> UIBezierPath {
        let rect: CGRect = controller.maskRect
        
        let point1: CGPoint = CGPoint(x:rect.minX,y: rect.maxY)
        let point2: CGPoint = CGPoint(x:rect.minX,y: rect.maxY)
        let point3: CGPoint = CGPoint(x:rect.minX,y: rect.maxY)
        let point4: CGPoint = CGPoint(x:rect.minX,y: rect.maxY)
        
        let square: UIBezierPath = UIBezierPath()
        square.move(to: point1)
        square.addLine(to: point2)
        square.addLine(to: point3)
        square.addLine(to: point4)
        square.close()
        
        return square
        
    }
    
    func imageCropViewControllerCustomMovementRect(_ controller: RSKImageCropViewController) -> CGRect {
        return controller.maskRect
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .camera
            self.present(controller, animated: true, completion: nil)
        }
    }
    func openLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
        
    }
}
