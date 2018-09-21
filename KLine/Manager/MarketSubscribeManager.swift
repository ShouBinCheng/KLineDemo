//
//  MarketSubscribeManager.swift
//  Coinx
//
//  Created by Kevin on 2018/5/8.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

/// socket 订阅回调
protocol MarketSubscribeManagerDelegate : NSObjectProtocol {
    /// 回调最新成交
    func subscribeTrades(datas:[TradesModel])
    /// 回调全量深度数据
    func subscribeDepthUpdate(buyData:[KLineDepthModel], sellData:[KLineDepthModel])
}

/// socket 订阅管理
class MarketSubscribeManager: NSObject {
    /// 构造
    init(bitCode:String) {
        super.init()
        self.bitCode = bitCode
        subscribe()
        self.requestDepth()
    }
    
    /// 币码
    private var bitCode:String!
    
    /// 回调数据
    private lazy var delegates:[MarketSubscribeManagerDelegate] = {
        let delegates = [MarketSubscribeManagerDelegate]()
        return delegates
    }()
    
    /// 是否已经返回全量数据
    private var isHasAllData:Bool = false
    /// 买盘字典
    private var buyDataDic:Dictionary<String,KLineDepthModel> = Dictionary<String,KLineDepthModel>()
    /// 卖盘字典
    private var sellDataDic:Dictionary<String,KLineDepthModel> = Dictionary<String,KLineDepthModel>()
    /// 买盘增量缓冲
    private lazy var buyArraybuf:[KLineDepthModel] = {
        let buyArraybuf = [KLineDepthModel]()
        return buyArraybuf
    }()
    /// 卖盘增量缓冲
    private lazy var sellArraybuf:[KLineDepthModel] = {
        let buyArraybuf = [KLineDepthModel]()
        return buyArraybuf
    }()
    
    /// 新增代理
    public func addDelegate(_ delegate:MarketSubscribeManagerDelegate){
        let isHas = delegates.contains { (item) -> Bool in
            if item === delegate {
                return true
            }else{
                return false
            }
        }
        if !isHas {
            delegates.append(delegate)
            //首次订阅，如有数据返回数据给代理
            handleDepthCall([delegate])
        }
    }
    
    /// 删除代理
    public func removeDelegate(_ delegate:MarketSubscribeManagerDelegate){
        let tempIndex = delegates.index { (itme) -> Bool in
            if itme === delegate {
                return true
            }else{
                return false
            }
        }
        guard let index = tempIndex else {
            return
        }
        delegates.remove(at: index)
    }
    
    /// 订阅
    private func subscribe(){
        // 订阅最新成交数据
        pusher.subscribe("market-" + bitCode + "-global").bind(eventName: "trades") { [weak self] (data: Any?) in
            guard let `self` = self else { return }
            guard data is [String:Any] else { return }
            let json = data as! [String:Any]
            let res = PagesMarketsResponse(JSON: json)!
            if let tradesArray = res.trades {
                for delegate in self.delegates {
                    delegate.subscribeTrades(datas: tradesArray)
                }
            }
        }
        // 订阅深度增量数据
        pusher.subscribe("market-" + bitCode + "-global").bind(eventName: "depthUpdate") { [weak self] (data:Any?) in
            guard let `self` = self else { return }
            guard data is [String:Any] else { return }
            let json = data as! [String:Any]
            let res = DepthResponse(JSON: json)
            if res?.buyArray == nil && res?.sellArray == nil {
                return
            }
            self.handleDepthUpdate(buyData: res?.buyArray, sellData: res?.sellArray)
        }
    }
    
    /// 取消订阅
    private func unSubscribe(){
        pusher.unsubscribe("market-" + bitCode + "-global")
    }
    
    ///处理深度数据
    ///
    /// - Parameters:
    ///   - buyData: 买盘数据
    ///   - sellData: 卖盘数据
    ///   - isAll: 是否是全量数据默认为false
    ///   - timestamp: isAll为true 时传的时间戳
    private func handleDepthUpdate(buyData:[KLineDepthModel]?, sellData:[KLineDepthModel]?, isAll:Bool = false, timestamp:Int? = nil){
        
        // 未有全量数据时的增量数据
        if isHasAllData == false && isAll == false {
            if let buyArray = buyData {
                buyArraybuf += buyArray
            }
            if let sellArray = sellData {
                sellArraybuf += sellArray
            }
            return
        }
        
        // 处理全量数据
        if isAll == true {
            isHasAllData = true
            //买盘字典
            if let buyArray = buyData {
                for model in buyArray {
                    buyDataDic.updateValue(model, forKey: model.priceKey)
                }
            }
            for model in buyArraybuf {
                if let tempTimestamp = timestamp ,model.timestamp < tempTimestamp {
                    continue
                }
                if model.volume > 0 {
                    buyDataDic.updateValue(model, forKey: model.priceKey)
                }else{
                    buyDataDic.removeValue(forKey: model.priceKey)
                }
            }
            buyArraybuf.removeAll()
            //买盘字典
            if let sellArray = sellData {
                for model in sellArray {
                    sellDataDic.updateValue(model, forKey: model.priceKey)
                }
            }
            for model in sellArraybuf {
                if let tempTimestamp = timestamp ,model.timestamp < tempTimestamp {
                    continue
                }
                if model.volume > 0 {
                    sellDataDic.updateValue(model, forKey: model.priceKey)
                }else{
                    sellDataDic.removeValue(forKey: model.priceKey)
                }
            }
            sellArraybuf.removeAll()
        }else{
        //处理增量数据
            if let buyArray = buyData {
                for model in buyArray {
                    if model.volume > 0 {
                        buyDataDic.updateValue(model, forKey: model.priceKey)
                    }else{
                        buyDataDic.removeValue(forKey: model.priceKey)
                    }
                }
            }
            if let sellArray = sellData {
                for model in sellArray {
                    if model.volume > 0 {
                        sellDataDic.updateValue(model, forKey: model.priceKey)
                    }else{
                        sellDataDic.removeValue(forKey: model.priceKey)
                    }
                }
            }
        }
        
        handleDepthCall(delegates)
    }
    
    /// 处理深度数据回调给代理
    private func handleDepthCall(_ delegates:[MarketSubscribeManagerDelegate]){
        
        guard isHasAllData == true else {
            return
        }
        
        //处理数据
        var buyDataSource = [KLineDepthModel]()
        var sellDataSource = [KLineDepthModel]()
        for dictItme in buyDataDic {
            let model = dictItme.value
            buyDataSource.append(model)
        }
        for dictItem in sellDataDic {
            let model = dictItem.value
            sellDataSource.append(model)
        }
        //排序
        buyDataSource.sort { (model1, model2) -> Bool in
            return model1.price > model2.price
        }
        var buySum = 0.0
        for i in 0 ..< buyDataSource.count {
            buyDataSource[i].volume += buySum
            buySum = buyDataSource[i].volume
        }
        buyDataSource.sort { (model1, model2) -> Bool in
            return model1.price < model2.price
        }
        
        sellDataSource.sort { (model1, model2) -> Bool in
            return model1.price < model2.price
        }
        var sellSum = 0.0
        for i in 0 ..< sellDataSource.count {
            sellDataSource[i].volume += sellSum
            sellSum = sellDataSource[i].volume
        }
        
        //回调给代理
        for delegate in delegates {
            delegate.subscribeDepthUpdate(buyData: buyDataSource, sellData: sellDataSource)
        }
    }
    
    
    /// 请求深度全量数据
    private func requestDepth(){
        let _ = KLineService.requestFormat(target: KLineTarget.depth(market: bitCode), success: { [weak self] (res) in

            guard let `self` = self else { return }
            self.handleDepthUpdate(buyData: res.data?.buyArray, sellData: res.data?.sellArray, isAll: true, timestamp: res.data?.timestamp)
            
        }, failure: { [weak self] (msg, _) in
                guard let `self` = self else { return }
                self.requestDepth()
        }, responseModel: DepthResponse.self)
    }
    
    deinit {
        delegates.removeAll()
        unSubscribe()
        print("\(self) deinit")
    }
}
