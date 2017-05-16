//
//  SignInTopView.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/15.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class SignInTopView: UIView {
    
    lazy var firstRowView: LLInputView = LLInputView.init().then { (rowView) in

        rowView.leftLabelWidth = 60
        rowView.leftLabel.textAlignment = .left
        rowView.leftLabel.font = UIFont.systemFont(ofSize: 16)
        rowView.leftLabel.textColor = UIColor.getColor(r: 41, g: 41, b: 41)
        
        rowView.textField.textColor = UIColor.black
        rowView.textField.font = UIFont.systemFont(ofSize: 16)
        rowView.textField.tintColor = themeColor
 
        rowView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rowView)
    }
    
    lazy var secondRowView: LLInputView = LLInputView.init().then { (rowView) in

        rowView.leftLabelWidth = 60
        rowView.leftLabel.textAlignment = .left
        rowView.leftLabel.font = UIFont.systemFont(ofSize: 16)
        rowView.leftLabel.textColor = UIColor.getColor(r: 41, g: 41, b: 41)
        
        rowView.textField.textColor = UIColor.black
        rowView.textField.font = UIFont.systemFont(ofSize: 16)
        rowView.textField.tintColor = themeColor
        
        rowView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(rowView)
    }
    
    lazy var signInBtn: UIButton = UIButton.init(type: .custom).then { (signInBtn) in
        signInBtn.clipsToBounds = true
        signInBtn.layer.cornerRadius = 3
        signInBtn.backgroundColor = themeColor
        signInBtn.setTitle("登录", for: .normal)
        signInBtn.setTitleColor(UIColor.white, for: .normal)
        signInBtn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signInBtn)
    }

    lazy var helpLabel: UILabel = UILabel.init().then { (helpLabel) in
        helpLabel.text = "遇到问题？"
        helpLabel.textAlignment = .center
        helpLabel.textColor = UIColor.lightGray
        helpLabel.isUserInteractionEnabled = true
        helpLabel.font = UIFont.systemFont(ofSize: 10)
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(helpLabel)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    weak var delegate: LLInputViewDelegate? {
        didSet {
            firstRowView.delegate = delegate
            secondRowView.delegate = delegate
        }
    }
    
    public func resignTextFieldFirstResponders() {
        firstRowView.resignTextFieldFirstResponders()
        secondRowView.resignTextFieldFirstResponders()
    }
    
    private func setupConstraints() {
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[firstRowView]-16-|",
            options: NSLayoutFormatOptions.directionLeadingToTrailing,
            metrics: nil,
            views: ["firstRowView":firstRowView]))
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[firstRowView(44)]-0-[secondRowView(==firstRowView)]-16-[signInBtn(44)]-16-[helpLabel(15)]-0-|",
            options: [NSLayoutFormatOptions.alignAllLeft, NSLayoutFormatOptions.alignAllRight],
            metrics: nil,
            views: ["firstRowView":firstRowView, "secondRowView":secondRowView, "signInBtn":signInBtn, "helpLabel":helpLabel])
        )
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        firstRowView.addBorderBottom(size: 0.5, color: UIColor.init(white: 0.7, alpha: 1.0))
        secondRowView.addBorderBottom(size: 0.5, color: UIColor.init(white: 0.7, alpha: 1.0))
    }
}
