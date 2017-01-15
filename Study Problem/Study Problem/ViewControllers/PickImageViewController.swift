//
//  PickImageViewController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/10/09.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import UIKit
import Photos
import AVKit
import DKImagePickerController


class ViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var previewView: UICollectionView?
    var assets: [DKAsset]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
            imageView.image = cropImageToSquare(image: (asset as? UIImage)!)
        }
        
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.assets![indexPath.row]
    }
    @IBAction func image(){
        showImagePickerWithAssetType(            .allPhotos,
                                                 sourceType: .both,
                                                 maxSelectableCount: 4,
                                                 allowsLandscape: false,
                                                 singleSelect: true
        )
    }
    func cropImageToSquare(image: UIImage) -> UIImage? {
        if image.size.width > image.size.height {
            let cropCGImageRef = image.cgImage!.cropping(to: CGRect(x:image.size.width/2 - image.size.height/2,y: 0,width: image.size.height,height: image.size.height))
            
            return UIImage(cgImage: cropCGImageRef!)
        } else if image.size.width < image.size.height {
            let cropCGImageRef = image.cgImage!.cropping(to: CGRect(x:0,y: 0,width: image.size.width,height: image.size.width))
            
            return UIImage(cgImage: cropCGImageRef!)
        } else {
            return image
        }
    }
}
