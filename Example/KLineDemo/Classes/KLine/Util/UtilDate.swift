//
//  UtilDate.swift
//  Coinx
//
//  Created by Kevin on 2018/4/29.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

class UtilDate: NSObject {
    //格式化为自定义模式
    static func toString(formatter:String, timeIntervalSince1970: Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(timeIntervalSince1970))
        let dformatter = DateFormatter()
        dformatter.dateFormat = formatter
        return dformatter.string(from:date)
    }
}
