//
//  MineViewController.swift
//  MineView
//
//  Created by 刘岭 on 2017/5/31.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

@objc protocol PushViewControllerProtocol: NSObjectProtocol {
    @objc optional func pushTo(viewController: UIViewController)
    @objc optional func pushTo(viewControllerName: String)
}

extension UIColor {
    class func getColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
let themeColor = UIColor.getColor(r: 236, g: 53, b: 51)

class MineViewController: BaseViewController {
    
    lazy var contentView: UIScrollView = UIScrollView().then { (contentView) in
        contentView.backgroundColor = themeColor
        contentView.alwaysBounceVertical = true
        contentView.alwaysBounceHorizontal = false
        contentView.showsVerticalScrollIndicator = true
        contentView.showsHorizontalScrollIndicator = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.delegate = self
        self.view.addSubview(contentView)
    }
    
    lazy var headerView: MineHeaderView = MineHeaderView.init().then { (headerView) in
        headerView.backgroundColor = themeColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(headerView)
    }
    
    lazy var bodyView: MineBodyView = MineBodyView.init().then { (bodyView) in
        bodyView.backgroundColor = UIColor.groupTableViewBackground
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(bodyView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupViews() {
        contentView.backgroundColor = bodyView.backgroundColor
        self.edgesForExtendedLayout = []
        self.automaticallyAdjustsScrollViewInsets = false
        
        let statusBarH: CGFloat = 20
        let headerViewH: CGFloat = 80
        let bodyHeight: CGFloat = UIScreen.main.bounds.height - statusBarH - headerViewH
        
        let statusBarBgView = UIView.init()
        self.view.addSubview(statusBarBgView)
        statusBarBgView.backgroundColor = themeColor
        statusBarBgView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[statusBarBgView]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["statusBarBgView":statusBarBgView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[statusBarBgView(==statusBarH)]-0-[contentView]-|", options: [.alignAllLeft, .alignAllRight], metrics: ["statusBarH":statusBarH], views: ["statusBarBgView":statusBarBgView,"contentView":contentView]))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[headerView]-0-|", options: [.directionLeadingToTrailing], metrics: nil, views: ["headerView":headerView]))
        contentView.addConstraint(NSLayoutConstraint.init(item: headerView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[headerView(==headerViewH)]-0-[bodyView(>=bodyHeight)]-20-|", options: [.alignAllLeft, .alignAllRight], metrics: ["headerViewH":headerViewH, "bodyHeight":bodyHeight], views: ["headerView":headerView, "bodyView":bodyView]))
        
    }

}

extension MineViewController: PushViewControllerProtocol {
    func pushTo(viewControllerName: String) {
        print(viewControllerName)
        if viewControllerName == "登录"  {
            self.headerView.setHeader(personInfo: (logo: #imageLiteral(resourceName: "icon_subject"), title: "heroes", grade: "V1青铜会员"))
        }
        else if viewControllerName == "个人信息" {
//            self.headerView.setHeader(personInfo: nil)
            self.pushViewController(PersonInfoViewController())

        }
        
    }
    
    func pushTo(viewController: UIViewController) {
        self.pushViewController(viewController)
    }
}

extension MineViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.backgroundColor = headerView.backgroundColor
        } else {
            scrollView.backgroundColor = bodyView.backgroundColor
        }
    }
}
