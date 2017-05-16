//
//  Verify.swift
//  SignInOrSignUpDemo
//
//  Created by 刘岭 on 17/5/16.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit

class Verify: NSObject {
    /*
     *  @DO 判断字符串是否为空串，其中空串是指经过trim后字符串长度为0
     *  @param str
     *  @return 空串或空返回YES、否则返回NO
     */
    class func isBlank(str: String?) -> Bool {
        
        guard str == nil || str?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) == "" else {
            return false
        }
        return true
        
    }
    
    /*
     *  @DO 判断字符串是否为非空串，其中空串是指经过trim后字符串长度为0
     *  @param str
     *  @return 空串或空返回NO、否则返回YES
     */
    class func notBlank(str: String?) -> Bool {
        return !self.isBlank(str: str)
    }
    // 验证手机号
    class func checkTelNumber(telNumber: String) -> Bool {
        
        guard self.notBlank(str: telNumber) else {
            return false
        }
        let pattern = "^1+[3578]+\\d{9}$"
        let pred = NSPredicate.init(format: "SELF MATCHES %@", pattern)
        
        return pred.evaluate(with: telNumber)
        
    }
    
    /** 验证手机号输入 */
    class func checkTelnum(str: String) -> Bool {
        if self.checkTelNumber(telNumber: str) == false {
            self.toast("手机号输入错误")
            return false
        }
        return true
    }
    
    /** 验证用户名输入 */
    class func checkUsername(str: String, isAccount: Bool=false) -> Bool {
        
        guard (str != "" ) else {
            self.toast("用户名不能为空")
            return false
        }
        
        if !isAccount {     //帐号输入可能为手机号
            let userN = str.trimmingCharacters(in: NSCharacterSet.decimalDigits)
            guard (userN != "" ) else {
                self.toast("用户名不能为纯数字")
                return false
            }
        }
        
        if self.checkUsername(str: str) == false {
            self.toast("用户名格式有误，请重新输入")
            return false
        }
        
        return true
    }
    
    /** 验证密码输入 */
    class func checkPassword(str: String) -> Bool {
        
        guard (str != "" ) else {
            self.toast("密码不能为空")
            return false
        }
        
        let passW = str.trimmingCharacters(in: NSCharacterSet.decimalDigits)
        guard (passW != "" ) else {
            self.toast("密码不能为纯数字")
            return false
        }
        
        if self.checkPassword(str: str) == false {
            self.toast("请输入6-16位密码")
            return false
        }
        
        return true
    }
    
    class func toast(_ str: String?) {
        print(str ?? "")
    }
}
