//
//  KLineResponse.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/21.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import ObjectMapper

//周线测试数据
struct KlineWeekResponse : Mappable {
    var time:String?
    var price_o:String?
    var price_c:String?
    var price_h:String?
    var price_l:String?
    var volume:String?
    var volume_price:String?
    var zf_bfb:String?
    
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        time            <- map["time"]
        price_o         <- map["price_o"]
        price_c         <- map["price_c"]
        price_h         <- map["price_h"]
        price_l         <- map["price_l"]
        volume          <- map["volume"]
        volume_price    <- map["volume_price"]
        zf_bfb          <- map["zf_bfb"]
    }
}

//日线测试数据
struct KLineDayResponse : Mappable{
    
    var volume:String?
    var zf_bfb:String?
    var time:String?
    var price_l:String?
    var price_h:String?
    var volume_price:String?
    var price_c:String?
    var price_o:String?
    
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        volume          <- map["volume"]
        zf_bfb          <- map["zf_bfb"]
        time            <- map["time"]
        price_l         <- map["price_l"]
        price_h         <- map["price_h"]
        volume_price    <- map["volume_price"]
        price_c         <- map["price_c"]
        price_o         <- map["price_o"]
    }
}

//分时测试数据
struct KlineOnedayResponse : Mappable {
    
    var time:String?
    var price:String?
    var volume:String?
    var average:String?
    var num:String?
    
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        time        <- map["time"]
        price       <- map["price"]
        volume      <- map["volume"]
        average     <- map["average"]
        num         <- map["num"]
    }
}
