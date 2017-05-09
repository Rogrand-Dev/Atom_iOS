//
//  ReachabilityManager.swift
//  Networking
//
//  Created by 武飞跃 on 2017/5/8.
//  Copyright © 2017年 武飞跃. All rights reserved.
//

import Foundation
import ReachabilitySwift
import RxCocoa
import RxSwift

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
