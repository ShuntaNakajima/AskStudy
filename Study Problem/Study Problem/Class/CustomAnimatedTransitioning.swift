//
//  CustomAnimatedTransitioning.swift
//  Study Problem
//
//  Created by nakajimashunta on 2016/08/02.
//  Copyright © 2016年 ShuntaNakajima. All rights reserved.
//

import Foundation
import UIKit
final class CustomAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresent: Bool
    let atButton: UIButton
    
    init(isPresent: Bool, atButton: UIButton?) {
        self.isPresent = isPresent
        self.atButton = atButton ?? UIButton(frame: CGRect.zero)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresent {
            animatePresentTransition(transitionContext: transitionContext)
        } else {
            animateDissmissalTransition(transitionContext: transitionContext)
        }
    }
    
    func animatePresentTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presentingController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
                    else {
                return
        }
        let containerView:UIView = transitionContext.containerView
        presentedController.view.layer.cornerRadius = 4.0
        presentedController.view.clipsToBounds = true
        presentedController.view.alpha = 0.0
        presentedController.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        containerView.insertSubview(presentedController.view, belowSubview: presentingController.view)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveLinear, animations: {
            presentedController.view.alpha = 1.0
            presentedController.view.frame.origin.x = containerView.bounds.size.width - self.atButton.frame.origin.x
            presentedController.view.frame.origin.y = containerView.bounds.size.height - self.atButton.frame.origin.y
            presentedController.view.transform = CGAffineTransform.identity
        }, completion: { finished in
            transitionContext.completeTransition(true)
        })
    }
    
    func animateDissmissalTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else {
            return
        }
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.6, options: .curveLinear, animations:{
            presentedController.view.alpha = 0.0
            presentedController.view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            presentedController.view.frame.origin.x = self.atButton.frame.origin.x
            presentedController.view.frame.origin.y = self.atButton.frame.origin.y
        }, completion: { finished in
            transitionContext.completeTransition(true)
        })
    }
}
