//
//  LXConfig.swift
//  LXTabBarVCManager
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - 中间按钮配置信息
public struct LXCenterConfig {
    ///中间的view
    public var centerView: UIView
    ///中间view的尺寸
    public var centerViewSize: CGSize
    /// 在y坐标上偏移量
    public var centerOffY: CGFloat = 0.0
    /// 圆角大小
    public var cornerRadius: CGFloat?
    ///指定构造器
    public init(centerView: UIView, centerViewSize: CGSize) {
        self.centerView = centerView
        self.centerViewSize = centerViewSize
    }
}

// MARK: - tabBar配置信息
public struct LXConfig {

   ///字体大小
   public var titleSize: CGFloat = 10
   ///文本偏移量
   public var titlePositionVertical: CGFloat = 3
   ///文本默认颜色
   public var titleTextColor: UIColor = UIColor.lightGray
   ///文本选中颜色
   public var titleTextSelectedColor: UIColor = UIColor.orange
   ///tabBar背景颜色
   public var backgroundImage: UIImage?
   ///阴影颜色
   public var shadowImage: UIImage?
    ///中间的view
   public var centerConfig: LXCenterConfig?
   ///指定构造器
   public init() {}

}

// MARK: - 构建Item
public struct Item {
   public var title: String
   public var image: UIImage
   public var selectImage: UIImage
   
    ///指定构造器
   public init(title: String, image: UIImage, selectImage: UIImage) {
        self.title = title
        self.image = image
        self.selectImage = selectImage
    }
}

// MARK: - 常量配置信息
public struct LXConst {
    //app屏幕宽度
    public static let screenW = UIScreen.main.bounds.width
    //app屏幕高度
    public static let screenH = UIScreen.main.bounds.height
    //tabBar 的刘海高度
    public static let touchBarH  = isIPhoneX ? CGFloat(34.0) : CGFloat(0.0)
    public static let isIPhoneX = (LXConst.screenH == CGFloat(812) || LXConst.screenH == CGFloat(896)) ? true : false
    //屏幕相比iPhone6的宽度比例
    public static let scale = LXConst.screenW / CGFloat(375.0)
}
