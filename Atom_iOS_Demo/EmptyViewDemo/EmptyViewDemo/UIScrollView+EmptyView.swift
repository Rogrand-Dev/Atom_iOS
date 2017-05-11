//
//  UIScrollView+EmptyView.swift
//  EmptyViewDemo
//
//  Created by 刘岭 on 17/5/11.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

@objc enum EmptyViewType: Int {
    case noData //没有数据
    case noNet //没有网络
    case error //错误页面
    
    func image() -> UIImage{
        switch self {
        case .noNet:
            return #imageLiteral(resourceName: "no_net")
        case .noData:
            return #imageLiteral(resourceName: "no_data")
        case .error:
            return #imageLiteral(resourceName: "data_error")
        }
    }
    
    func title() -> String {
        switch self {
        case .noData:
            return "抱歉，目前没有记录~"
        case .noNet:
            return "抱歉，您的网络飞走了~"
        case .error:
            return "加载失败，点击重新加载~"
        }
    }
    
    
    /// 是否显示重试按钮
    ///
    /// - Returns: true显示按钮 否则隐藏
    func canReload(state: UIControlState) -> NSAttributedString {
        switch self {
        case .noNet, .error:
            let title = "重试"
            let attr = NSMutableAttributedString(string: title)
            let range = NSMakeRange(0, title.characters.count)
            let font = UIFont.systemFont(ofSize: 12)
            let color = UIColor.black
            attr.addAttributes([NSFontAttributeName:font,NSForegroundColorAttributeName: color], range: range)
            return attr
            
        default:
            return NSAttributedString()
        }
    }
}

@objc protocol EmptyViewProtocol: NSObjectProtocol {
    // 重试按钮
    func emptyViewNoNetRetry()
    // 页面数据不为空时不显示空页面，可显示toast
    func emptyViewToastWhenDataSourceNotEmpty(_ emptyViewType: EmptyViewType, text: String)
    
    @objc optional func emptyViewWillAppear()
    @objc optional func emptyViewWillDisappear()
}

extension UIScrollView: EmptyDataSource, EmptyDelegate {
    private struct EmptyViewKeys {
        static var kNeedEmptyView = "kNeedEmptyView"
        static var kEmptyType = "kScrollViewEmptyShowKey"
    }
    
    // 是否需要 空页面
    public var needEmptyView: Bool {
        
        set{
            if newValue == true {
                self.dzn_emptyDelegate = self
                self.dzn_emptyDataSource = self
            } else {
                self.dzn_emptyDelegate = nil
                self.dzn_emptyDataSource = nil
            }
            objc_setAssociatedObject(self, &EmptyViewKeys.kNeedEmptyView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get{
            return (objc_getAssociatedObject(self, &EmptyViewKeys.kNeedEmptyView) as? Bool) ?? false
        }
    }
    
    // 空页面 类型,默认为 0条数据
    private var emptyViewType: EmptyViewType {
        get {
            if let type = objc_getAssociatedObject(self, &EmptyViewKeys.kEmptyType) as? EmptyViewType {
                return type
            } else {
                return .noData
            }
        }
        set {
            objc_setAssociatedObject(self, &EmptyViewKeys.kEmptyType, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setEmptyViewType(with code: Int) {
        var toastStr: String = ""
        if code == 4 {
            //没网
            emptyViewType = .noNet
            toastStr = "网络错误"
        }
        else if code == 0 {
            emptyViewType = .noData
        }
        else {
            //服务器异常 code == 3
            emptyViewType = .error
            toastStr = "数据异常"
        }
        
        DispatchQueue.main.async {
            if let tableView = self as? UITableView {
                tableView.endRefreshWhenEmpty()
                tableView.reloadData()
                
                // 有数据之后请求 emptyView 不显示，才需要 toast
                if toastStr != "" && self.emptyView?.isHidden == true {
                    let emptyVC = self.getProtocolImplement()
                    emptyVC?.emptyViewToastWhenDataSourceNotEmpty(self.emptyViewType, text: toastStr)
                }
            }
            else if let collectionView = self as? UICollectionView {
                collectionView.reloadData()
            } else {
                self.reloadEmptyDataSet()
            }
        }
        
    }
    
    private func getProtocolImplement() -> EmptyViewProtocol? {
        var responder = self.next
        var emptyVC: EmptyViewProtocol? = nil
        repeat {
            guard let resp = responder,
                resp.isKind(of: UIWindow.self) == false else { break }
            if let vc = resp as? EmptyViewProtocol {
//                print("协议已经实现")
                emptyVC = vc
                break
            }
            responder = resp.next
        } while responder == nil
        return emptyVC
    }
    
    
    // MARK: - EmptyDataSource
    
    public func description(emptyView scrollView: UIScrollView) -> NSAttributedString? {
        let title = emptyViewType.title()
        let attr = NSMutableAttributedString(string: title)
        let range = NSMakeRange(0, title.characters.count)
        let font = UIFont.systemFont(ofSize: 12)
        let color = UIColor.gray
        attr.addAttributes([NSFontAttributeName:font,NSForegroundColorAttributeName: color], range: range)
        return attr
    }
    
    public func title(emptyView scrollView: UIScrollView) -> NSAttributedString? {
        let title = "   "
        let attr = NSMutableAttributedString(string: title)
        let range = NSMakeRange(0, title.characters.count)
        let font = UIFont.systemFont(ofSize: 6)
        let color = UIColor.gray
        attr.addAttributes([NSFontAttributeName:font,NSForegroundColorAttributeName: color], range: range)
        return attr

    }
    
    public func image(emptyView scrollView: UIScrollView) -> UIImage? {
        return emptyViewType.image()
    }
    
    public func backgroundColor(emptyView scrollView: UIScrollView) -> UIColor? {
        return UIColor.lightGray
    }
    
    public func verticalOffset(emptyView scrollView: UIScrollView) -> CGFloat {
        return 0
    }
    
    public func spaceHeight(emptyView scrollView: UIScrollView) -> CGFloat {
        return 0
    }
    
    public func buttonTitle(emptyView scrollView: UIScrollView, state: UIControlState) -> NSAttributedString? {
        return emptyViewType.canReload(state: state)
    }
    
    public func buttonBackgroundImage(emptyView scrollView: UIScrollView, forState state: UIControlState) -> UIImage? {
        return nil
    }
    
    public func didTap(emptyView scrollView: UIScrollView, button: UIButton) {
        let emptyVC = getProtocolImplement()
        emptyVC?.emptyViewNoNetRetry()
    }
    
    public func willAppear(emptyView scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint.zero
        let emptyVC = getProtocolImplement()
        emptyVC?.emptyViewWillAppear?()
    }
    
    public func willDisappear(emptyView scrollView: UIScrollView) {
        let emptyVC = getProtocolImplement()
        emptyVC?.emptyViewWillDisappear?()
    }
    
}

extension UITableView {
    
    fileprivate func endRefreshWhenEmpty() {
        //FIXME:-停止刷新
//        if let head = mj_header {
//            head.endRefreshing()
//        }
//        if let foot = mj_footer {
//            foot.isHidden = true
//            foot.endRefreshing()
//        }
    }
    
}
