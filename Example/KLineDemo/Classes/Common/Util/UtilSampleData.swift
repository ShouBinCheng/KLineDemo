//
//  UtilSampleData.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/22.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Foundation

class UtilSampleData: NSObject {

    /// 分时数据
    static func getTimeLineForDay() -> Dictionary<String, Any>? {
        return getSamepleData(fileName: "timeLineForDay")
    }
    
    /// 月k线数据
    static func getKLineForMonth() -> Dictionary<String, Any>? {
        return getSamepleData(fileName: "kLineForMonth")
    }
    
    /// 日k线数据
    static func getKLineForDay() -> Dictionary<String, Any>? {
        return getSamepleData(fileName: "kLineForDay")
    }
    
    /// 周k线数据
    static func getKLineForWeek() -> Dictionary<String, Any>? {
        return getSamepleData(fileName: "kLineForWeek")
    }
    
    /// 五日线数据
    static func getTimeLineForFiveday() -> Dictionary<String, Any>? {
        return getSamepleData(fileName: "timeLineForFiveday")
    }
    
    /// 买卖五档数据
    static func getFiveTrade () -> Dictionary<String, Any>? {
        return getSamepleData(fileName: "fiveTrade")
    }
    
    fileprivate static func getSamepleData(fileName:String) -> Dictionary<String, Any>? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) else {
            return nil
        }
        guard jsonData is Dictionary<String, Any> else {
            return nil
        }
        let json = jsonData as! Dictionary<String, Any>
        return json
    }
}
