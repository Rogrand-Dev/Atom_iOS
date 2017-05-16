//
//  API.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/3.
//  Copyright © 2017年 RG. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import EZSwiftExtensions
import CryptoSwift
protocol XAuthType {
    var needToken:Bool{get}//是否需要登陆
    var needSign:Bool{get}//是否需要签名
}
enum API{
    case getvillageList(keyword:String,count:String,page:String)
    case refresh_token
}
extension API:TargetType,XAuthType{
    internal var needSign: Bool {
        return true
    }

    ///是否需要登录
    internal var needToken: Bool {
        switch self {
        case .getvillageList,.refresh_token:
            return false
        }

    }

    
    /// The target's base `URL`.
    var baseURL: URL {         return URL(string:"xx")!  }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        switch self{
        case .getvillageList:
            return "xx"
        case .refresh_token:
            return "xx"
        }
    
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method { switch self{
    case .getvillageList:
        return .get
        
    default:
        return .post
        }
    }
    
    /// The parameters to be incoded in the request.
    var parameters: [String: Any]? {
        switch self{
        case .getvillageList(let keyword, let count, let page):
        return ["keyword":keyword,"count":count,"page":page]
        case .refresh_token:
            return [
                "refresh_token":XAppToken().token ?? "",
                "client_id":String.apiClientKey,
                "client_secret":String.apiClientSecret,
                "grant_type":"refresh_token",
            ]
        
        }
    }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding { return URLEncoding.default }
    
    /// Provides stub data for use in testing.
    var sampleData: Data { switch self{
    case .getvillageList:
        return stubbedResponse("get_village_list")
    case .refresh_token:
        return stubbedResponse("")
        }}
    
    /// The type of HTTP task to be performed.
    var task: Task { return .request }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool { return false }
}
extension API{
    //类似保存数据到本地的样子 ❗️
    func stubbedResponse(_ filename:String) -> Data! {
        @objc class TestClass:NSObject {}
        
        let bundle = Bundle(for:TestClass.self)
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf:URL(fileURLWithPath:path!)))
    }
//paramer 签名
    static func sign(params:[String:String],secret:String)->String{
        var temp:String = ""
        params.keys
        .sorted()
        .forEachEnumerated { (_, key) in
            //防止中文的参数值出现乱码，先转换为 UTF-8编码
            if let value = params[key] {
                let charSet = CharacterSet(charactersIn: "\"`#%^{}\"[]|\\<>!@$*()+?,/&: ").inverted
                let encodeValue = value.addingPercentEncoding(withAllowedCharacters: charSet)
                let valueString = key + encodeValue!
                temp.append(valueString)
            }

        }
        temp.append(secret)
        
        return temp.md5()
    }
}
