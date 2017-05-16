//
//  SecondViewController.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/15.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    lazy var topView: SignInTopView = SignInTopView.init().then { (topView) in
        topView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(topView)
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
        topView.firstRowView.leftLabel.text = "手机号"
        topView.firstRowView.textField.placeholder = "仅支持中国大陆手机号"
        
        let verifyW: CGFloat = 80
        let verifyBtn = LLVerifyButton.init()
        verifyBtn.setTitle("获取验证码", for: .normal)
        verifyBtn.frame = CGRect.init(x: 0, y: 8, width: verifyW, height: 28)
        verifyBtn.addTarget(self,
                            action: #selector(self.hidPWD(sender:)),
                            for: .touchUpInside)
        topView.firstRowView.rightViewWidth = verifyW
        topView.firstRowView.rightView.addSubview(verifyBtn)
        
        topView.secondRowView.leftLabel.text = "验证码"
        topView.secondRowView.textField.placeholder = "请输入验证码"
                
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
        
    }
    
    func resignTextFieldFirstResponders() {
        topView.resignTextFieldFirstResponders()
    }
    
}

extension SecondViewController: LLInputViewDelegate {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignTextFieldFirstResponders()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("shouldChangeCharactersIn \(string)")
        return true
    }
}

