//
//  AppDelegate.swift
//  LXTabBarVCManager
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 XL. All rights reserved.
//

import UIKit
import LXTabBarManager

class LXButton: UIButton {
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 47, width: contentRect.width, height: 12)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
      
        return CGRect(x: (contentRect.width - 40) * 0.5, y: 0, width: 42, height: 42)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    var tabBarVC : LXTabBarController!
    
    
    lazy var centerButton: LXButton = {
       let centerButton = LXButton(type: .custom)
       centerButton.setImage(UIImage(named: "tabbar_item_center"), for: UIControl.State.selected)
       centerButton.setImage(UIImage(named: "tabbar_item_center"), for: UIControl.State.normal)
       centerButton.setTitleColor(UIColor.lightGray, for: .normal)
       centerButton.setTitleColor(UIColor.red, for: .selected)
       centerButton.titleLabel?.textAlignment  = .center
       centerButton.setTitle("扫码支付", for: UIControl.State.normal)
       centerButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
       return centerButton
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let vcs = [UIViewController.self,UIViewController.self,UIViewController.self,UIViewController.self]
           
           let items = [
               Item(title: "首页", image: UIImage(named:"btn_home")!, selectImage: UIImage(named:"btn_home_selected")!),
               Item(title: "直播", image: UIImage(named:"btn_column")!, selectImage: UIImage(named:"btn_column_selected")!),
               Item(title: "关注", image: UIImage(named:"btn_live")!, selectImage: UIImage(named:"btn_live_selected")!),
               Item(title: "我的", image: UIImage(named:"btn_user")!, selectImage: UIImage(named:"btn_user_selected")!)]
     
           var config = LXConfig()
           config.titleTextColor = UIColor.lightGray
           config.titleSize = 12
           config.titleTextSelectedColor = UIColor.red
           config.backgroundImage = UIImage(named: "截屏2020-04-25 上午10.37.49")
                
        config.centerConfig = LXCenterConfig(centerVC: LXCenterViewController.self, centerView: centerButton, centerViewSize: CGSize(width: UIScreen.main.bounds.width / 5, height: 59),centerOffY: 10)
           tabBarVC = LXTabBarController(vcs, items,config: config,isAnimation: false)
           tabBarVC.delegate_lx  = self
       
        tabBarVC.setBadge(with: UIColor.blue, textSize: 15)
        self.window?.rootViewController = tabBarVC
        
        self.window?.makeKeyAndVisible()

        return true
    }
    
    @objc func backClick(_ btn: UIButton) {
        
        btn.isSelected = true
        
        print("扫码")
        
    }
    
    
}

extension AppDelegate: LXTabBarControllerDelegate {
    func lxTabBarController(_ tabBarController: LXTabBarController, didSelect index: Int) {
        centerButton.isSelected = index == 2
    }
}
