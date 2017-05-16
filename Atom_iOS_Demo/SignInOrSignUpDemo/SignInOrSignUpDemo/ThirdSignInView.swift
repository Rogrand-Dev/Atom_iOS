//
//  ThirdSignInView.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/15.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class ThirdSignInView: UIView {

    let viewHeight: CGFloat = 200
    private var hiddenHeight: CGFloat = 80
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loginAtWeiXin() {
        print("loginAtWeiXin")
    }
    
    func loginAtQQ() {
        print("loginAtQQ")
        
    }
    
    func loginAtWeiBo() {
        print("loginAtWeiBo")
        
    }

    private func setupView() {
        
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.init(white: 0.8, alpha: 1.0)
        
        let hideBtn = UIButton.init(type: .custom)
        hideBtn.setImage(#imageLiteral(resourceName: "login_show_pwd"), for: .normal)
        hideBtn.setImage(#imageLiteral(resourceName: "login_hid_pwd"), for: .selected)
        hideBtn.translatesAutoresizingMaskIntoConstraints = false
        hideBtn.backgroundColor = UIColor.init(white: 0.7, alpha: 0.7)
        hideBtn.addTarget(self, action: #selector(self.hidPWD(sender:)), for: .touchUpInside)
        
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        
        topView.addSubview(line)
        line.addConstraint(NSLayoutConstraint.init(item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1))
        topView.addConstraint(NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: topView, attribute: .centerY, multiplier: 1.0, constant: 0))
        topView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[line]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["line":line]))
        
        topView.addSubview(hideBtn)
        hideBtn.addConstraint(NSLayoutConstraint.init(item: hideBtn, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        hideBtn.addConstraint(NSLayoutConstraint.init(item: hideBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40))
        topView.addConstraint(NSLayoutConstraint.init(item: hideBtn, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: topView, attribute: .centerX, multiplier: 1.0, constant: 0))
        topView.addConstraint(NSLayoutConstraint.init(item: hideBtn, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: topView, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        
        let lab = UILabel.init()
        lab.text = "-其它方式登录-"
        lab.textAlignment = .center
        lab.textColor = UIColor.lightGray
        lab.font = UIFont.systemFont(ofSize: 10)
        lab.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(lab)
        self.addSubview(topView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[topView]-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["topView":topView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lab]-|", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["lab":lab]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[topView(40)]-8-[lab(15)]", options: NSLayoutFormatOptions.directionLeadingToTrailing, metrics: nil, views: ["topView":topView, "lab":lab]))
        
        
        let QQBtn = UIButton.init(type: .custom)
        QQBtn.setImage(UIImage.init(named: "qq_highlight"), for: .normal)
        QQBtn.addTarget(self, action: #selector(self.loginAtQQ), for: .touchUpInside)
        
        let WXBtn = UIButton.init(type: .custom)
        WXBtn.setImage(UIImage.init(named: "wechat_highlight"), for: .normal)
        WXBtn.addTarget(self, action: #selector(self.loginAtWeiXin), for: .touchUpInside)
        
        let WBBtn = UIButton.init(type: .custom)
        WBBtn.setImage(UIImage.init(named: "sina_highlight"), for: .normal)
        WBBtn.addTarget(self, action: #selector(self.loginAtWeiBo), for: .touchUpInside)
        
        self.addSubview(QQBtn)
        self.addSubview(WXBtn)
        self.addSubview(WBBtn)
        QQBtn.translatesAutoresizingMaskIntoConstraints = false
        WXBtn.translatesAutoresizingMaskIntoConstraints = false
        WBBtn.translatesAutoresizingMaskIntoConstraints = false

        self.addConstraint(NSLayoutConstraint.init(item: WXBtn, attribute: NSLayoutAttribute.centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint.init(item: WXBtn, attribute: NSLayoutAttribute.centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 50))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[QQBtn(==WXBtn)]-30-[WXBtn(60)]-30-[WBBtn(==WXBtn)]",
            options: [NSLayoutFormatOptions.alignAllTop, .alignAllBottom],
            metrics: nil,
            views: ["WXBtn":WXBtn, "QQBtn":QQBtn, "WBBtn":WBBtn]))
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[WXBtn(60)]-44-|",
            options: NSLayoutFormatOptions.directionLeadingToTrailing,
            metrics: nil,
            views: ["WXBtn":WXBtn]))
        
        
    }
    
    @objc private func hidPWD(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            // 收起
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let superV = self?.superview,
                    let strongSelf = self else { return }
                strongSelf.frame.origin.y = superV.bounds.size.height - strongSelf.hiddenHeight
            }
        } else {
            // 弹出
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let superV = self?.superview,
                    let strongSelf = self else { return }
                strongSelf.frame.origin.y = superV.bounds.size.height - strongSelf.viewHeight
            }
        }
    }
    
    
}
