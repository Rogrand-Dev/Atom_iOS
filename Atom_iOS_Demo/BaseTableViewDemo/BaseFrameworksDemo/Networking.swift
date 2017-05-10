//
//  Networking.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/3.
//  Copyright © 2017年 RG. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Alamofire
import RxCocoa
import ObjectMapper
class OnlineProvider<Target>: RxMoyaProvider<Target> where Target: TargetType {
    
    fileprivate let online: Observable<Bool>
    
    init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
         stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
         manager: Manager = RxMoyaProvider<Target>.defaultAlamofireManager(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         online: Observable<Bool> = connectedToInternetOrStubbing()) {
        
        self.online = online
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }
    
    override func request(_ token: Target) -> Observable<Moya.Response> {
        return online
            .take(1) // Take 1 to make sure we only invoke the API once.
            .flatMap({ (online) -> Observable<Moya.Response> in // Turn the online state into a network request
                if online {
                    return super.request(token)
                } else {
                    
                    let error = NSError(domain: " no net", code: 4, userInfo: nil)
                    return Observable<Moya.Response>.error(error)
                }
                
            })
        //        let actualRequest = super.request(token)
        //        return online
        //            .ignore(value: false)  // Wait until we're online
        //            .take(1)        // Take 1 to make sure we only invoke the API once.
        //            .flatMap { online in // Turn the online state into a network request
        //                return actualRequest
        //        }
        
    }
    
//    func preloadCacheBeforeRequest(_ token:Target) -> Observable<Moya.Response> {
//        return Observable.create({ element -> Disposable in
//            
//            var cancelableToken:Cancellable!
//            
//            let key = url(token)
//            
//            
//            /*
//             先读取缓存数据，有缓存则发出一个信号onNext，没有就跳过
//             读取缓存，只有当前page == 1 时， 才会去找本地缓存
//             token.parameters不为空，因为在preloadCacheBeforeRequest方法调用前已经做了判断
//             */
//            if self.cacheifValid(dict: token.parameters!) {
//                self.cacheResponse(forKey: key, closure: { (response) in
//                    if let unwrappedResponse = response {
//                        element.onNext(unwrappedResponse)
//                    }
//                })
//            }
//            
//            //发出真正的网络请求
//            cancelableToken = self.request(token) { result in
//                switch result {
//                case .success(let response):
//                    element.onNext(response)
//                    element.onCompleted()
//                    
//                    //存入缓存
//                    self.cacheResponse(forKey: key, response: response)
//                    
//                case .failure(let error):
//                    element.onError(error)
//                }
//            }
//            
//            return Disposables.create {
//                cancelableToken?.cancel()
//            }
//        })
//    }
    
}
struct Networking{
    let provider: OnlineProvider<API>
    
    static func newDefaultNetworking() -> Networking {
        return Networking(provider: OnlineProvider(endpointClosure: Networking.endpointsClosure(),
                                                   requestClosure: Networking.endpointResolver(),
                                                   stubClosure: MoyaProvider.neverStub,
                                                   manager:MoyaProvider<API>.defaultAlamofireManager(),
                                                   plugins: Networking.plugins))
    }
    
    static func newStubbingNetworking() -> Networking {
        return Networking(provider: OnlineProvider(endpointClosure: endpointsClosure(),
                                                   requestClosure: Networking.endpointResolver(),
                                                   stubClosure: MoyaProvider.immediatelyStub,
                                                   online: .just(true)))
    }
    
    func request(_ token: API, defaults: UserDefaults = UserDefaults.standard) -> Observable<Moya.Response> {
        
        var actualRequest:Observable<Moya.Response> {
            //            if case .get = token.method {
            //                return self.provider.preloadCacheBeforeRequest(token)
            //            }
            //            else{
            return self.provider.request(token)
            //            }
        }
        
        if token.needToken == true {
            //            let _ = self.XAppTokenRequest(defaults)
            //            return self.provider.request(token)
            return self.XAppTokenRequest(defaults).flatMap { _ in actualRequest }
        }
        else{
            return self.provider.request(token)
        }
        
        
    }
    
}

extension Networking:BackLoginable {
    
    //刷新token的请求
    func XAppTokenRequest(_ defaults: UserDefaults) -> Observable<String?> {
        
        var appToken = XAppToken(defaults: defaults)
        
        if appToken.isValid {
            return Observable.just(appToken.token)
        }
        log.info("刷新token请求,\(appToken.token)")
        let newTokenRequest = self.provider.request(API.refresh_token)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .mapToIgnoreOutside(object: RefreshTokenDataModel.self)
            .doOnNext({ (element) in
                
                appToken.token = element.access_token
                appToken.expiry = Date(timeIntervalSinceNow: TimeInterval(element.expires_in))
                //AppDateFormatter.fromString("\(element.expires_in)")
                appToken.synchronize()
                
            })
            .doOnError({ (error) in
                
                //                //token刷新失败，返回登录页面
                self.alertLoginTips()
                
            })
            .map{
                return $0.access_token
            }
            .logError()
        
        return newTokenRequest
    }
    
    static func endpointsClosure<T>() -> (T) -> Endpoint<T> where T: TargetType, T: XAuthType {
        return { target in
            
            let url = target.baseURL.appendingPathComponent(target.path).absoluteString
            
            var dict = target.parameters
            if target.needSign {
                if case .request = target.task, dict is [String : String]  {
                    dict?["sign"] = API.sign(params: dict as! [String : String], secret: String.signKey)
                }
            }
                        
            let endpoint = Endpoint<T>(
                url: url,
                sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                method: target.method,
                parameters: dict,
                parameterEncoding: target.parameterEncoding
            )
            
            if let accessToken = XAppToken().token, target.needToken {
                
                return endpoint.adding(newHTTPHeaderFields: ["Authorization":"Bearer \(accessToken)","api_version":"1"])
            }
            else{
                return endpoint.adding(newHTTPHeaderFields: ["Authorization":"Bearer ","api_version":"1"])
            }
            
            
        }
    }
    
    static func endpointResolver<T>() -> MoyaProvider<T>.RequestClosure where T: TargetType {
        return { (endpoint, closure) in
            var request = endpoint.urlRequest!
            request.httpShouldHandleCookies = true
            closure(.success(request))
        }
    }
    
    static var plugins: [PluginType] {
        return [
            NetworkLogger(blacklist: { target -> Bool in
                guard let target = target as? API else { return false }
                
                switch target {
//                                   case .getvillageList:
//                                  return true
                default: return false
                    
                }
            })
        ]
    }
    
    static func defaultAlamofireManager() -> Manager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10
        let manager = Manager(configuration: configuration)
        //        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
        
        //            //认证服务器证书
        //            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
        //
        //                return configServer(session: session, challenge: challenge)
        //
        //            }else{
        //                return (.cancelAuthenticationChallenge,nil)
        //            }
        
        //        }
        
        manager.startRequestsImmediately = false
        return manager
    }
    
    private static func configServer(session:URLSession, challenge:URLAuthenticationChallenge) -> (URLSession.AuthChallengeDisposition,URLCredential?){
        let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
        let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
        let remoteCertificateData = CFBridgingRetain(SecCertificateCopyData(certificate))!
        let cerPath = Bundle.main.path(forResource: "data.51dongcai.com", ofType: "cer")!
        let cerUrl = NSURL(fileURLWithPath: cerPath)
        let localCertificateData = NSData(contentsOf: cerUrl as URL)
        
        if remoteCertificateData.isEqual(localCertificateData) == true {
            let credential = URLCredential(trust: serverTrust)
            challenge.sender?.use(credential, for: challenge)
            
            
            let serverTrust = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            return (.useCredential,serverTrust)
        }else{
            return (.cancelAuthenticationChallenge,nil)
        }
        
    }
}


