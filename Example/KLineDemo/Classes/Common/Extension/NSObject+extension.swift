//
//  NSObject+extension.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation

extension NSObject {
    public var className: String {
        return type(of: self).className
    }
    
    public static var className: String {
        return String(describing: self)
    }
}
