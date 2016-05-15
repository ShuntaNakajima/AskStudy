//
//  ExSlideMenuController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/11/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ExSlideMenuController : SlideMenuController {

    override func isTagetViewController() -> Bool {
        if let vc = UIApplication.topViewController() {
            if vc is MainViewController ||
            vc is PostViewController ||
            vc is MypostViewController ||
                vc is JoinpostViewController ||
                vc is FollowViewController ||
                vc is NoticeViewController ||
                vc is SettingViewController {
                return true
            }
        }
        return false
    }
    
    override func track(trackAction: TrackAction) {
        switch trackAction {
        case .LeftTapOpen:
            print("TrackAction: left tap open.")
        case .LeftTapClose:
            print("TrackAction: left tap close.")
        case .LeftFlickOpen:
            print("TrackAction: left flick open.")
        case .LeftFlickClose:
            print("TrackAction: left flick close.")
        case .RightTapOpen:
            print("TrackAction: right tap open.")
        case .RightTapClose:
            print("TrackAction: right tap close.")
        case .RightFlickOpen:
            print("TrackAction: right flick open.")
        case .RightFlickClose:
            print("TrackAction: right flick close.")
        }   
    }
}
