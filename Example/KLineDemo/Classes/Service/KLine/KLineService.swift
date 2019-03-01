//
//  KLineService.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/21.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper

class KLineService: Service {

    //子类定义MoyaProvider
    static let provider = Service.getProvider(target: KLineTarget.self)
    
    //网络请求（固定格式）
    static func request<T>(target: KLineTarget, responseModel:T.Type, success: @escaping ((BaseResponse<T>)-> Void), failure: @escaping ((String?, BaseResponse<T>?)-> Void)) -> Cancellable {
        
        return Service.requestFormat(provider: provider, target: target, responseModel: responseModel, success: success, failure: failure)
    }
    
    //请求数组格式
    static func requestArray<Response:Mappable>(target: KLineTarget, responseModel:Response.Type, success: @escaping (([Response]?)-> Void), failure: @escaping ((String?)-> Void)) -> Cancellable{
        
        return Service.requestResponseArray(provider: provider, target: target, responseModel: responseModel, success: success, failure: failure)
    }
    
    //请求对象格式
    static func requestObject<Response:Mappable>(target: KLineTarget, responseModel:Response.Type, success: @escaping ((Response?)-> Void), failure: @escaping ((String?)-> Void)) -> Cancellable{
        
        return Service.requestResponseObject(provider: provider, target: target, responseModel: responseModel, success: success, failure: failure)
    }
}

enum KLineTarget {
    case klineWeek          //周线测试数据
    case klineDay           //日线测试数据
    case klineOneday        //分时测试数据
}

extension KLineTarget : TargetType {
    var path: String {
        switch self {
        case .klineWeek:        return APISConst.klineWeek
        case .klineDay:         return APISConst.klineDay
        case .klineOneday:      return APISConst.klineOneday
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    //对应的实例数据
    var sampleData: Data {
        return "nil".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
}
