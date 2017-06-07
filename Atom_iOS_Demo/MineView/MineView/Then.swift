//
//  Then.swift
//  Examples
//
//  Created by xuemincai on 2016/11/27.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation


public protocol Then {}

extension Then where Self: Any {
    public func then(block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

extension Then where Self: AnyObject {
    public func then(block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Then {}
