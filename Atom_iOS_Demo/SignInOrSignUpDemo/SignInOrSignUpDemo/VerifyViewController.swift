//
//  VerifyViewController.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/16.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {
    
    lazy var inputV: LLInputView = LLInputView.init().then { (inputV) in
        inputV.delegate = self
        inputV.leftLabelWidth = 16
        inputV.backgroundColor = UIColor.white
        inputV.textField.tintColor = themeColor
        inputV.textField.textColor = UIColor.black
        inputV.textField.font = UIFont.systemFont(ofSize: 14)
        inputV.textField.placeholder = "请输入短信中的验证码"
        self.view.addSubview(inputV)
    }
    
    lazy var signInBtn: UIButton = UIButton.init(type: .custom).then { (signInBtn) in
        signInBtn.clipsToBounds = true
        signInBtn.layer.cornerRadius = 3
        signInBtn.backgroundColor = themeColor
        signInBtn.setTitle("提交验证码", for: .normal)
        signInBtn.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(signInBtn)
    }
    
    lazy var verifyBtn: LLVerifyButton = LLVerifyButton.init().then { (verifyBtn) in
        
        verifyBtn.backgroundColor = UIColor.clear
        verifyBtn.title = "重新获取验证码"
        verifyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        verifyBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        verifyBtn.setTitleColor(UIColor.white, for: UIControlState.disabled)
        verifyBtn.sizeToFit()
        verifyBtn.contentMode = .right
        verifyBtn.titleLabel?.textAlignment = .right
        
    }
    
    private var telStr: String
    init(tel: String) {
        telStr = tel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyBtn.contentHorizontalAlignment = .right
        self.title = "注册"
        self.view.backgroundColor = UIColor.init(white: 0.85, alpha: 1.0)
        setupView()
        verifyBtn.startSeconds = 3
        verifyBtn.startCountDown()
    }
    
    func setupView() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: verifyBtn)
        
        let stepV = SignUpStepView.init(frame: CGRect.init(x: 0, y: 64, width: self.view.bounds.size.width, height: 40), index: 2)
        self.view.addSubview(stepV)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: stepV.frame.maxY + 10, width: self.view.bounds.size.width, height: 12))
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        self.view.addSubview(label)
        
        var showStr: String = telStr
        if telStr.characters.count > 8 {
            let sIndex = telStr.index(telStr.startIndex, offsetBy: 3)
            let eIndex = telStr.index(telStr.endIndex, offsetBy: -4)
            let range = Range.init(uncheckedBounds: (sIndex, eIndex))
            showStr = telStr.replacingCharacters(in: range, with: "****")
        }
        label.text = "验证码已经发送到\(showStr)"
        
        inputV.frame = CGRect.init(x: 0, y: label.frame.maxY + 10, width: self.view.bounds.size.width, height: 44)
        signInBtn.frame = CGRect.init(x: 16, y: inputV.frame.maxY + 10, width: self.view.bounds.size.width - 32, height: 44)

        signInBtn.addTarget(self, action: #selector(self.pushToPassword), for: .touchUpInside)
        
    }
    
    @objc private func pushToPassword() {
        print("确认验证码 \(inputV.textField.text)")
//        guard "验证码验证接口" else { return }
        let pwdVC = SetPasswordViewController()
        self.navigationController?.pushViewController(pwdVC, animated: true)
    }
    func resignTextFieldFirstResponders() {
        self.inputV.resignTextFieldFirstResponders()
    }
    
    deinit {
        verifyBtn.stopCountDown()
    }
}

extension VerifyViewController: LLInputViewDelegate {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        resignTextFieldFirstResponders()
    }
    
    
}
