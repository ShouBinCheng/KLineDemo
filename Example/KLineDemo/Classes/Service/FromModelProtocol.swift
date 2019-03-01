//
//  FromModelProtocol.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/21.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation

/// 表单类型(简称FM)
public protocol FromModel: Codable {}

extension FromModel{
    
    /// 转换为字典
    func toDic() -> Dictionary<String, Any> {
        let mirror = Mirror(reflecting: self)
        var dic: Dictionary<String, Any> = [:]
        for case let(key?, value) in mirror.children {
            if let temp = UtilMirror.unwrap(any: value) as? Int {
                dic[key] = temp
            }
            if let temp = UtilMirror.unwrap(any: value) as? String {
                dic[key] = temp
            }
            if let temp = UtilMirror.unwrap(any: value) as? Float {
                dic[key] = temp
            }
            if let temp = UtilMirror.unwrap(any: value) as? Double {
                dic[key] = temp
            }
        }
        return dic
    }
}

fileprivate class UtilMirror: Any {
    
    //根据属性名字符串获取属性值
    class func getValueByKey(obj:AnyObject, key: String) -> Any {
        let hMirror = Mirror(reflecting: obj)
        for case let (label?, value) in hMirror.children {
            if label == key {
                return unwrap(any: value)
            }
        }
        return NSNull()
    }
    
    //将可选类型（Optional）拆包
    class func unwrap(any:Any) -> Any {
        let mi = Mirror(reflecting: any)
        if mi.displayStyle != nil {
            return any
        }
        
        if mi.children.count == 0 { return any }
        let (_, some) = mi.children.first!
        return some
    }
    
}
