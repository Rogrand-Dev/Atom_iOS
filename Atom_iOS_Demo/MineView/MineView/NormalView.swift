//
//  NormalView.swift
//  MineView
//
//  Created by 刘岭 on 2017/6/2.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class CellBlockView: UIView {
    
    public struct CellInfo {
        var title: String
        var cellHeight: CGFloat?=nil
        var action: (() -> Void)
        var disclosureView: UIView?
        var needIndicator: Bool = true
        
        // 可使用 init() 初始化方法，并且 init(cellHeight: CGFloat) 设置高度失效
        init(title: String, cellHeight: CGFloat, _ disclosureView: UIView?=nil, action: @escaping (() -> Void)) {
            self.title = title
            self.action = action
            self.cellHeight = cellHeight
            self.disclosureView = disclosureView
        }
        
        // 依赖 init(cellHeight: CGFloat) 初始化方法
        init(title: String, _ disclosureView: UIView?=nil, action: @escaping (() -> Void)) {
            self.title = title
            self.action = action
            self.disclosureView = disclosureView
        }
    }
    
    public var index: Int = -1
    public var cellInfos:[CellInfo] = [] {
        didSet {
            setupViews()
        }
    }
    
    private var cellH: CGFloat
    init(cellHeight: CGFloat) {
        cellH = cellHeight
        super.init(frame: CGRect.zero)
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
    }
    
    init() {
        cellH = 0
        super.init(frame: CGRect.zero)
        self.clipsToBounds = true
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func cell(with title: String) -> CellView? {
        let index = self.cellInfos.index { (info) -> Bool in
            if info.title == title {
                return true
            }
            return false
        }
        return index == nil ? nil : cell(for: index!)
    }
    
    public func cell(for index: Int) -> CellView? {
        let view = viewWithTag(1639+index) as? CellView
        return view
    }
    
    private func setupViews() {
        self.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        defer {
            self.separate(direction: [.top, .bottom])
        }
        
        var verFormat: String = ""
        var views: [String: UIView] = [:]
        var verMetrics: [String: CGFloat] = [:]
        
        for (i, cellInfo) in cellInfos.enumerated() {
            
            let view = CellView.init()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = 1639+i
            view.needIndicator = cellInfo.needIndicator
            view.disclosureView = cellInfo.disclosureView
            view.set(title: cellInfo.title, lineTouch: cellInfo.action)
            let height = cellInfo.cellHeight ?? cellH
            
            let viewKey = "view\(i)"
            let heightKey = "cellH\(i)"
            if i == 0 {
                verFormat = "[view0(==cellH0)]"
            } else {
                verFormat += "[\(viewKey)(==\(heightKey))]"
            }
            views["\(viewKey)"] = view
            verMetrics["\(heightKey)"] = height
            
            self.addSubview(view)
            if i < cellInfos.count - 1 {
                verFormat += "-0-"
                view.separate(direction: [.bottom], firstSpaceSize: view.margin)
            }
        }
        
        if views.keys.count > 0
        {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view0]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: views))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-\(verFormat)-0-|", options: [.alignAllLeft, .alignAllRight], metrics: verMetrics, views: views))
        }
        
    }
    
}

class CellView: UIView {

    lazy var titleLab: UILabel = UILabel.init().then { (titleLab) in
        titleLab.textAlignment = .left
        titleLab.textColor = UIColor.black
        titleLab.font = UIFont.systemFont(ofSize: 14)
        titleLab.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLab)
    }
    
    public var needIndicator: Bool = true {
        didSet {
            disclosureIndicator.isHidden = !needIndicator
        }
    }
    private lazy var disclosureIndicator: UIImageView = UIImageView.init(image: #imageLiteral(resourceName: "icon_cell_rightArrow")).then { (disclosureIndicator) in
        disclosureIndicator.sizeToFit()
        disclosureIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(disclosureIndicator)
    }

    public var margin: CGFloat = 16
    public var lineTouch: (() -> Void)? = nil
    
    public var disclosureView: UIView? {
        willSet {
            disclosureView?.removeFromSuperview()
        }
        didSet {
            addDisclosureView()
        }
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func set(title: String, lineTouch: (() -> Void)? = nil) {
        titleLab.text = title
        self.lineTouch = lineTouch
    }
    
    @objc private func touch() {
        self.lineTouch?()
    }
    
    private func setupView() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.touch)))
        disclosureIndicator.sizeToFit()

        self.addConstraint(NSLayoutConstraint.init(item: titleLab, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-margin-[titleLab]",
            options: [.directionLeadingToTrailing],
            metrics: ["margin":margin],
            views: ["titleLab":titleLab]
        ))
        self.addConstraint(NSLayoutConstraint.init(item: disclosureIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[disclosureIndicator]-margin-|",
            options: [.directionLeadingToTrailing],
            metrics: ["margin":margin],
            views: ["disclosureIndicator":disclosureIndicator]
        ))
        
    }
    
    private func addDisclosureView() {
        guard let disclosureView = disclosureView else { return }
        
        self.addSubview(disclosureView)
        disclosureView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[disclosureView]-[disclosureIndicator]",
            options: [.alignAllCenterY],
            metrics: ["margin":margin],
            views: ["disclosureView":disclosureView,
                    "disclosureIndicator":disclosureIndicator]
        ))
    }
    

}
