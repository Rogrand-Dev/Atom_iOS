//
//  SetPasswordViewController.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/16.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class SetPasswordViewController: UIViewController {

    
    lazy var inputV: LLInputView = LLInputView.init().then { (inputV) in
        inputV.delegate = self
        inputV.leftLabelWidth = 16
        inputV.backgroundColor = UIColor.white
        inputV.textField.tintColor = themeColor
        inputV.textField.textColor = UIColor.black
        inputV.textField.font = UIFont.systemFont(ofSize: 14)
        inputV.textField.placeholder = "请输入密码"
        self.view.addSubview(inputV)
    }
    
    lazy var inputSureV: LLInputView = LLInputView.init().then { (inputSureV) in
        inputSureV.delegate = self
        inputSureV.leftLabelWidth = 16
        inputSureV.backgroundColor = UIColor.white
        inputSureV.textField.tintColor = themeColor
        inputSureV.textField.textColor = UIColor.black
        inputSureV.textField.font = UIFont.systemFont(ofSize: 16)
        inputSureV.textField.placeholder = "确认密码"
        self.view.addSubview(inputSureV)
    }
    
    lazy var signInBtn: UIButton = UIButton.init(type: .custom).then { (signInBtn) in
        signInBtn.clipsToBounds = true
        signInBtn.layer.cornerRadius = 3
        signInBtn.backgroundColor = themeColor
        signInBtn.setTitle("提交", for: .normal)
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
        let stepV = SignUpStepView.init(frame: CGRect.init(x: 0, y: 64, width: self.view.bounds.size.width, height: 40), index: 3)
        self.view.addSubview(stepV)
        
        inputV.frame = CGRect.init(x: 0, y: stepV.frame.maxY + 10, width: self.view.bounds.size.width, height: 44)
        inputSureV.frame = CGRect.init(x: 0, y: inputV.frame.maxY + 10, width: self.view.bounds.size.width, height: 44)
        signInBtn.frame = CGRect.init(x: 16, y: inputSureV.frame.maxY + 10, width: self.view.bounds.size.width - 32, height: 44)

        signInBtn.addTarget(self, action: #selector(self.commit), for: .touchUpInside)
        
    }
    
    @objc private func commit() {
        print("注册密码 \(inputV.textField.text)\n 确认密码 \(inputSureV.textField.text)")

//        guard "注册接口" else { return }
        
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    func resignTextFieldFirstResponders() {
        self.inputV.resignTextFieldFirstResponders()
        self.inputSureV.resignTextFieldFirstResponders()
    }
}

extension SetPasswordViewController: LLInputViewDelegate {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignTextFieldFirstResponders()
    }
    
    
}
