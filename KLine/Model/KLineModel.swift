//
//  KLineModel.swift
//  Coinx
//
//  Created by Kevin on 2018/4/27.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import Foundation

class KLineModel : NSObject {
    
    /// - 赋值属性 (k线)
    var timestamp:  Double = 0.0        //时间轴
    var open:       Double = 0.0        //开盘价
    var high:       Double = 0.0        //收盘价
    var low:        Double = 0.0        //最高价
    var close:      Double = 0.0        //最低价（分时price）
    var volume:     Double = 0.0        //成交量
    
    /// - 计算属性

//    var amountVol:  Double = 0.0
    var avePrice:   Double = 0.0
//    var total:      Double = 0.0
//    var maSum:      Double = 0.0
    
    //SMA(简单均线)
    var smaLine1:   Double = 0.0
    var smaLine2:   Double = 0.0
    
    //EMA(指数均线)
    var emaLine1:   Double = 0.0
    var emaLine2:   Double = 0.0
    
    //BOLL(布林轨道)
    var boll:       Double = 0.0        //布林中线
    var ub:         Double = 0.0        //布林上线
    var lb:         Double = 0.0        //布林下线
    
    //MACD
    var dif:        Double = 0.0         //短期与长期移动平均线间的离差值
    var dea:        Double = 0.0         //平滑移动平均线
    var bar:        Double = 0.0         //指数平滑移动
    
    //KDJ
    var k:          Double = 0.0         //快速线
    var d:          Double = 0.0         //慢速线
    var j:          Double = 0.0         //k&d的乘离
    
    //RSI(KLineConst.kRSILine ...)
    var rsiLine1:   Double = 0.0         //相对强弱线1
    var rsiLine2:   Double = 0.0         //相对强弱线2
    var rsiLine3:   Double = 0.0         //相对强弱线3
    
    init(timestamp: Double, open: Double, high: Double, low: Double, close: Double, volume: Double) {
        self.timestamp  = timestamp
        self.open       = open
        self.high       = high
        self.low        = low
        self.close      = close
        self.volume     = volume
    }
}
