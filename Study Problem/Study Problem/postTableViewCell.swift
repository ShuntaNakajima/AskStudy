//
//  postTableViewCell.swift
//
//
//  Created by nakajimashunta on 2016/05/15.
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class postTableViewCell: UITableViewCell {
    
    @IBOutlet var textView : MianCellTextView!
    @IBOutlet var profileImage: MainCellUiimageViewClass!
    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var replyscountLabel : UILabel!
    @IBOutlet var subjectLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    @IBOutlet var view:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setNib(photos:Int,key:String,on:UIViewController){
        var imagePhotos = [URL]()
        if photos != 0{
            switch photos{
            case 1:
                let nib = OnePhotoView.instance()
               // nib.resetview(on: on)
                nib.frame = self.view.bounds
                self.view.addSubview(nib)
                for i in 0...photos - 1{
                    //DispatchQueue.global().async(execute:{
                        let storage = FIRStorage.storage()
                        let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post")
                        let autorsprofileRef = storageRef.child("\(key)/\(i).png")
                        autorsprofileRef.downloadURL{(URL,error) -> Void in
                            if error != nil {
                                print(error)
                            } else {
                                print(URL!)
                           //     DispatchQueue.main.async(execute: {
                                    imagePhotos.append(URL!)
                                    nib.setImage(images: imagePhotos,on:on)
                            //    })
                            }
                        }
                   // })
                }
            case 2:
                let nib = TwoView.instance()
             //   nib.resetview(on: on)
                nib.frame = self.view.bounds
                self.view.addSubview(nib)
                for i in 0...photos - 1{
                   // DispatchQueue.global().async(execute:{
                        let storage = FIRStorage.storage()
                        let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post")
                        let autorsprofileRef = storageRef.child("\(key)/\(i).png")
                        autorsprofileRef.downloadURL{(URL,error) -> Void in
                            if error != nil {
                                print(error)
                            } else {
                                print(URL!)
                           //     DispatchQueue.main.async(execute: {
                                    imagePhotos.append(URL!)
                                    nib.setImage(images: imagePhotos,on:on)
                           //     })
                            }
                        }
                    //})
                }
            case 3:
                let nib = ThreeView.instance()
               // nib.resetview(on: on)
                nib.frame = self.view.bounds
                self.view.addSubview(nib)
                for i in 0...photos - 1{
                 //   DispatchQueue.global().async(execute:{
                        let storage = FIRStorage.storage()
                        let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post")
                        let autorsprofileRef = storageRef.child("\(key)/\(i).png")
                        autorsprofileRef.downloadURL{(URL,error) -> Void in
                            if error != nil {
                                print(error)
                            } else {
                                print(URL!)
                              //DispatchQueue.main.async(execute: {
                                    imagePhotos.append(URL!)
                                    nib.setImage(images: imagePhotos,on:on)
                             //   })
                            }
                        }
                   // })
                }
            case 4:
                let nib = FourView.instance()
               // nib.resetview(on: on)
                nib.frame = self.view.bounds
                self.view.addSubview(nib)
                for i in 0...photos - 1{
                 //   DispatchQueue.global().async(execute:{
                        let storage = FIRStorage.storage()
                        let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post")
                        let autorsprofileRef = storageRef.child("\(key)/\(i).png")
                        autorsprofileRef.downloadURL{(URL,error) -> Void in
                            if error != nil {
                                print(error)
                            } else {
                                print(URL!)
                         //       DispatchQueue.main.async(execute: {
                                    imagePhotos.append(URL!)
                                    nib.setImage(images: imagePhotos,on:on)
                     //           })
                            }
                        }
                    //})
                }
            default:
                break
            }
        }else{
            self.view.translatesAutoresizingMaskIntoConstraints = true
            self.view.frame = CGRect(x:0,y: 99,width: 320,height: 0)
        }
    }
}

