//
//  Utility.swift
//  MineView
//
//  Created by 刘岭 on 2017/6/5.
//  Copyright © 2017年 刘岭. All rights reserved.
//

import UIKit
import Foundation

class Utility {
    
}

extension NSObject {
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}

