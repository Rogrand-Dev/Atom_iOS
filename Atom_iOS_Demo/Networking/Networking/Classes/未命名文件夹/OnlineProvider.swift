//
//  OnlineProvider.swift
//  Networking
//
//  Created by 武飞跃 on 2017/5/8.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire
import ReachabilitySwift

open class OnlineProvider<Target>:RxMoyaProvider<Target> where Target:TargetType{
    
    fileprivate var reachabilityManager = ReachabilityManager()
    
    fileprivate func connectedToInternet() -> Observable<Bool> {
        if let online = reachabilityManager?.reach {
            return online
        }
        else{
            return Observable.just(true)
        }
    }
    
    override open func request(_ target: Target) -> Observable<Response> {
        return connectedToInternet()
            .take(1)
            .flatMap({ online -> Observable<Moya.Response> in
                if online {
                    return super.request(target)
                }
                else{
                    //没有网络
                    if case .get = target.method {
                        return self.loadCache(forKey: OnlineProvider.url(target))
                    }
                    else{
                        let error = NSError(domain:"no net", code:4, userInfo:nil)
                        return Observable<Moya.Response>.error(error)
                    }
                }
            })
    }
    
    //载入本地缓存
    private func loadCache(forKey:String) -> Observable<Moya.Response>{
        return Observable.create({ element -> Disposable in
            self.cacheResponse(forKey: forKey, closure: { (response) in
                if let unwrappedResponse = response {
                    element.onNext(unwrappedResponse)
                }
                else{
                    //无缓存
                    let error = NSError(domain:"no cache and no net", code:4, userInfo:nil)
                    element.onError(error)
                }
            })
            
            return Disposables.create()
        })
    }
    
}

extension OnlineProvider {
    
    /// 读取缓存数据
    ///
    /// - Parameter forKey: 路径
    /// - Returns: 数据
    func cacheResponse(forKey:String, closure:@escaping (Response?) -> Void){
        
        let memoryCache = DiskCache<NSData>(directory: getCachePath() + "/APPCACHE")
        
        memoryCache?.get(key: forKey.md5String(), completion: { data in
            
            if let unwrappedData = data as Data? {
                let response = Response(statusCode: 200, data: unwrappedData)
                closure(response)
            }
            else {
                closure(nil)
            }
        })
        
    }
    
    /// 缓存数据存根
    ///FIXME:- 有问题
    /// - Parameters:
    ///   - forKey: 路径
    ///   - response: 数据
    func cacheResponse(forKey:String, response:Response) {
        
        let memoryCache = DiskCache<NSData>(directory: getCachePath() + "/APPCACHE")
        memoryCache?.set(key: forKey.md5String(), value: NSData(data: response.data))
        
    }
    
    //获取本地沙盒缓存路径
    private func getCachePath() -> String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
    }
    
    static func url(_ route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}

extension String {
    
    public func md5String() -> String{
        let cStr = cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
}

extension Dictionary where Key == String, Value == String{
    public func sign(secret:String) -> String {
        
        var temp:String = ""
        
        self.keys.sorted().forEach{ key in
            //防止中文的参数值出现乱码，先转换为 UTF-8编码
            if let value = self[key] {
                let charSet = CharacterSet(charactersIn: "\"`#%^{}\"[]|\\<>!@$*()+?,/&: ").inverted
                let encodeValue = value.addingPercentEncoding(withAllowedCharacters: charSet)
                let valueString = key + encodeValue!
                temp.append(valueString)
            }
        }
        
        temp.append(secret)
        
        return temp.md5String()
    }
}
