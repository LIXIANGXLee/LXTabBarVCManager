//
//  LXTabBarController.swift
//  LXTabBarVCManager
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - 协议
@objc public protocol LXTabBarControllerDelegate: AnyObject {
       
    /// tabItem 点击事件回调
   @objc optional  func lxTabBarController(_ tabBarController: LXTabBarController,didSelect index: Int)

}

// MARK: - TabBarController
open class LXTabBarController: UITabBarController {

    /// 代理监听回调
    public weak var delegate_lx: LXTabBarControllerDelegate?

    private var controllers: [UIViewController.Type]
    private var items: [Item]
    private var navVC: UINavigationController.Type?
    private var config: LXConfig?
    private var tabBarItems = [LXTabBarItem]()

    // 自定义的 tabBar
    private lazy var lxTabBar: LXTabBar =  LXTabBar()
    fileprivate lazy var animatedTransitor = LXTabBarVCAnimatedTransitor(self)

     /// 添加指定构造器
     ///
     /// - Parameters:
     ///   - controllers: 子控制器
     ///   - items:  item 按钮
     ///   - config: 相关配置信息
     ///   - navVC:  导航控制器
     ///   - isAnimation: 切换控制器时是否存在动画
    public init (_ controllers: [UIViewController.Type],
                 _ items: [Item],
                 config: LXConfig? = nil,
                 navVC: UINavigationController.Type? = nil,
                 isAnimation: Bool = false)
    {
        self.controllers = controllers
        self.items = items
        self.navVC = navVC
        self.config = config
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.white
        if isAnimation {
            delegate = animatedTransitor
              animatedTransitor.finishDidSelect = { [weak self] (transitor,index) in
                  self?.delegate_lx?.lxTabBarController?(self!, didSelect: index)
            }
        }else {
            delegate = self
        }
       
        // 初始化tabBar
        setTabBarUI()
        // 初始化UI
        setItemsAndVcsUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - TabBarController
extension LXTabBarController {
    
    /// 外部调用 设置角标
    ///
    /// - Parameters:
    ///   - value:  要设置的值
    ///   - index:  item 按钮 索引
    public func setBadge(with value: String , index: Int) {
        if index >= tabBarItems.count || index < 0 { return }
        tabBarItems[index].setBadge(with: value)
    }
    
    /// 外部调用 设置角标颜色和字体大小
    ///
    /// - Parameters:
    ///   - color:  要设置的颜色
    ///   - textSize:  字体大小
    public func setBadge(with color: UIColor, textSize: CGFloat) {
        for item in tabBarItems {
            item.setBadge(with: color, textSize: textSize)
        }
    }
}

// MARK: - TabBarController UI 初始化
extension LXTabBarController {
    
    ///重置tabBar
    private func setTabBarUI() {
        setValue(lxTabBar, forKey: "tabBar")
        lxTabBar.config = config ?? LXConfig()
        lxTabBar.callTapAction = {[weak self] centerView in
            self?.selectedIndex = centerView.tag
            self?.delegate_lx?.lxTabBarController?(self!, didSelect: centerView.tag)
        }
    }
    
    /// 根据控制器 创建导航控制
    private func getNav(_ vc: UIViewController) -> UINavigationController {
        if  self.navVC != nil {
           return self.navVC!.init(rootViewController: vc)
        }else{
            return UINavigationController(rootViewController: vc)
        }
    }
    
    /// item 和 VC UI 创建
    private func setItemsAndVcsUI() {
        if controllers.count != items.count { return }
        
        ///添加中间按钮
        if let config = config?.centerConfig {
            
            controllers.insert(config.centerVC.self, at: items.count / 2 )
            let item = Item(title: nil, image:nil, selectImage:nil)
            items.insert(item, at: items.count / 2 )
        }
        
        ///初始化所有item和vc
        for (index,value) in self.controllers.enumerated() {
            let controller = value.init()
            
            let tabBarItem = LXTabBarItem(self.items[index])
            tabBarItems.append(tabBarItem)
            controller.tabBarItem = tabBarItem
            
            ///添加中间特殊按钮对应的控制器
             if let config = config?.centerConfig, controller.isKind(of: config.centerVC.self) {
                controller.tabBarItem.isEnabled = false
             }
            
            //添加子控制
           addChild(getNav(controller))
        }
    }
}

// MARK: - TabBarController 点击事件回调
extension LXTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        delegate_lx?.lxTabBarController?(self, didSelect: tabBarController.selectedIndex)
    }
}
