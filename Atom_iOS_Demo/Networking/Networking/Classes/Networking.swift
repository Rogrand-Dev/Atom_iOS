//
//  Networking.swift
//  Networking
//
//  Created by 武飞跃 on 2017/5/8.
//  Copyright © 2017年 武飞跃. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import Moya
import Alamofire

extension NetworkingType {

    static var accessToken:String { return "192a0fce87409339c124f04325dc670e" }
 
    static var secret:String { return "" }
 
    static var version:String { return "1" }
}
 
public struct Networking:NetworkingType{
 
    public static func request<Element>(_ target:Element,
                               stubClosure: StubBehavior = .never) -> RxSwift.Observable<Any> where Element:TargetType & XAuthType {
        
        if target.addAuth {
            //授权需要刷新token判断
            if case .never = stubClosure {
                return XAppTokenRequest().flatMap { _ in defaultRequest(target, stubClosure: stubClosure) }
            }
        }
        
        return defaultRequest(target, stubClosure: stubClosure)
        
    }
 
    private static func defaultRequest<Element>(_ target:Element,
                                       stubClosure: StubBehavior = .never) -> RxSwift.Observable<Any> where Element:TargetType & XAuthType {
        return OnlineProvider(endpointClosure:Networking.endpointMapping(),
                          requestClosure: Networking.requestMapping(),
                          stubClosure: {_ in stubClosure},
                          plugins: Networking.plugins)
            .request(target)
            .filterSuccessfulStatusCodes()
            .mapJSON()
    }
    
    private static func XAppTokenRequest() -> Observable<String?> {
        var appToken = XAppToken()
        
        if appToken.isValid {
            
            return Observable.just(appToken.token)
            
        }
        
        let newTokenReuquest = defaultRequest(XAppDefaultAPI.refresh_token())
            .map { element -> (token: String?, expiry: String?) in
                guard let dictionary = element as? NSDictionary else { return (token: nil, expiry: nil) }
                
                return (token: dictionary["xapp_token"] as? String, expiry: dictionary["expires_in"] as? String)
            }
            .do(onNext: { element in
                appToken.token = element.0
                if element.1?.isEmpty == false {
                    appToken.expiry = Date(timeIntervalSinceNow: TimeInterval(element.1!)!)
                }
            })
            .map { (token, expiry) -> String? in
                return token
            }
        
        return newTokenReuquest
    }
 
}

