//
//  SignUpViewController.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/15.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    lazy var inputV: LLInputView = LLInputView.init().then { (inputV) in
        inputV.delegate = self
        inputV.leftLabelWidth = 16
        inputV.backgroundColor = UIColor.white
        inputV.textField.tintColor = themeColor
        inputV.textField.textColor = UIColor.black
        inputV.textField.font = UIFont.systemFont(ofSize: 14)
        inputV.textField.placeholder = "请输入您的手机号码"
       self.view.addSubview(inputV)
    }
    
    lazy var signInBtn: UIButton = UIButton.init(type: .custom).then { (signInBtn) in
        signInBtn.clipsToBounds = true
        signInBtn.layer.cornerRadius = 3
        signInBtn.backgroundColor = themeColor
        signInBtn.setTitle("获取验证码", for: .normal)
        signInBtn.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(signInBtn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "注册"
        self.view.backgroundColor = UIColor.init(white: 0.85, alpha: 1.0)
        setupView()
    }

    func setupView() {
        let stepV = SignUpStepView.init(frame: CGRect.init(x: 0, y: 64, width: self.view.bounds.size.width, height: 40), index: 1)
        self.view.addSubview(stepV)
        
        inputV.frame = CGRect.init(x: 0, y: stepV.frame.maxY + 10, width: self.view.bounds.size.width, height: 44)
        signInBtn.frame = CGRect.init(x: 16, y: inputV.frame.maxY + 10, width: self.view.bounds.size.width - 32, height: 44)
        
        signInBtn.addTarget(self, action: #selector(self.getVerify), for: .touchUpInside)
        
    }
    
    @objc private func getVerify() {
        print("验证手机号 \(inputV.textField.text)")
//        guard let telStr = inputV.textField.text, Verify.checkTelnum(str: telStr) else { return }
        let verifyVC = VerifyViewController.init(tel: inputV.textField.text ?? "")
        self.navigationController?.pushViewController(verifyVC, animated: true)
    }
    func resignTextFieldFirstResponders() {
        self.inputV.resignTextFieldFirstResponders()
    }
}

extension SignUpViewController: LLInputViewDelegate {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignTextFieldFirstResponders()
    }
    
    
}
