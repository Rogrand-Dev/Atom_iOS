//
//  Observable+Logging.swift
//  BaseFrameworksDemo
//
//  Created by 齐翠丽 on 17/5/3.
//  Copyright © 2017年 RG. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    func logError(prefix: String = "Error: ") -> Observable<Element> {
        return self.do(onError: { error in
            print("\(prefix)\(error)")
        })
    }
    
    func logServerError(message: String) -> Observable<Element> {
        return self.do(onError: { e in
            let error = e as NSError
            log.debug(message)
            log.error("Error: \(error.localizedDescription))")
        })
    }
    
    func logNext() -> Observable<Element> {
        return self.do(onNext: { element in
            print("\(element)")
        })
    }
}
