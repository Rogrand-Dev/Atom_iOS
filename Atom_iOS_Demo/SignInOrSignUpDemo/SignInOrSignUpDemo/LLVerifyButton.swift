//
//  LLVerifyButton.swift
//  Tongdao
//
//  Created by 刘岭 on 16/7/27.
//  Copyright © 2016年 RG. All rights reserved.
//

import UIKit

public class LLVerifyButton: UIButton {
    
    public var normalStyle: Bool = true
    public var startSeconds: Int = 60
    public var verifyAction: (() -> Void)? = nil
    public var title: String = "验证" {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }

    private var _seconds: Int = 0
    private var clockTimer: Timer?
    
    public init() {
        super.init(frame: CGRect.zero)

        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.backgroundColor = UIColor.init(white: 0.7, alpha: 0.7)
        self.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.setTitleColor(UIColor.lightGray, for: UIControlState.disabled)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func startCountDown() {
        // FIXME: - 修改时长
        _seconds = startSeconds
        let str = "\(_seconds)秒"

        self.setTitle(str, for: .disabled)
        self.isSelected = false
        self.isEnabled = false
        
        clockTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(self.oneSecondPass), userInfo: nil, repeats: true)
        RunLoop.main.add(clockTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    public func stopCountDown() {
        _seconds = 0
        if clockTimer != nil {
            clockTimer?.invalidate()
            clockTimer = nil
        }
        self.isEnabled = true
    }
    
    @objc private func oneSecondPass() {
        if _seconds > 0
        {
            _seconds -= 1;
            let str = "\(_seconds)秒"
            print("\(_seconds)秒")
            self.setTitle(str, for: .disabled)

        }
        else
        {
            stopCountDown()
        }
        
    }
    
    @objc private func verity() {
        startCountDown()
        verifyAction?()
    }
  
    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        let actions = self.actions(forTarget: self, forControlEvent: .touchUpInside)
        if actions?.contains(#selector(self.verity).description) != true
        {
            self.addTarget(self, action: #selector(self.verity), for: .touchUpInside)
        }
        if normalStyle {
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 3.0
        }
    }
    
}
