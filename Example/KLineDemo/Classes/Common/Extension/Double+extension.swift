//
//  Double+extension.swift
//  Coinx
//
//  Created by Kevin on 2018/5/3.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import Foundation

extension Double {
    func toString2f() -> String{
        return String(format: "%.2f",  self)
    }
    func toString(pointCount:Int = 2) -> String{
        return String(format: "%.\(pointCount)f",  self)
    }
    
    /// 保留最长显示位数
    func toString(maxLongCount:Int) -> String{
        let tmpCount = maxLongCount-1
        for count in stride(from: tmpCount, through: 0, by: -1) {
            if Decimal(self) >= pow(10, count) {
                return self.toString(pointCount: tmpCount-count)
            }
        }
        return self.toString(pointCount: tmpCount)
    }
    
    fileprivate func cleanZero(numString:String) -> String{
        
        //TODO:去掉多余0
        return ""
    }
}

extension Float {
    func toString2f() -> String{
        return String(format: "%.2f",  self)
    }
    func toString(pointCount:Int = 2) -> String{
        return String(format: "%.\(pointCount)f",  self)
    }
}
