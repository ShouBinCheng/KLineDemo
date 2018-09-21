//
//  KLinePeriod.swift
//  Coinx
//
//  Created by Kevin on 2018/5/3.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import Foundation

// k线周期
enum KLinePeriod {
    
    case periodTimeLine
    case periodMinute_1
    case periodMinute_5
    case periodMinute_15
    case periodMinute_30
    case periodHour_1
    case periodHour_2
    case periodHour_4
    case periodHour_6
    case periodHour_12
    case periodDay
    case periodWeek
    
    fileprivate static let periods = ["分时","1分","5分","15分","30分",
                          "1小时","2小时","4小时","6小时","12小时",
                          "日线","周线"]
    
    fileprivate static let kPeriods:[KLinePeriod] = [.periodTimeLine,.periodMinute_1,.periodMinute_5,
                                       .periodMinute_15,.periodMinute_30,.periodHour_1,
                                       .periodHour_2,.periodHour_4,.periodHour_6,.periodHour_12,
                                       .periodDay,.periodWeek]
    
    fileprivate static let minutes:[Int] = [1,1,5,15,30,60,120,240,360,720,1440,10080]
    
    static func getAllPeriods() -> [String] {
        return periods
    }
    
    /// 根据枚举返回下标
    static func indexFor(kPeriod:KLinePeriod) -> Int {
        return kPeriods.index(of: kPeriod)!
    }
    
    /// 根据枚举返回标题
    static func titleFor(kPeriod:KLinePeriod) -> String? {
        let index = indexFor(kPeriod: kPeriod)
        return periods[index]
    }
    
    /// 根据下标返回枚举
    static func kPeriodFor(index:Int) -> KLinePeriod? {
        guard index >= 0 && index < kPeriods.count else {
            return nil
        }
        return kPeriods[index]
    }
    
    /// 根据枚举返回时间间隔
    static func minuteFor(kPeriod:KLinePeriod) -> Int{
        let index = indexFor(kPeriod: kPeriod)
        return minutes[index]
    }
    
    fileprivate static let kDefaultKlinePeriod = "KLine_DefaultKLinePeriod"    //k线周期
    
    /// 获取沙盒k线周期
    static func getDefaultKLinePeriod() -> KLinePeriod {
        guard let index = UserDefaults.standard.value(forKey: kDefaultKlinePeriod) else {
            return .periodTimeLine
        }
        guard index is Int else {
            UserDefaults.standard.set(KLinePeriod.periodTimeLine, forKey: kDefaultKlinePeriod)
            UserDefaults.standard.synchronize()
            return .periodTimeLine
        }
        guard let kPeriod = kPeriodFor(index: index as! Int) else {
            UserDefaults.standard.set(KLinePeriod.periodTimeLine, forKey: kDefaultKlinePeriod)
            UserDefaults.standard.synchronize()
            return .periodTimeLine
        }
        return kPeriod
    }
    
    /// 设置沙盒k线周期
    static func setDefaultKLinePeriod(_ kPeriod:KLinePeriod){
        let index = indexFor(kPeriod: kPeriod)
        UserDefaults.standard.set(index, forKey: kDefaultKlinePeriod)
        UserDefaults.standard.synchronize()
    }
}
