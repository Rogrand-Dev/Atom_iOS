//
//  ViewController.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/15.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

extension UIColor {
    class func getColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}
let themeColor = UIColor.getColor(r: 236, g: 53, b: 51)

class ViewController: UIViewController {

    lazy var segmentView: SegmentView = SegmentView.init(frame: CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 44), itemTitles: ["账号密码登录", "手机号快捷登录"], style: SegmentStyle.line, contentSize: nil).then(block: { (segmentView) in
        segmentView.delegate = self
        segmentView.itemSelectedTitleColor = themeColor
        segmentView.itemNormalTitleColor = UIColor.getColor(r: 97, g: 97, b: 97)
        self.view.addSubview(segmentView)
    })
    
    lazy var contentView: UIScrollView = UIScrollView.init().then { (contentView) in
        contentView.delegate = self
        contentView.bounces = false
        contentView.isScrollEnabled = true
        contentView.isPagingEnabled = true
        contentView.contentInset = UIEdgeInsets.zero
        contentView.showsVerticalScrollIndicator = false
        contentView.showsHorizontalScrollIndicator = false
        self.view.addSubview(contentView)
    }
    
    let firstVC = FirstViewController()
    let secondVC = SecondViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavi()
        setContentView()
    }
    
    private func setNavi() {
        self.title = "登录"
        self.navigationController?.navigationBar.barTintColor = themeColor
        self.navigationController?.navigationBar.backgroundColor = themeColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)]
        
        let signUpButton = UIButton.init(type: .custom)
        signUpButton.setTitle("注册", for: .normal)
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        signUpButton.addTarget(self, action: #selector(self.pushToSignUp), for: .touchUpInside)
        signUpButton.sizeToFit()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: signUpButton)
    }
    
    private func setContentView() {
        
        self.addChildViewController(firstVC)
        self.addChildViewController(secondVC)
        self.contentView.addSubview(firstVC.view)
        self.contentView.addSubview(secondVC.view)
        
        self.automaticallyAdjustsScrollViewInsets = false
        firstVC.view.translatesAutoresizingMaskIntoConstraints = false
        secondVC.view.translatesAutoresizingMaskIntoConstraints = false
        self.segmentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[segmentView]-0-|",
            options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil,
            views: ["segmentView":segmentView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-64-[segmentView(44)]-0-[contentView]-0-|",
            options: [NSLayoutFormatOptions.alignAllLeft, NSLayoutFormatOptions.alignAllRight], metrics: nil,
            views: ["segmentView":segmentView,"contentView":contentView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[firstView]-0-[secondView(==firstView)]-0-|",
            options: [NSLayoutFormatOptions.alignAllTop, NSLayoutFormatOptions.alignAllBottom],
            metrics: nil,
            views: ["firstView":firstVC.view,"secondView":secondVC.view]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[firstView]-0-|",
            options: NSLayoutFormatOptions.directionLeadingToTrailing,
            metrics: nil,
            views: ["firstView":firstVC.view]))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: firstVC.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint.init(item: firstVC.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.contentView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0))
    }
    
    @objc private func pushToSignUp() {
        let signUpVC = SignUpViewController()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }

}

extension ViewController: SegmentViewDelegate {
    func segmentViewChangeToItem(_ segmentView: SegmentView, index: Int) {
        firstVC.topView.resignTextFieldFirstResponders()
        secondVC.topView.resignTextFieldFirstResponders()
        contentView.contentOffset.x = self.view.bounds.size.width * CGFloat(index)
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(self.view.bounds.size.width)
        segmentView.changeToItem(index: index)
    }
    
}


