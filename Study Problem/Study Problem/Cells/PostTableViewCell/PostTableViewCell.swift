//
//  postTableViewCell.swift
//
//
//  Created by nakajimashunta on 2016/05/15.
//
//

import UIKit
import Firebase
import WebImage

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var textView : MainCellLabel!
    @IBOutlet var profileImage: MainCellUiimageView!
    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var replyscountLabel : UILabel!
    @IBOutlet var subjectLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    @IBOutlet var view:UIView!
    @IBOutlet var menuButton:UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        for (index,i) in self.view.subviews.enumerated(){
        switch i{
        case is OnePhotoView: let nib = self.view.subviews[index] as! OnePhotoView
            nib.cancelReload()
        case is TwoView: let nib = self.view.subviews[index] as! TwoView
        nib.cancelReload()
        case is ThreeView: let nib = self.view.subviews[index] as! ThreeView
        nib.cancelReload()
        case is FourView: let nib = self.view.subviews[index] as! FourView
        nib.cancelReload()
        default:break
        }
        }
    }
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
    func setNib(photos:Int,key:String,on:UIViewController){
        var imagePhotos = [String!]()
        if photos != 0{
            switch photos{
            case 1:
                let nib = OnePhotoView.instance()
                nib.frame = self.view.bounds
                self.view.addSubview(nib)
                for i in 0...photos - 1{
                    imagePhotos.append("\(key)/\(i)")
                    nib.setImage(images: imagePhotos,on:on)
                }
            case 2:
                let nib = TwoView.instance()
                nib.frame = self.view.bounds
                self.view.addSubview(nib)
                for i in 0...photos - 1{
                    imagePhotos.append("\(key)/\(i)")
                    nib.setImage(images: imagePhotos,on:on)
                }
            case 3:
                let nib = ThreeView.instance()
                nib.frame = self.view.bounds
                self.view.addSubview(nib)
                for i in 0...photos - 1{
                    imagePhotos.append("\(key)/\(i)")
                    nib.setImage(images: imagePhotos,on:on)
                }
            case 4:
                let nib = FourView.instance()
                nib.frame = self.view.bounds
                self.view.addSubview(nib)
                for i in 0...photos - 1{
                    imagePhotos.append("\(key)/\(i)")
                    nib.setImage(images: imagePhotos,on:on)
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

