//
//  KLineDepthModel.swift
//  Coinx
//
//  Created by Kevin on 2018/5/7.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import Foundation

struct KLineDepthModel {
    var timestamp:Int   = 0         //时间戳
    var priceKey:String = ""        //价格字符串
    var volumeValue:String = ""     //挂单量字符串
    
    var price:Double    = .nan       //价格
    var volume:Double   = .nan       //挂单量
    
    init(price:String, volume:String, timestamp:Int) {
        self.priceKey = price
        self.volumeValue = volume
        self.timestamp = timestamp
        self.price = Double(price) ?? .nan
        self.volume = Double(volume) ?? .nan
    }
    
    init() {
        self.price = .nan
        self.volume = .nan
    }
}
