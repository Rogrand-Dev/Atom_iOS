//
//  SignUpStepView.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/16.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class SignUpStepView: UIView {

    var label: UILabel {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.textColor = UIColor.lightGray
        lab.highlightedTextColor = themeColor
        lab.font = UIFont.systemFont(ofSize: 12)
        lab.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lab)
        return lab
    }

    var arr: UIImageView {
        let imgV = UIImageView.init(image: #imageLiteral(resourceName: "nextArray"))
        imgV.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imgV)
        return imgV
    }
    
    private var current: Int
    
    init(frame: CGRect, index: Int) {
        current = index
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        let lab1 = label
        lab1.text = "1.输入手机号"
        let lab2 = label
        lab2.text = "2.输入验证码"
        let lab3 = label
        lab3.text = "1.设置密码"
        if current == 1 {
            lab1.isHighlighted = true
        }
        else if current == 2 {
            lab2.isHighlighted = true
        }
        else if current == 3 {
            lab3.isHighlighted = true
        }
        
        self.addConstraint(NSLayoutConstraint.init(item: lab2, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: -10))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[lab2]-0-|",
            options: NSLayoutFormatOptions.directionLeadingToTrailing,
            metrics: nil,
            views: ["lab2":lab2]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[lab1(==lab2)]-15-[lab2(90)]-15-[lab3(==lab2)]",
            options: [.alignAllTop, .alignAllBottom],
            metrics: nil,
            views: ["lab1":lab1,"lab2":lab2,"lab3":lab3]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[lab1]-0-[arr1(7.5)][lab2]-0-[arr2(==arr1)][lab3]-0-[arr3(==arr1)]",
            options: .alignAllCenterY,
            metrics: nil,
            views: ["lab1":lab1,"arr1":arr,"lab2":lab2,"arr2":arr,"lab3":lab3,"arr3":arr]))
//        self.addConstraints(NSLayoutConstraint.constraints(
//            withVisualFormat: "H:|-0-[lab1(==lab2)]-0-[arr1(7.5)]-0-[lab2(90)]-0-[arr2(==arr1)]-0-[lab3(==lab2)]-0-[arr3(==arr1)]",
//            options: .alignAllCenterY,
//            metrics: nil,
//            views: ["lab1":lab1,"arr1":arr,"lab2":lab2,"arr2":arr,"lab3":lab3,"arr3":arr]))
        
    }
    
}
