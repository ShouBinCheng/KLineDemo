//
//  FiveTradeModel.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/22.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import ObjectMapper

/// 五档模型
struct FiveTradeModel : Mappable {
    
    var symbol:String?
    var time:String?
    
    var bp1:Double? //买盘价
    var bc1:Double? //买量
    var bp2:Double?
    var bc2:Double?
    var bp3:Double?
    var bc3:Double?
    var bp4:Double?
    var bc4:Double?
    var bp5:Double?
    var bc5:Double?
    var bp6:Double?
    var bc6:Double?
    var bp7:Double?
    var bc7:Double?
    var bp8:Double?
    var bc8:Double?
    var bp9:Double?
    var bc9:Double?
    var bp10:Double?
    var bc10:Double?
    
    var current:Double? //当前价
    
    var sp1:Double?  //卖盘价
    var sc1:Double?  //卖量
    var sp2:Double?
    var sc2:Double?
    var sp3:Double?
    var sc3:Double?
    var sp4:Double?
    var sc4:Double?
    var sp5:Double?
    var sc5:Double?
    var sp6:Double?
    var sc6:Double?
    var sp7:Double?
    var sc7:Double?
    var sp8:Double?
    var sc8:Double?
    var sp9:Double?
    var sc9:Double?
    var sp10:Double?
    var sc10:Double?
    
    var buypct:Double?
    var sellpct:Double?
    var diff:Double?
    var ratio:Double?
    
    init?(map: Map) {
    }
    mutating func mapping(map: Map) {
        symbol      <- map["symbol"]
        time        <- map["time"]
        
        bp1         <- map["bp1"]
        bc1         <- map["bc1"]
        bp2         <- map["bp2"]
        bc2         <- map["bc2"]
        bp3         <- map["bp3"]
        bc3         <- map["bc3"]
        bp4         <- map["bp4"]
        bc4         <- map["bc4"]
        bp5         <- map["bp5"]
        bc5         <- map["bc5"]
        bp6         <- map["bp6"]
        bc6         <- map["bc6"]
        bp7         <- map["bp7"]
        bc7         <- map["bc7"]
        bp8         <- map["bp8"]
        bc8         <- map["bc8"]
        bp9         <- map["bp9"]
        bc9         <- map["bc9"]
        bp10        <- map["bp10"]
        bc10        <- map["bc10"]
        
        current     <- map["current"]
        
        sp1         <- map["sp1"]
        sc1         <- map["sc1"]
        sp2         <- map["sp2"]
        sc2         <- map["sc2"]
        sp3         <- map["sp3"]
        sc3         <- map["sc3"]
        sp4         <- map["sp4"]
        sc4         <- map["sc4"]
        sp5         <- map["sp5"]
        sc5         <- map["sc5"]
        sp6         <- map["sp6"]
        sc6         <- map["sc6"]
        sp7         <- map["sp7"]
        sc7         <- map["sc7"]
        sp8         <- map["sp8"]
        sc8         <- map["sc8"]
        sp9         <- map["sp9"]
        sc9         <- map["sc9"]
        sp10        <- map["sp10"]
        sc10        <- map["sc10"]
        
        buypct      <- map["buypct"]
        sellpct     <- map["sellpct"]
        diff        <- map["diff"]
        ratio       <- map["ratio"]
    }
}
