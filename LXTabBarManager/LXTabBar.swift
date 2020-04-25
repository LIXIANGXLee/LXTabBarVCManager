//
//  LXTabBar.swift
//  LXTabBarVCManager
//
//  Created by XL on 2020/4/24.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

///点击事件回调
public typealias CallTapAction = ((UIView) -> ())

// MARK: - TabBar 自定义处理
public class LXTabBar: UITabBar {

    ///中间的view配置
    private var centerConfig: LXCenterConfig?
    
    ///事件回调
    public var callTapAction: CallTapAction?
    
    ///配置信息
    public var config: LXConfig? {
        didSet {
            guard let config = config else { return }
            //bar 背景图片和阴影设置
            setBgBarImage(config)
            // bar 文字颜色设置和文字大小
            setBarTitleColor(config)
            //bar 中间按钮设置
            setCenterView(config)
        }
    }
}
    

///扩展 私有
extension LXTabBar {
    ///事件监听
    @objc private func tapAction(_ gesture: UIGestureRecognizer) {
        ///预防连点击
        gesture.view?.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            gesture.view?.isUserInteractionEnabled = true
        }
        callTapAction?(centerConfig!.centerView)
    }
    
    ///图片设置
    private func setBgBarImage(_ config: LXConfig) {
        UITabBar.appearance().backgroundImage =  config.backgroundImage
        UITabBar.appearance().shadowImage = config.shadowImage
    }
    
    ///文字颜色设置
    private func setBarTitleColor(_ config: LXConfig) {
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -config.titlePositionVertical)
    UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: config.titleTextSelectedColor,.font:UIFont.systemFont(ofSize: config.titleSize)], for: .selected)
    UITabBarItem.appearance().setTitleTextAttributes([.font:UIFont.systemFont(ofSize: config.titleSize)], for: .normal)
        if #available(iOS 10.0, *) {
            unselectedItemTintColor = config.titleTextColor
        }
    }
    
    ///中间view设置
    private func setCenterView(_ config: LXConfig) {
        //中间的view配置
        centerConfig = config.centerConfig
        guard let cType = config.centerConfig else { return }
        addSubview(cType.centerView)
    cType.centerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
}

///扩展 公开
extension LXTabBar {
    
    ///响应事件的view
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let cType = config?.centerConfig , !isHidden {
            let newP = self.convert(point, to: cType.centerView)
            if cType.centerView.point(inside: newP, with: event) {
                return cType.centerView
            }else{
                 return super.hitTest(point, with: event)
            }
        }else{
           return super.hitTest(point, with: event)
        }
    }
    
    /// UI布局
    public override func layoutSubviews() {
        super.layoutSubviews()
        let colCount = (subviews.count - ((centerConfig != nil) ? 2 : 1)) / 2
        
        if let cType = centerConfig {
            cType.centerView.tag = colCount
            cType.centerView.frame.size = cType.centerViewSize
            cType.centerView.center = CGPoint(x: center.x, y: (frame.size.height - CGFloat(LXConst.touchBarH))  * 0.5 - cType.centerOffY)
            
            //是否有圆角
            if let cor = cType.cornerRadius {
                cType.centerView.layer.cornerRadius = cor
                cType.centerView.clipsToBounds = true
            }
        }
        
        var index = 0
        let w: CGFloat = LXConst.screenW / CGFloat(subviews.count - ((centerConfig != nil) ? 2 : 1));
        let h: CGFloat = 49
        for view in subviews {
            if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                view.frame = CGRect(x: w * CGFloat(index), y: 0, width: w, height: h)
                index += 1
            }
        }
    }
}
