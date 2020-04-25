//
//  AppDelegate.swift
//  LXTabBarVCManager
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 XL. All rights reserved.
//

import UIKit
import LXTabBarManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?
    var tabBarVC : LXTabBarController!
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
               config.titleTextSelectedColor = UIColor.orange
               config.backgroundImage = UIImage(named: "截屏2020-04-25 上午10.37.49")
           let centerView = UIButton(type: .custom)
           centerView.setBackgroundImage(UIImage(named: "tabBar_publish_click_icon"), for: UIControl.State.highlighted)
           centerView.setBackgroundImage(UIImage(named: "tabBar_publish_icon"), for: UIControl.State.normal)
           centerView.setTitleColor(UIColor.lightGray, for: .normal)
           config.centerConfig = LXCenterConfig(centerView: centerView, centerViewSize: CGSize(width: 49, height: 49))
           tabBarVC =  LXTabBarController(vcs, items,config: config)
           tabBarVC.delegate_lx  = self
           tabBarVC.centerVC?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "扫码", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backClick))
        
       
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
        print("======\(index)")
//        if index != 2 {
             tabBarController.setBadge(with: "98", index: -1)
//        }
    }
    
    func lxTabBarController(_ tabBarController: LXTabBarController) -> UIView {
         let view = UIView(frame: CGRect(x: 100, y: 100, width: 375, height: 667))
        view.backgroundColor = UIColor.orange
        return view
    }
}
