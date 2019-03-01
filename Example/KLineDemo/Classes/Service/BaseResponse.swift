//
//  BaseResponse.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/21.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import ObjectMapper

///子类无需集成。仅需对应data格式和Codable
class BaseResponse<T: Mappable>: Mappable {
    
    var code:String?// 服务端返回码
    var msg:String?
    var data: T?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map){
        code    <- map["code"]
        msg     <- map["msg"]
        data    <- map["data"]
    }
}

struct EmptyResponse: Mappable{
    
    init?(map: Map){
    }
    func mapping(map: Map){
    }
}
