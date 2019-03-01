//
//  Service.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/21.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Moya
import Alamofire
import ObjectMapper

class Service: NSObject {

    //请求超时时间
    static let timeOut = 16.0
    
    //网络加载提示{闭包}
    static let spinerPlugin = NetworkActivityPlugin { state,targetType   in
        if state == .began{
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }else{
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    //日记log打印{闭包}
    static let networkPlugin = NetworkLoggerPlugin(verbose:true,responseDataFormatter:JSONResponseDataFormatter)
    
    //格式化日记log
    static func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data
        }
    }
    
    //获取请求者
    static func getProvider<T>(target:T.Type) -> MoyaProvider<T> {
        if Config.isOpenNetworkLog {
            return MoyaProvider<T>(requestClosure:{ (endpoint, done) in
                //设置请求超时
                guard var request = try? endpoint.urlRequest() else { return }
                request.timeoutInterval = timeOut
                done(.success(request))
            }, plugins:[spinerPlugin,networkPlugin],trackInflights:true)
        }else{
            return MoyaProvider<T>(requestClosure:{ (endpoint, done) in
                //设置请求超时
                guard var request = try? endpoint.urlRequest() else { return }
                request.timeoutInterval = timeOut
                done(.success(request))
            },plugins:[spinerPlugin],trackInflights:true)
        }
    }
    
    
    //网络请求（固定格式）
    static func requestFormat<T,Target>(provider:MoyaProvider<Target>, target: Target, responseModel:T.Type, success: @escaping ((BaseResponse<T>)-> Void), failure: @escaping ((String?, BaseResponse<T>?)-> Void)) -> Cancellable{
        
        return provider.request(target) { (result) in
            
            switch result{
            case .success(let response):
                switch response.statusCode{
                case 200:
                    do {
                        //数据解析
                        let json = try response.mapJSON()
                        guard json is [String:Any] else {
                            return
                        }
                        
                        if let res = BaseResponse<T>(JSON: json as! [String:Any]) {
                            guard let code = res.code else {
                                failure(res.msg,res)
                                return
                            }
                            if Int(code) == 0{
                                success(res)
                            }else{
                                failure(res.msg,res)
                            }
                        }else{
                            
                        }
                    }catch{
                        failure("json解析错误",nil)
                    }
                case 401:
                    break
                default:
                    failure("网络错误",nil)
                }
            case .failure(let error):
                failure("服务器链接失败:\(error.localizedDescription)",nil)
            }
        }
    }
    
    //请求数组格式
    static func requestResponseArray<Target,Response:Mappable>(provider:MoyaProvider<Target>, target: Target, responseModel:Response.Type, success: @escaping (([Response]?)-> Void), failure: @escaping ((String?)-> Void)) -> Cancellable{
        return provider.request(target, completion: { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    do{
                        let json = try response.mapJSON()
                        guard json is [Any] else {
                            failure("json数据格式不正确")
                            return
                        }
                        let res = [Response](JSONArray: json as! [[String : Any]])
                        success(res)
                    }catch{
                        failure("json解析失败")
                    }
                default:
                    failure("网络错误")
                }
            case .failure(let error):
                failure("服务器链接失败:\(error.localizedDescription)")
            }
        })
    }
    
    //请求对象格式
    static func requestResponseObject<Target,Response:Mappable>(provider:MoyaProvider<Target>, target: Target, responseModel:Response.Type, success: @escaping ((Response?)-> Void), failure: @escaping ((String?)-> Void)) -> Cancellable{
        return provider.request(target, completion: { (result) in
            switch result {
            case .success(let response):
                switch response.statusCode {
                case 200:
                    do{
                        let json = try response.mapJSON()
                        guard json is [String:Any] else {
                            failure("json数据格式不正确")
                            return
                        }
                        let res = Response(JSON: json as! [String:Any])
                        success(res)
                    }catch{
                        failure("json解析失败")
                    }
                default:
                    failure("网络错误")
                }
            case .failure(let error):
                failure("服务器链接失败:\(error.localizedDescription)")
            }
        })
    }

}
