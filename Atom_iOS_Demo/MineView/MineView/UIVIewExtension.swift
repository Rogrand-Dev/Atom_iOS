//
//  UIVIewExtension.swift
//  MineView
//
//  Created by 刘岭 on 2017/6/2.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

struct SeparateDirection: OptionSet {
    public var rawValue = 0
    
    public static var top = SeparateDirection.init(rawValue: 1 << 0)
    public static var left = SeparateDirection.init(rawValue: 1 << 1)
    public static var bottom = SeparateDirection.init(rawValue: 1 << 2)
    public static var right = SeparateDirection.init(rawValue: 1 << 3)
}

extension UIView {
    
    
    func separateRight() {
        separate(direction: [.right])
    }
    
    func separate(direction: SeparateDirection, spaceSize: CGFloat) {
        separate(direction: [.right], spaceSize)
    }
    
    func separate(direction: SeparateDirection, _ spaceSize: CGFloat=0,_ size: CGFloat=0.5,_ lineColor: UIColor = UIColor.init(white: 0.85, alpha: 1.0)) {
        separate(direction: direction, spaceSize, spaceSize, size, lineColor)
    }
    
    func separate(direction: SeparateDirection, firstSpaceSize: CGFloat) {
        separate(direction: direction, firstSpaceSize)
    }
    
    /// 添加分割线
    ///
    /// - Parameters:
    ///   - direction: 相对父视图方向（上、下、左、右）
    ///   - firstSpace: 上／左边 空白大小
    ///   - secondSpace: 下／右边 空白大小
    ///   - size: 分割线大小
    ///   - lineColor: 分割线颜色
    private func separate(direction: SeparateDirection, _ firstSpace: CGFloat=0, _ secondSpace: CGFloat?=nil,_ size: CGFloat=0.5,_ lineColor: UIColor = UIColor.init(white: 0.85, alpha: 1.0)) {
        
        let line = { () -> UIView in
            let line = UIView.init()
            self.addSubview(line)
            line.backgroundColor = lineColor
            line.accessibilityIdentifier = "separatorLine"
            line.translatesAutoresizingMaskIntoConstraints = false
            return line
        }
        
        let secondSp = secondSpace ?? firstSpace
        let metrics = ["size":size, "firstSpace":firstSpace, "secondSpace":secondSp]
        var lineKey = ""
        var horFormat = ""
        var verFormat = ""
        
        if direction.contains(.top)
        {
            lineKey = "line_top"
            horFormat = "H:|-firstSpace-[\(lineKey)]-secondSpace-|"
            verFormat = "V:|-0-[\(lineKey)(==size)]"
            addLineConstraints(verFormat: verFormat, horFormat: horFormat, metrics: metrics, views: ["\(lineKey)": line()])
        }
        if direction.contains(.left)
        {
            lineKey = "line_left"
            horFormat = "H:|-0-[\(lineKey)(==size)]"
            verFormat = "V:|-firstSpace-[\(lineKey)]-secondSpace-|"
            addLineConstraints(verFormat: verFormat, horFormat: horFormat, metrics: metrics, views: ["\(lineKey)": line()])
        }
        if direction.contains(.right)
        {
            lineKey = "line_right"
            horFormat = "H:[\(lineKey)(==size)]-0-|"
            verFormat = "V:|-firstSpace-[\(lineKey)]-secondSpace-|"
            addLineConstraints(verFormat: verFormat, horFormat: horFormat, metrics: metrics, views: ["\(lineKey)": line()])
        }
        if direction.contains(.bottom)
        {
            lineKey = "line_bottom"
            horFormat = "H:|-firstSpace-[\(lineKey)]-secondSpace-|"
            verFormat = "V:[\(lineKey)(==size)]-0-|"
            addLineConstraints(verFormat: verFormat, horFormat: horFormat, metrics: metrics, views: ["\(lineKey)": line()])
        }
    }
    
    /// 添加普通约束
    ///
    /// - Parameters:
    ///   - verFormat: 垂直方向VFL
    ///   - horFormat: 水平方向VFL
    ///   - metrics: 数据字典
    ///   - views: 视图字典
    private func addLineConstraints(verFormat: String, horFormat: String, metrics: [String: CGFloat], views: [String: UIView]) {
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: verFormat, options: [.directionLeadingToTrailing], metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: horFormat, options: [.directionLeadingToTrailing], metrics: metrics, views: views))
        
    }
    
    /// 获取响应链上实现协议的响应者
    ///
    /// - Parameters:
    ///   - object: 当前响应者
    ///   - protocolType: 需要被实现的协议
    /// - Returns: 协议实现者
    public func getProtocolImplementer<T>(_ protocolType: T.Type) -> T?
    {
        var responder = self.next
        var protocolObject: T? = nil
        
        while (responder != nil && responder?.isKind(of: UIWindow.self) == false)
        {
            if let proto = responder as? T {
                protocolObject = proto
                break
            }
            responder = responder?.next
        }
        return protocolObject
    }
    
}



