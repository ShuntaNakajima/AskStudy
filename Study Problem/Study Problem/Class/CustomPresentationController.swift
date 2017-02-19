//
//  CustomPresentationController.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/01.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import UIKit
final class CustomPresentationController: UIPresentationController {
    var overlayView = UIView()
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else {
            return
        }
        overlayView.frame = containerView.bounds
        overlayView.gestureRecognizers = [UITapGestureRecognizer(target: self, action:#selector(CustomPresentationController.overlayViewDidTouch(sender:)))]
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.0
        containerView.insertSubview(overlayView, at: 0)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView.alpha = 0.7
            }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] context in
            self?.overlayView.alpha = 0.0
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            overlayView.removeFromSuperview()
        }
    }
    
    let margin = (x: CGFloat(40), y: CGFloat(380))
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width - margin.x, height: parentSize.height - margin.y)
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView!.bounds
        let childContentSize = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds.size)
        presentedViewFrame.size = childContentSize
        presentedViewFrame.origin.x = margin.x / 2.0
        presentedViewFrame.origin.y = margin.y / 2.0
        
        return presentedViewFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        overlayView.frame = containerView!.bounds
        presentedView!.frame = frameOfPresentedViewInContainerView
    }
    
    override func containerViewDidLayoutSubviews() {
    }
    
    func overlayViewDidTouch(sender: AnyObject) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
