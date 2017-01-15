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

class SettingViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource, UITextFieldDelegate {
    
    @IBOutlet var profileImageButton: UIButton!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var usernameInGrayLabel: UILabel!
    @IBOutlet var gradeLabel:UILabel!
    
    let ref: FIRDatabaseReference = FIRDatabase.database().reference()
    let user: FIRUser? = FIRAuth.auth()?.currentUser
    let storage: FIRStorage = FIRStorage.storage()
    var profileImage: UIImage!
    var profileRef: FIRStorageReference!
    var profileReforig: FIRStorageReference!
    var userDic: [String: AnyObject] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isScrollEnabled = false
        let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/user")
        profileRef = storageRef.child("\((FIRAuth.auth()?.currentUser!.uid)!)/profileimage.png")
        profileReforig = storageRef.child("\(FIRAuth.auth()?.currentUser!.uid)/profileimageorig.png")
        profileImageButton.setBackgroundImage(profileImage, for: .normal)
        profileImageButton.layer.cornerRadius = 35
        profileImageButton.clipsToBounds = true
        profileImageButton.layer.borderWidth = 2
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        
        ref.child("user").child((FIRAuth.auth()?.currentUser!.uid)!).observe(.value, with: { snapshot in
            
            if var postDictionary = snapshot.value as? Dictionary<String, AnyObject> {
                let key = snapshot.key
                postDictionary["key"] = key as AnyObject?
                self.userDic = postDictionary
                self.usernameLabel.text = self.userDic["username"] as! String?
                self.usernameInGrayLabel.text = self.userDic["username"] as! String?
                self.emailLabel.text = self.userDic["email"] as! String?
                self.gradeLabel.text = self.userDic["grade"] as! String?
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        profileRef.data(withMaxSize: 1 * 1028 * 1028) { data, error in
            if error != nil {
                
                print("\(error?.localizedDescription)")
            } else {
                
                let image = data.flatMap(UIImage.init)
                self.profileImageButton.setBackgroundImage(image!, for: .normal)
            }
        }
        self.tabBarController?.tabBar.tintColor = UITabBar.appearance().tintColor
    }
    
    @IBAction func logoutbutton(){
        
        try! FIRAuth.auth()!.signOut()
        let viewController:UIViewController = self.storyboard!.instantiateViewController(withIdentifier: "LoginViewControllers")
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func profileimageeditButton(){
        
        let alertController = UIAlertController(title: "Change ProfileImage", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) {
            _ in self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Choose from library", style: .default) {
            _ in self.openLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageCropVC: RSKImageCropViewController = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.circle)
        imageCropVC.delegate = self
        imageCropVC.dataSource = self
        imageCropVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(imageCropVC, animated: true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, willCropImage originalImage: UIImage) {
        
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        
        let resizedSize: CGSize = CGSize(width:50,height: 50)
        UIGraphicsBeginImageContext(resizedSize)
        croppedImage.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let metadata = FIRStorageMetadata()
        let data: Data = UIImagePNGRepresentation(resizedImage!)!
        let uploadTask = profileRef.put(data, metadata: metadata) { metadata, error in
            if (error != nil) {
                
            } else {
                
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
            let data: Data = UIImagePNGRepresentation(croppedImage)!
            let uploadTasks = self.profileReforig.put(data as Data, metadata: metadatas) { metadatas, error in
                if (error != nil) {
                    
                } else {
                    
                }
            }
            uploadTasks.observe(.progress) { snapshot in
                
                if let progress = snapshot.progress {
                    let percentComplete = 50 * Int(progress.completedUnitCount) / Int(progress.totalUnitCount)
                    SVProgressHUD.show(withStatus: "\(50 + percentComplete)/100")
                }
            }
            uploadTasks.observe(.success) { snapshot in
                SVProgressHUD.showSuccess(withStatus: "Successful!")
                let delayTime = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline:delayTime, execute:{ SVProgressHUD.dismiss() })
                self.profileImageButton.setBackgroundImage(resizedImage, for: .normal)
            }
            
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func imageCropViewControllerCustomMaskRect(_ controller: RSKImageCropViewController) -> CGRect {
        
        let width: CGFloat = self.view.frame.width
        let maskSize: CGSize = CGSize(width: width, height: width)
        
        let viewWidth: CGFloat = controller.view.frame.width
        let viewHeight: CGFloat = controller.view.frame.height
        
        let maskRect: CGRect = CGRect(x: (viewWidth - maskSize.width) * 0.5, y: (viewHeight - maskSize.height) * 0.5, width: maskSize.width, height: maskSize.height)
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
            
            let controller: UIImagePickerController = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .camera
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func openLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let controller: UIImagePickerController = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = .photoLibrary
            self.present(controller, animated: true, completion: nil)
        }
    }
}
