//
//  KLineConst.swift
//  Coinx
//
//  Created by Kevin on 2018/4/27.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

class KLineConst: NSObject {
    
    /// 背景色
    static let kLineBgColor = UIColor(hexString: "#181C26")

    /// k线加载数据量
    static let kLoadingLimit:Int    = 720
    
    /// 显示蜡烛的默认最大最少条数
    static let showDefaultCount:Int = 80
    static let showMinCount:Int     = 10
    static let showMaxCount:Int     = 150
    
    /// 蜡烛图颜色
    static let kCandleRedColor   = UIColor(hexString: "#F2334F")
    static let kCandleGreenColor = UIColor(hexString: "#45B854")
    
    /// 分时线颜色
    static let kTimeLineColor = UIColor(hexString: "#567AF2")
    
    /// 分时均线线颜色
    static let kTimeLineAveLineColor = UIColor(hexString: "#53E7F2")
    
    /// SMA指标线天数
    static let kSMALine1Days = 7
    static let kSMALine2Days = 25
    //  SMA指标线颜色
    static let kSMALine1Color = UIColor(hexString: "#54AFFF")
    static let kSMALine2Color = UIColor(hexString: "#FF904C")
    
    /// EMA指标线天数
    static let kEMALine1Days = 7
    static let kEMALine2Days = 25
    // EMA指标线颜色
    static let kEMALine1Color = UIColor(hexString: "#54AFFF")
    static let kEMALine2Color = UIColor(hexString: "#FF904C")
    
    /// BOLL指标天数、k值、线颜色
    static let kBOLLDayCount  = 20
    static let kBOLL_KValue   = 2
    static let kBOLLLineColor = UIColor(hexString: "#7BA5A6")

    /// MACD指标
    static let kMACD_P1 = 12
    static let kMACD_P2 = 26
    static let kMACD_P3 = 9
    static let kMACDDifLineColor = UIColor(hexString: "#B99E51")
    static let kMACDDeaLineColor = UIColor(hexString: "#7BA5A6")
    
    /// KDJ指标
    static let kKDJ_P1 = 9
    static let kKDJ_P2 = 3
    static let kKDJ_p3 = 3
    static let kKDJKLineColor = UIColor(hexString: "#B99E51")
    static let kKDJDLineColor = UIColor(hexString: "#81D6D9")
    static let kKDJJLineColor = UIColor(hexString: "#725839")
    
    /// RSI指标
    static let kRSILine1DayCount = 6
    static let kRSILine2DayCount = 12
    static let kRSILine3DayCount = 24
    static let kRSILine1Color = UIColor(hexString: "#7CFFFB")
    static let kRSILine2Color = UIColor(hexString: "#FF99EA")
    static let kRSILine3Color = UIColor(hexString: "#DDFF68")
    
    /// KLineInfoView
    static let kInfoLineColor = UIColor(hexString: "#5E6163")
    
    /// 深度图买盘线颜色
    static let kLineDepthBuyLineColor = UIColor(hexString: "#45B854")
    /// 深度图卖盘线颜色
    static let kLineDepthSellLineColor = UIColor(hexString: "#F2334F")
}
