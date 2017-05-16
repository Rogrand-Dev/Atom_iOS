//
//  FirstViewController.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/15.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    lazy var topView: SignInTopView = SignInTopView.init().then { (topView) in
        topView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topView)
    }
    
    lazy var bottomView: ThirdSignInView = ThirdSignInView.init().then { (bottomView) in
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.resignTextFieldFirstResponders()
    }
    
    private func setupView() {
        topView.backgroundColor = UIColor.white
        topView.delegate = self
        topView.firstRowView.leftLabel.text = "账号"
        topView.firstRowView.textField.placeholder = "请输入账号"
       
        topView.secondRowView.leftLabel.text = "密码"
        topView.secondRowView.textField.placeholder = "请输入密码"
        let btnW: CGFloat = 40
        let hideBtn = UIButton.init(type: .custom)
        hideBtn.setImage(#imageLiteral(resourceName: "login_hid_pwd"), for: .normal)
        hideBtn.setImage(#imageLiteral(resourceName: "login_show_pwd"), for: .selected)
        hideBtn.backgroundColor = UIColor.init(white: 0.7, alpha: 0.7)
        hideBtn.frame = CGRect.init(x: 0, y: 0, width: btnW, height: btnW)
        hideBtn.addTarget(self, action: #selector(self.hidPWD(sender:)), for: .touchUpInside)
        topView.secondRowView.rightViewWidth = btnW
        topView.secondRowView.rightView.addSubview(hideBtn)
        topView.secondRowView.textField.isSecureTextEntry = !hideBtn.isSelected

        bottomView.backgroundColor = UIColor.white
        
    }
    
    @objc private func hidPWD(sender: UIButton) {
        topView.secondRowView.textField.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
    
    private func setupConstraints() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[topView]",
            options: NSLayoutFormatOptions.directionLeadingToTrailing,
            metrics: nil,
            views: ["topView":topView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[topView]-0-|",
            options: NSLayoutFormatOptions.directionLeadingToTrailing,
            metrics: nil,
            views: ["topView":topView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[bottomView(==height)]-0-|",
            options: NSLayoutFormatOptions.directionLeadingToTrailing,
            metrics: ["height": bottomView.viewHeight],
            views: ["bottomView":bottomView]))
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[bottomView]-0-|",
            options: NSLayoutFormatOptions.directionLeadingToTrailing,
            metrics: nil,
            views: ["bottomView":bottomView]))
    }
    
    func resignTextFieldFirstResponders() {
        topView.resignTextFieldFirstResponders()
    }
    
}

extension FirstViewController: LLInputViewDelegate {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignTextFieldFirstResponders()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("shouldChangeCharactersIn \(string)")
        return true
    }
}
