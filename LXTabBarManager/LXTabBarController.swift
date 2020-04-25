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
    
    /// 从外部获取自定义的view 显示到LXCenterController
   @objc optional func lxTabBarController(_ tabBarController: LXTabBarController) -> UIView
    
    /// tabItem 点击事件回调
   @objc optional  func lxTabBarController(_ tabBarController: LXTabBarController,didSelect index: Int)

}

// MARK: - TabBarController
open class LXTabBarController: UITabBarController {

    /// 代理监听回调
    public var delegate_lx: LXTabBarControllerDelegate?
    
    ///中间按钮对应的控制器（可用作外部设置导航用）
    public private(set) var centerVC: LXCenterController?

    private var controllers: [UIViewController.Type]
    private var items: [Item]
    private var navVC: UINavigationController.Type?
    private var config: LXConfig?

    // 自定义的 tabBar
    private lazy var lxTabBar: LXTabBar =  LXTabBar()
    
    /// 添加指定构造器
    public init (_ controllers: [UIViewController.Type], _ items: [Item],config: LXConfig? = nil, navVC: UINavigationController.Type? = nil) {
        
        self.controllers = controllers
        self.items = items
        self.navVC = navVC
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        //重置tabBar
        setValue(lxTabBar, forKey: "tabBar")
        lxTabBar.config = config ?? LXConfig()
        lxTabBar.callTapAction = {[weak self] centerView in
            self?.selectedIndex = centerView.tag
            self?.delegate_lx?.lxTabBarController?(self!, didSelect: centerView.tag)
        }
        
        // 初始化UI
        setItemsAndVcsUI()
    }
    
}

// MARK: - TabBarController UI 初始化
extension LXTabBarController {
    /// 根据控制器 创建导航控制
    private func getNav(_ vc: UIViewController) -> UINavigationController {
        if  self.navVC != nil {
           return self.navVC!.init(rootViewController: vc)
        }else{
            return UINavigationController(rootViewController: vc)
        }
    }
    
    /// UI 创建
    private func setItemsAndVcsUI() {
        if controllers.count != items.count { return }
        
        ///添加中间按钮
        if let _ = config?.centerConfig  {
            controllers.insert(LXCenterController.self, at: items.count / 2 )
            let item = Item(title: "", image: UIImage(), selectImage: UIImage())
            items.insert(item, at: items.count / 2 )
        }
        
        ///初始化所有item和vc
        for (index,value) in self.controllers.enumerated() {
            let controller = value.init()

            let item = self.items[index]
            controller.tabBarItem.title = item.title
            controller.tabBarItem.image = item.image.withRenderingMode(.alwaysOriginal)
            controller.tabBarItem.selectedImage = item.selectImage.withRenderingMode(.alwaysOriginal)
            
            ///添加中间特殊按钮对应的控制器
            if controller.isKind(of: LXCenterController.self) {
                controller.tabBarItem.isEnabled = false
                controller.view = delegate_lx?.lxTabBarController?(self)
                self.centerVC = controller as? LXCenterController
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
