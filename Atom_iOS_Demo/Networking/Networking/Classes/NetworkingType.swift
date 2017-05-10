//
//  NetworkingType.swift
//  Networking
//
//  Created by 武飞跃 on 2017/5/9.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

protocol NetworkingType {
    static var version:String { get }  //当前接口版本号
    static var accessToken:String { get } //token
    static var secret:String { get } //加盐
}

extension NetworkingType {
    public static var plugins:[PluginType] {
        return []
    }
    
    /** 对请求的入参做额外处理 */
    public static func endpointMapping<Target>() -> (Target) -> Endpoint<Target> where Target:TargetType, Target:XAuthType {
        
        return { target in
            
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            
            let token:String = target.addAuth ? accessToken : ""
            
            let HTTPHeaderFields:[String:String] = ["Authorization":"Bearer \(token)", "api_version":version]
            
            return Endpoint<Target>(
                url: url,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                parameters: getDictForSign(parames: target.parameters),
                parameterEncoding: target.parameterEncoding,
                httpHeaderFields:HTTPHeaderFields
            )
            
        }
        
    }
    
    public static func requestMapping<Target>() -> MoyaProvider<Target>.RequestClosure where Target:TargetType, Target:XAuthType {
        return { (endpoint, closure) in
            
            if var urlRequest = endpoint.urlRequest {
                urlRequest.httpShouldHandleCookies = true
                closure(.success(urlRequest))
            } else {
                closure(.failure(MoyaError.requestMapping(endpoint.url)))
            }
            
        }
    }
    
    private static func getDictForSign(parames: [String:Any]?) -> [String:Any]? {
        
        guard var unwrappedParames = parames, unwrappedParames is [String:String] else {
            return parames
        }
        
        let tempParames = unwrappedParames as! [String:String]
        
        unwrappedParames["sign"] = tempParames.sign(secret: secret)
        
        return unwrappedParames
    }
    
}

