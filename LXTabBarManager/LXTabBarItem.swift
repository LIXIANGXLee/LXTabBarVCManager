//
//  LXTabBarItem.swift
//  LXTabBarVCManager
//
//  Created by Mac on 2020/4/25.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - TabBarItem
public class LXTabBarItem: UITabBarItem {
   private var item: Item
   public init(_ item: Item) {
     self.item = item
     super.init()
     self.setContent()
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LXTabBarItem {
    //设置内容
    private func setContent() {
        title = item.title
        image = item.image.withRenderingMode(.alwaysOriginal)
        selectedImage = item.selectImage.withRenderingMode(.alwaysOriginal)
    }
    
    /// 外部调用 设置角标
    public func setBadge(with value: String ) {
         badgeValue = (value.count > 0) ? value : nil
    }
    
    /// 外部调用 设置角标颜色和字体大小
    public func setBadge(with color: UIColor, textSize: CGFloat) {
        if #available(iOS 10.0, *) {
            setBadgeTextAttributes([.font : UIFont.systemFont(ofSize: textSize),.foregroundColor: color], for: UIControl.State.normal)
        }
    }
}
