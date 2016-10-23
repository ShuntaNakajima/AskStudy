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

        // Configure the view for the selected state
    }
    func setNib(photos:Int,key:String,on:UIViewController){
        var imagePhotos = [UIImage]()
        if photos != 0{
        for i in 0...photos - 1{
            DispatchQueue.global().async(execute:{
                var viewImg = UIImage()
                let storage = FIRStorage.storage()
                let storageRef = storage.reference(forURL: "gs://studyproblemfirebase.appspot.com/post")
                let autorsprofileRef = storageRef.child("\(key)/\(i).png")
                autorsprofileRef.data(withMaxSize: 1 * 1028 * 1028) { (data, error) -> Void in
                    if error != nil {
                        print(error)
                    } else {
                        viewImg = data.flatMap(UIImage.init)!
                        DispatchQueue.main.async(execute: {
                          imagePhotos.append(viewImg)
                            switch photos{
                            case 1:
                                let nib = OnePhotoView.instance()
                                nib.setImage(images: imagePhotos,on:on)
                                self.view.addSubview(nib)
                            case 2:
                                let nib = TwoView.instance()
                                nib.setImage(images: imagePhotos,on:on)
                                self.view.addSubview(nib)
                            case 3:
                                let nib = ThreeView.instance()
                                nib.setImage(images: imagePhotos,on:on)
                                self.view.addSubview(nib)
                            case 4:
                                let nib = FourView.instance()
                                nib.setImage(images: imagePhotos,on:on)
                                self.view.addSubview(nib)
                            default:
                                break
                            }
                        });
                    }
                }
            });
        }
        }else{
            self.view.translatesAutoresizingMaskIntoConstraints = true
            self.view.frame = self.textView.frame
        }
    }
}

