//
//  NetworkLogger.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/3.
//  Copyright © 2017年 RG. All rights reserved.
//

import Foundation
import Moya
import Result
class NetworkLogger: PluginType {
    typealias Comparison = (TargetType)->Bool
    let whitelist:Comparison//白名单
    let blacklist:Comparison//黑名单
    init(whitelist: @escaping Comparison = { _ -> Bool in return true},
         blacklist: @escaping Comparison = { _ -> Bool in return true}) {
        self.whitelist = whitelist
        self.blacklist = blacklist
    }
    func willSend(_ request: RequestType, target: TargetType) {
        guard blacklist(target) == false else {
        return
        }
        let address = request.request?.url?.absoluteString ?? String()
        let head = request.request?.allHTTPHeaderFields ?? Dictionary<String,String>()
        let method = request.request?.httpMethod ?? String()
        
        var parames = [String:Any]()
        if let unwrappedParames = target.parameters as? [String : String] {
            parames = unwrappedParames
            parames["sign"] = API.sign(params:unwrappedParames, secret: String.signKey)
        }
        log.info("\n接口地址:\(address)\n请求头:\(head)\n请求方式:\(method)\n请求入参:\(parames)\n")
    }
}
