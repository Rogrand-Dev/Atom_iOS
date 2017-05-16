//
//  RefreshTokenModel.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/3.
//  Copyright © 2017年 RG. All rights reserved.
//

import Foundation
import ObjectMapper

class RefreshTokenModel: Mappable {
    var code: Int?
    var data: RefreshTokenDataModel?
    var msg: String?
    
    required init?(map:Map){
        
    }
    
    func mapping(map:Map){
        code        <- map["code"]
        data        <- map["data"]
        msg         <- map["msg"]
    }
}

class RefreshTokenDataModel: Mappable {
    var user_id:String!//用户id
    var refresh_token: String!
    var access_token: String!
    var expires_in: Int = 0
    var auth_state:Int? //认证状态：1 - 未提交认证；2 - 认证中；3 - 认证未通过；4 - 认证通过
    var token_type: String? //凭证类型
    required init?(map:Map){
        
    }
    
    func mapping(map:Map){
        user_id <- map["user_id"]
        refresh_token  <- map["refresh_token"]
        token_type  <- map["token_type"]
        access_token  <- map["access_token"]
        expires_in  <- map["expires_in"]
        auth_state <- map["auth_state"]
    }
}
