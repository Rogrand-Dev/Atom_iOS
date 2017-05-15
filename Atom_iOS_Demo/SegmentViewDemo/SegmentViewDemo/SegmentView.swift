//
//  SegmentView.swift
//  testView
//
//  Created by 刘岭 on 2016/10/21.
//  Copyright © 2016年 刘岭. All rights reserved.
//

import UIKit

public enum SegmentStyle {
    case none
    case line
    case rect
    case ellipse
}


public protocol SegmentViewDelegate: class {
    func segmentViewChangeToItem(_ segmentView: SegmentView, index: Int)
}


public class SegmentView: UIView {
    
    public weak var delegate: SegmentViewDelegate?
    
    //  当前选中 item
    public var currentItemIndex: Int
    
    // 分段视图背景色
    public var bgColor: UIColor! {
        didSet {
            self.backgroundColor = bgColor
            self._contentView.backgroundColor = segmentBgColor ?? bgColor
        }
    }
    // 分段内容视图背景色
    public var segmentBgColor: UIColor? = nil {
        didSet {
            self._contentView.backgroundColor = segmentBgColor
        }
    }
    // 选中滑块颜色
    public var slideColor: UIColor? = nil {
        didSet{
            _slideBlock.backgroundColor = slideColor?.cgColor
        }
    }
    // 分段内容视图边框颜色
    public var segmentBorderColor: UIColor? = nil {
        didSet {
            self._contentView.layer.borderWidth = 1.0
            self._contentView.layer.borderColor = segmentBorderColor?.cgColor
        }
    }
    // item 普通字体颜色
    public var itemNormalTitleColor: UIColor! {
        didSet {
            setItemsNormalTitle(color: itemNormalTitleColor)
        }
    }
    // item 选中字体颜色
    public var itemSelectedTitleColor: UIColor! {
        didSet {
            setItemsSelectedTitle(color: itemSelectedTitleColor)
        }
    }
    // item 字体
    public var titleFont: UIFont! {
        didSet{
            setItemsTitle(font: titleFont)
        }
    }
    // 分段视图是否有底部阴影线
    public var needShadow: Bool! {
        didSet{
            _underLine.backgroundColor = (needShadow == true) ? UIColor.init(white: 0.7, alpha: 1.0) : UIColor.clear
        }
    }
    
    // 改变选中分段
    public func changeToItem(index: Int) {
        guard index >= 0 && index < _items.count else { return }
        touchSegment(item: _items[index])
    }
    
    // 设置字体颜色
    public func setItemTitleColor(normal: UIColor, selected: UIColor) {
        itemNormalTitleColor = normal
        itemSelectedTitleColor = selected
    }
    
    // MARK: *********** 私有属性 *********
    private var _contentSize: CGSize?
    fileprivate var _segmentStyle: SegmentStyle
    
    fileprivate lazy var _items: [UIButton] = []
    
    // 选中标志滑块
    fileprivate lazy var _slideBlock: CALayer = CALayer.init().then { layer in
        self._contentView.layer.addSublayer(layer)
    }
    
    private lazy var _contentView: UIView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        self.addSubview(view)
    }
    
    private lazy var _underLine: UIView = UIView().then { view in
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
    }
    
    public init(frame: CGRect, itemTitles:[String], style: SegmentStyle, contentSize: CGSize?) {
        currentItemIndex = -1
        _segmentStyle = style
        _contentSize = contentSize
        
        super.init(frame: frame)
        setupView(titles: itemTitles)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        setupSlideBlock()
        changeToItem(index: 0)
    }
    
    // *********** private 方法 ***************
    private func setupView(titles: [String]) {
        guard titles.count > 0 else {
            assertionFailure("SegmentControl view need at least one item")
            return
        }
        setupItems(titles: titles)
        
        needShadow = true
        bgColor = UIColor.white
        itemNormalTitleColor = UIColor.black
        itemSelectedTitleColor = UIColor.blue
        titleFont = UIFont.systemFont(ofSize: 15)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[_underLine]-0-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["_underLine":_underLine]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[_underLine(==0.5)]-0-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["_underLine":_underLine]))
        
        if let size = _contentSize {
            self.addConstraint(NSLayoutConstraint.init(item: _contentView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint.init(item: _contentView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0))
            self.addConstraint(NSLayoutConstraint.init(item: _contentView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.width))
            self.addConstraint(NSLayoutConstraint.init(item: _contentView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: size.height))
        } else {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[_contentView]-0-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["_contentView":_contentView]))
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[_contentView]-0-[_underLine]", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["_contentView":_contentView, "_underLine":_underLine]))
        }
        
        var itemHorFormat = ""
        var views:[String: UIButton] = [:]
        for i in 0..<_items.count
        {
            let title = _items[i].currentTitle ?? "item\(i)"
            itemHorFormat += "[_\(title)]"
            views["_\(title)"] = _items[i]
            if i != _items.count - 1 {
                itemHorFormat += "-0-"
            }
            if i > 0 {
                _contentView.addConstraint(NSLayoutConstraint.init(item: _items[i], attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: _items[0], attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
            }
            _contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[item]-0-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["item":_items[i]]))
        }
        
        if itemHorFormat.characters.count > 0 {
            _contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-\(itemHorFormat)-0-|",
                options: NSLayoutFormatOptions.directionLeftToRight,
                metrics: nil,
                views: views))
        }
        
        setItemTitleColor(normal: itemNormalTitleColor, selected: itemSelectedTitleColor)
    }
    
    // 通过 titles 创建对应的 buttons
    private func setupItems(titles: [String]) {
        _items = []
        for title in titles {
            let item = UIButton.init(type: .custom)
            item.setTitle(title, for: .normal)
            item.setTitle(title, for: .selected)
            item.translatesAutoresizingMaskIntoConstraints = false
            _items.append(item)
            _contentView.addSubview(item)
        }
        addItemsEvent()
    }
    
    private func setupSlideBlock() {
        let item = _items[0]
        
        self._slideBlock.anchorPoint = CGPoint.init(x: 0.5, y: 1)
        if _segmentStyle == .none
        {
            _slideBlock.removeFromSuperlayer()
        }
        else if _segmentStyle == .rect
        {
            slideColor = itemSelectedTitleColor.withAlphaComponent(0.3)
            self._slideBlock.bounds.size = item.bounds.size
        }
        else if _segmentStyle == .ellipse
        {
            slideColor = itemSelectedTitleColor.withAlphaComponent(0.3)
            self._slideBlock.bounds.size = item.bounds.size
            _slideBlock.cornerRadius = _slideBlock.bounds.size.height/2
            _contentView.layer.cornerRadius = _contentView.frame.height/2
        }
        else if _segmentStyle == .line
        {
            slideColor = itemSelectedTitleColor
            let titleWidth = item.titleLabel?.frame.width ?? 40
            self._slideBlock.bounds.size = CGSize.init(width: titleWidth - 4, height: 2)
        }
        _slideBlock.position.x = item.center.x
        _slideBlock.position.y = item.bounds.size.height
    }
    
}

//MARK: - **************** 私有方法 *******************
extension SegmentView {
    
    @objc fileprivate func touchSegment(item: UIButton) {
        
        guard let slideToIndex = _items.index(of: item),
            slideToIndex != currentItemIndex else {
                return
        }
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setSelectedState(item: item)
            strongSelf.currentItemIndex = slideToIndex
            strongSelf.blockSlideToItem(index: slideToIndex)
            
            
        }) { [weak self] (finish) in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.segmentViewChangeToItem(strongSelf, index: strongSelf.currentItemIndex)
        }
    }
    
    fileprivate func blockSlideToItem(index: Int) {
        let item = _items[index]
        
        if _segmentStyle == .line {
            let titleWidth = item.titleLabel?.frame.width ?? 40
            self._slideBlock.bounds.size.width = titleWidth - 4
        }
        _slideBlock.position.x = item.center.x
        
    }
    
    // *********** items 统一属性设置方法 ***************
    fileprivate func setItemsNormalTitle(color: UIColor) {
        _items.forEach { (item) in
            item.setTitleColor(color, for: .normal)
        }
    }
    
    fileprivate func setItemsSelectedTitle(color: UIColor) {
        _items.forEach { (item) in
            item.setTitleColor(color, for: .selected)
        }
    }
    
    fileprivate func setItemsTitle(font: UIFont) {
        _items.forEach { (item) in
            item.titleLabel?.font = font
        }
    }
    
    fileprivate func setSelectedState(item: UIButton) {
        _items.forEach { (item) in
            item.isSelected = false
        }
        item.isSelected = true
    }
    
    fileprivate func addItemsEvent() {
        _items.forEach { (item) in
            item.addTarget(self, action: #selector(self.touchSegment), for: .touchUpInside)
        }
    }
    
}
