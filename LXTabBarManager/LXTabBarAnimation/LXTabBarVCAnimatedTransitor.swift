//
//  TabBarVCAnimatedTransitor.swift
//  TarBarController
//
//  Created by LIXIANG on 2019/10/14.
//  Copyright © 2019 LIXIANG. All rights reserved.
// UITabBarController 转场动画 处理 

import UIKit

enum Operation {
    //toRight相当于push，toLeft相当于pop
    case toRight
    case toLeft
}

class LXTabBarVCAnimatedTransitor: NSObject {
  
    public var finishDidSelect: ((_ tabBarVCAnimatedTransitor: LXTabBarVCAnimatedTransitor,_ index: Int) -> ())?
    fileprivate var customInteraction: LXCustomInteraction!
    required init(_ tabBarVC: UITabBarController) {
        customInteraction = LXCustomInteraction(tabBarVC: tabBarVC)
        super.init()
        customInteraction.delegate = self
    }
}

extension LXTabBarVCAnimatedTransitor: UITabBarControllerDelegate {
    
    ///非交互动画
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let fromIndex = tabBarController.viewControllers!.firstIndex(of: fromVC)!
        let toIndex = tabBarController.viewControllers!.firstIndex(of: toVC)!
        let operation: Operation = toIndex > fromIndex ? .toRight : .toLeft
        
        return LXCustomAnimator(operation: operation)
    }
    
     ///交互动画
    func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return customInteraction.isInteractive ? customInteraction : nil
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        finishDidSelect?(self,tabBarController.selectedIndex)
    }
}

extension LXTabBarVCAnimatedTransitor: LXCustomInteractionDelegate {
    func customInteraction(_ customInteraction: LXCustomInteraction, index: Int) {
        finishDidSelect?(self,index)
    }
}
