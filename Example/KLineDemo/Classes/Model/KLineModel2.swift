//
//  KLineModel2.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/22.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import ObjectMapper

struct KLineModel2 : Mappable {
    
    /// 分时(五日分时)使用到的字段
    /*
    var volume:Double?
    var avg_price:Double?
    var current:Double?
    var time:String?
    */
    var avg_price:Double?
    var current:Double?
    
    // k线
    var volume:Double?
    var open:Double?
    var high:Double?
    var close:Double?
    var low:Double?
    var chg:Double?
    var percent:Double?
    var turnrate:Double?
    var ma5:Double?
    var ma10:Double?
    var ma20:Double?
    var ma30:Double?
    var dif:Double?
    var dea:Double?
    var macd:Double?
    var time:String?
    
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
    
        avg_price       <- map["avg_price"]
        current         <- map["current"]
        

        volume          <- map["volume"]
        open            <- map["open"]
        high            <- map["high"]
        close           <- map["close"]
        low             <- map["low"]
        chg             <- map["chg"]
        percent         <- map["percent"]
        turnrate        <- map["turnrate"]
        ma5             <- map["ma5"]
        ma10            <- map["ma10"]
        ma20            <- map["ma20"]
        ma30            <- map["ma30"]
        dif             <- map["dif"]
        dea             <- map["dea"]
        macd            <- map["macd"]
        time            <- map["time"]
    }
}
