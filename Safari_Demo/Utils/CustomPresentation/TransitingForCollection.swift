//
//  TransitingForCollection.swift
//  Safari_Demo
//
//  Created by Allen long on 2019/10/31.
//  Copyright © 2019 autocareai. All rights reserved.
//

import UIKit

enum ViewControllerAnimationType {
    case present
    case dismiss
}

class TransitingForCollection: NSObject {
    var type: ViewControllerAnimationType!
    init(type: ViewControllerAnimationType) {
        super.init()
        self.type = type
    }
    
}

extension TransitingForCollection : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if self.type == .present {
            return 0.3
        }else{
            return 0.1
        }
        
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.type == .present {
            animatedPresentWithContext(transitionContext: transitionContext)
        }else{
            animatedDismissWithContext(transitionContext: transitionContext)
        }
    }
    func animatedPresentWithContext(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        let frame = CGRect(x: 0, y: navigationH, width: kScreenW, height: kScreenH - navigationH)
        toVC.view.frame = frame
        toVC.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        toVC.view.alpha = 0
        containerView.addSubview(toVC.view)
        UIView.animate(withDuration: 0.1, animations: {
            toVC.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            toVC.view.alpha = 1
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
    
    func animatedDismissWithContext(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        UIView.animate(withDuration: 0.1, animations: {
            fromVC.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            fromVC.view.alpha = 0
        }) { (finished) in
            transitionContext.completeTransition(finished)
        }
    }
    
}


