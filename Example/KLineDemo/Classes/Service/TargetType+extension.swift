//
//  TargetType+extension.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/21.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    
    var baseURL: URL {
        return URL(string:APISConst.baseUrl)!
    }
    
    var headers: [String: String]? {
        return [
            "os":"iOS"
        ]
    }
}
