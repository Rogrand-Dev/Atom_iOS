//
//  Obsercable+ObjectMapper.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/3.
//  Copyright © 2017年 RG. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import ObjectMapper

enum AppError: String {
    case couldNotParseJSON = "无法解析JSON"
    case notLoggedIn = "没有登录"
    case missingData = "数据缺失"
}

extension AppError: Swift.Error {}

extension Observable {
    typealias Dictionary = [String:Any]
    
    func mapTo<T:Mappable>(object clssType: T.Type) -> Observable<T> {
        return self.map{ json in
            guard let dict = json as? Dictionary else {
                throw AppError.couldNotParseJSON
            }
            
            return Mapper<T>().map(JSON:dict)!
        }
    }
    
    
    
    //忽略解析最外层JSON,直接从data内部开始解析 ==> {code:0,msg:"成功",data:{...}}
    func mapToIgnoreOutside<T:Mappable>(object clssType: T.Type) -> Observable<T> {
        return self.map{ json in
            print(json)
            
            guard let dict = json as? Dictionary else {
                throw AppError.couldNotParseJSON
            }
            
            guard let code = dict["code"] as? Int, code == 0  else {
                throw AppError.missingData
            }
            
            guard let data = dict["data"] as? Dictionary else {
                throw AppError.missingData
            }
            
            return Mapper<T>().map(JSON: data)!
        }
    }
}
