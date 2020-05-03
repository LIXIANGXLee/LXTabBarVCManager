//
//  CustomAnimator.swift
//  CustomAnimator
//
//  Created by LIXIANG on 2019/10/8.
//  Copyright © 2019 LIXIANG. All rights reserved.
//

import UIKit

class LXCustomAnimator: NSObject,UIViewControllerAnimatedTransitioning {
    
    fileprivate let operation: Operation
    init(operation: Operation){
        self.operation = operation
        super.init()//可不写
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else{return}
        containerView.addSubview(toView)

        let offset = containerView.frame.width
        toView.frame.origin.x = operation == .toRight ? offset : -offset
        toView.alpha = 0
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromView.alpha = 0
                fromView.frame.origin.x = self.operation == .toRight ? -offset : offset
                
                toView.alpha = 1
                toView.frame.origin.x = 0
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
