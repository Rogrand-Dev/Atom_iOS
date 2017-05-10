//
//  GlobalFounction.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/3.
//  Copyright © 2017年 RG. All rights reserved.
//
import RxSwift
import ReachabilitySwift
import Moya
import XCGLogger
let log: XCGLogger = {
    
    let log = XCGLogger.default
    #if USE_NSLOG
        log.remove(destinationWithIdentifier: XCGLogger.Constants.baseConsoleDestinationIdentifier)
        log.add(destination: AppleSystemLogDestination(identifier: XCGLogger.Constants.systemLogDestinationIdentifier))
        log.logAppDetails()
    #else
        //        let logPath: URL = URL(string:FYSandboxHelper.cachePath())!.appendingPathComponent("XCGLogger_Log.txt")
        log.setup(level: .debug, showThreadName: true, showLevel: false, showFileNames: true, showLineNumbers: true, writeToFile: nil)
    #endif
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🔹🔹🔹 ", postfix: "", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ℹ️ℹ️ ", postfix: "", to: .info)
    emojiLogFormatter.apply(prefix: "‼️‼️‼️ ", postfix: "", to: .error)
    log.formatters = [emojiLogFormatter]
    return log
}()

let reachabilityManager = ReachabilityManager()

func connectedToInternetOrStubbing() -> Observable<Bool> {
    //    let stubbing = Observable.just(APIKeys.sharedKeys.stubResponses)
    
    //    guard let online = reachabilityManager?.reach else {
    //        return stubbing
    //    }
    
    if let online = reachabilityManager?.reach {
        return online
    }
    else{
        return Observable.just(false)
    }
    
    //    return [online, stubbing].combineLatestOr()
}

//检索是否处于开发环境 其中(arch(i386) || arch(x86_64)) && os(iOS)表示模拟器环境
func detectDevelopmentEnvironment() -> Bool {
    var developmentEnvironment = false
    #if DEBUG || (arch(i386) || arch(x86_64)) && os(iOS)
        developmentEnvironment = true
    #endif
    return developmentEnvironment
}

///响应成功
func responseIsOk(_ response: Response) -> Bool {
    return response.statusCode == 200
}

class ReachabilityManager{
    private let reachability:Reachability
    
    let _reach = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return _reach.asObserver()
    }
    init?(){
        guard let r = Reachability() else {
            return nil
        }
        self.reachability = r
        
        do {
            try self.reachability.startNotifier()
        }catch{
            return nil
        }
        
        self._reach.onNext(self.reachability.isReachable)
        
        self.reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                self._reach.onNext(true)
            }
        }
        
        self.reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self._reach.onNext(false)
            }
        }
    }
    
    deinit {
        reachability.stopNotifier()
    }
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}


/// 在给定时间段内，不重复触发闭包的事件
///
/// - Parameters:
///   - interval: 给定时间 默认 300 秒
///   - identifier: 本地存储的标示 默认 lastimeisVaild
///   - closure: 在时间过期以后的回调
func updateAction(withInterval interval:TimeInterval = 300,
                  identifier:String = "lastimeisVaild",
                  closure:()->Void){
    
    let currentDate = Date()
    let currentInterval = currentDate.timeIntervalSince1970
    
    //检索本地是否存在lastimeisVaild字段
    if let lastInterval = UserDefaults.standard.value(forKey: identifier) as? Double {
        
        var isVaild:Bool {
            if currentInterval - lastInterval < interval {
                return true
            }
            else{
                return false
            }
        }
        
        //时间是否有效(在给定时间返回内，不做处理)
        if isVaild {
            return
        }
        
    }
    
    closure()
    UserDefaults.standard.set(currentInterval, forKey: identifier)
    UserDefaults.standard.synchronize()
    
    
}

