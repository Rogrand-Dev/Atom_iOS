//
//  ItemsView.swift
//  MineView
//
//  Created by 刘岭 on 2017/5/31.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

public struct ItemInfo {
    var logo: UIImage
    var title: String
    var action: (() -> Void)
    
    init(logo: UIImage, title: String, action: @escaping (() -> Void)) {
        self.logo = logo
        self.title = title
        self.action = action
    }
}

class ItemsView: UIView {

    var fontSize: CGFloat?=nil
    var itemInfos: [ItemInfo] = [] {
        didSet {
            setupViews()
        }
    }
    
    var needSeparate: Bool
    
    init(isSeparate: Bool) {
        needSeparate = isSeparate
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        var format:String = ""
        var views: [String: UIView] = [:]
        
        for (i, itemInfo) in itemInfos.enumerated()
        {
            let view = ItemView.init(logo: itemInfo.logo, title: itemInfo.title, beTouched: itemInfo.action)
            view.titleLab.font = UIFont.systemFont(ofSize: fontSize ?? 12)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            
            let viewKey = "view\(i)"
            if i == 0 {
                format = "[view0(>=20)]"
            } else {
                format += "[\(viewKey)(==view0)]"
            }
            views["\(viewKey)"] = view

            // 最后一个视图不需要分割线
            guard i < itemInfos.count - 1 else {
                continue
            }
            
            if !needSeparate {
                format += "-0-"
            } else {
                view.separate(direction: [.right], spaceSize: 10)
            }
        }
        
        if views.keys.count > 0
        {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view0]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-\(format)-0-|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views))
        }

    }
    
}

class ItemView: UIView {
    lazy var logoImageV: UIImageView = UIImageView.init().then { (logoImageV) in
        
        logoImageV.contentMode = .scaleAspectFit
        logoImageV.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var titleLab: UILabel = UILabel.init().then { (titleLab) in
        
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.black
        titleLab.font = UIFont.systemFont(ofSize: 12)
        titleLab.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var viewTouch: (() -> Void)? = nil
    
    init(logo:UIImage, title: String, beTouched: (() -> Void)? = nil) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
        
        titleLab.text = title
        logoImageV.image = logo
        viewTouch = beTouched
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func touch() {
        self.viewTouch?()
    }
    
    private func setupViews() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.touch)))

        if #available(iOS 9.0, *)
        {
            self.addSubview(titleLab)
            self.addSubview(logoImageV)

            let layoutGuide = UILayoutGuide()
            self.addLayoutGuide(layoutGuide)

            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[logoImageV]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["logoImageV":logoImageV]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[logoImageV]-8-[titleLab]", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: ["logoImageV":logoImageV, "titleLab":titleLab]))
            self.addConstraint(NSLayoutConstraint.init(item: layoutGuide, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint.init(item: logoImageV, attribute: .top, relatedBy: .equal, toItem: layoutGuide, attribute: .top, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint.init(item: titleLab, attribute: .bottom, relatedBy: .equal, toItem: layoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0))
            
        } else {
            let layoutGuide = UIView()
            layoutGuide.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(layoutGuide)
            layoutGuide.addSubview(self.logoImageV)
            layoutGuide.addSubview(self.titleLab)
            
            self.addConstraint(NSLayoutConstraint.init(item: layoutGuide, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint.init(item: layoutGuide, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
            layoutGuide.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[titleLab]-0-|", options: .directionLeadingToTrailing, metrics: nil, views: ["titleLab":self.titleLab]))
            layoutGuide.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[logoImageV]-8-[titleLab]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: ["logoImageV":self.logoImageV, "titleLab":titleLab]))
            
        }
        
    }
    
}
