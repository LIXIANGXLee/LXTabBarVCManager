//
//  LXCustomInteraction.swift
//  LXTabBarVCManager
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

@objc protocol LXCustomInteractionDelegate: AnyObject {
    @objc optional func customInteraction(_ customInteraction: LXCustomInteraction,index: Int)
}

class LXCustomInteraction: UIPercentDrivenInteractiveTransition {
     fileprivate let tabBarVC: UITabBarController
    
     var isInteractive = false
     weak var delegate: LXCustomInteractionDelegate?
    
    init(tabBarVC: UITabBarController){
        self.tabBarVC = tabBarVC
        super.init()
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(pan:)))
        tabBarVC.view.addGestureRecognizer(pan)
    }
}

extension LXCustomInteraction {
    @objc fileprivate func handlePan(pan: UIPanGestureRecognizer){
        let translationX = pan.translation(in: pan.view).x
        let progress = abs(translationX / UIScreen.main.bounds.width)
        
        switch pan.state {
        case .began:
            isInteractive = true
            //也可通过pan.velocity来判断
            if translationX < 0 {
                //用户在往左滑--相当于之前operation的toright
                if tabBarVC.selectedIndex <= tabBarVC.viewControllers!.count - 2{
                    tabBarVC.selectedIndex += 1
                }
            }else{
                //用户在往右滑--相当于之前operation的toleft
                if tabBarVC.selectedIndex >= 1{
                    tabBarVC.selectedIndex -= 1
                }
            }
        case .changed:
            update(progress)
        case .cancelled , .ended:
            isInteractive = false
            if progress > 0.5 {
                 finish()
                 delegate?.customInteraction?(self, index: tabBarVC.selectedIndex)
            }else {
                 cancel()
            }
            
        default:
            break
        }
    }
}
