//
//  KLineSampleDataResponse.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/22.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import ObjectMapper

struct KLineSampleDataResponse : Mappable{
    
    var symbol:String?
    
    var success:String?
    var chartlist:[KLineModel2]?
    
    init?(map: Map) {
    
    }
    mutating func mapping(map: Map) {
        symbol      <- map["stock.symbol"]
        success     <- map["success"]
        chartlist   <- map["chartlist"]
    }
}
