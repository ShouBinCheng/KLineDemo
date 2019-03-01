//
//  UtilAlgorithm.swift
//  Coinx
//
//  Created by Kevin on 2018/4/28.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import Foundation

// 格指标算法
class UtilAlgorithm: NSObject {
    
    /// 计算结果并赋值到model的计算属性
    ///
    /// - Parameter models: 数据集
    static func calculationResults(models:[KLineModel]){
        
        guard models.count > 0 else {
            return
        }
        /// 分时均线
        let aveLineArray   = calculateAvePrice(datas: models)
        for i in 0 ..< models.count {
            models[i].avePrice = aveLineArray[i]
        }
        
        /// SMA
        let smaLine1Array  = calculateSMA(dayCount: KLineConst.kSMALine1Days, datas: models)
        let smaLine2Array  = calculateSMA(dayCount: KLineConst.kSMALine2Days, datas: models)
        for i in 0 ..< models.count {
            models[i].smaLine1 = smaLine1Array[i]
            models[i].smaLine2 = smaLine2Array[i]
        }
        
        /// EMA
        let emaLine1Array  = calculateEMA(dayCount: KLineConst.kEMALine1Days, datas: models)
        let emaLine2Array  = calculateEMA(dayCount: KLineConst.kEMALine2Days, datas: models)
        for i in 0 ..< models.count {
            models[i].emaLine1 = emaLine1Array[i]
            models[i].emaLine2 = emaLine2Array[i]
        }
        
        /// BOLL
        let bollSet = calculateBOLL(dayCount: KLineConst.kBOLLDayCount, k: KLineConst.kBOLL_KValue, datas: models)
        let bollArray = bollSet.0
        let ubArray   = bollSet.1
        let lbArray   = bollSet.2
        for i in 0 ..< models.count {
            models[i].boll = bollArray[i]
            models[i].ub   = ubArray[i]
            models[i].lb   = lbArray[i]
        }
        
        /// MACD
        let macdSet = calculateMACD(p1: KLineConst.kMACD_P1, p2: KLineConst.kMACD_P2, p3: KLineConst.kMACD_P3, datas: models)
        let difArray = macdSet.0
        let deaArray = macdSet.1
        let barArray = macdSet.2
        for i in 0 ..< models.count {
            models[i].dif  = difArray[i]
            models[i].dea  = deaArray[i]
            models[i].bar  = barArray[i]
        }
        
        /// KDJ
        let kdjSet = calculateKDJ(p1: KLineConst.kKDJ_P1, p2: KLineConst.kKDJ_P2, p3: KLineConst.kKDJ_p3, datas: models)
        let kArray = kdjSet.0
        let dArray = kdjSet.1
        let jArray = kdjSet.2
        for i in 0 ..< models.count {
            models[i].k = kArray[i]
            models[i].d = dArray[i]
            models[i].j = jArray[i]
        }
        
        /// RSI
        let line1Array = calculateRSI(dayCount: KLineConst.kRSILine1DayCount, datas: models)
        let line2Array = calculateRSI(dayCount: KLineConst.kRSILine2DayCount, datas: models)
        let line3Array = calculateRSI(dayCount: KLineConst.kRSILine3DayCount, datas: models)
        for i in 0 ..< models.count {
            models[i].rsiLine1 = line1Array[i]
            models[i].rsiLine2 = line2Array[i]
            models[i].rsiLine3 = line3Array[i]
        }
    }
}

//MARK: - 算法 （fileprivate）
extension UtilAlgorithm {
    
    /// 分时均线
    ///
    /// - Parameter datas: 数据集
    /// - Returns: 均值数据
    fileprivate static func calculateAvePrice(datas:[KLineModel]) -> [Double] {
        var result = [Double]()
        var totalAmount = 0.0
        var totalVolume = 0.0
        for i in 0 ..< datas.count {
            let model = datas[i]
            totalVolume += model.volume
            totalAmount += model.close * model.volume
            let avePrice = totalAmount / totalVolume
            result.append(avePrice)
        }
        return result
    }
    
    /// SMA(简单均线)
    ///
    /// - Parameters:
    ///   - dayCount: 天数
    ///   - data: 数据集
    /// - Returns: 均值数据
    fileprivate static func calculateSMA(dayCount: Int, datas: [KLineModel]) -> [Double] {
        let dayCount = dayCount - 1
        
        var result = [Double]()
        for i in 0 ..< datas.count {
            if (i < dayCount) {
                result.append(Double.nan)
                continue
            }
            var sum: Double = 0.0
            for j in 0 ..< dayCount {
                sum = sum + datas[i - j].close
            }
            result.append(abs(sum / Double(dayCount)))
        }
        return result
    }
    
    
    /// EMA(指数移动平均数)
    /// EMA（N）=2/（N+1）*（close-昨日EMA）+昨日EMA
    ///
    /// - Parameters:
    ///   - dayCount: 天数
    ///   - datas: 数据集
    /// - Returns: 均值数据
    fileprivate static func calculateEMA(dayCount: Int, datas: [KLineModel]) -> [Double] {
        var yValues = [Double]()
        var prevEma:Double = 0.0    //前一个ema
        for (index, model) in datas.enumerated() {
            let close = model.close
            var ema: Double = 0.0
            if index > 0 {
                ema = prevEma + (close - prevEma) * 2 / (Double(dayCount) + 1)
            } else {
                ema = close
            }
            yValues.append(ema)
            prevEma = ema
        }
        return yValues
    }
    
    
    /// BOLL(布林轨道算法)
    /// 计算公式
    /// 中轨线=N日的移动平均线
    /// 上轨线=中轨线+两倍的标准差
    /// 下轨线=中轨线－两倍的标准差
    /// 计算过程
    /// （1）计算MA
    /// MA=N日内的收盘价之和÷N
    /// （2）计算标准差MD
    /// MD=平方根（N）日的（C－MA）的两次方之和除以N
    /// （3）计算MB、UP、DN线
    /// MB=（N）日的MA
    /// UP=MB+k×MD
    /// DN=MB－k×MD
    /// （K为参数，可根据股票的特性来做相应的调整，一般默认为2）
    /// - Parameters:
    ///   - dayCount: 天数
    ///   - k: 参数值
    ///   - datas: 数据集
    /// - Returns: (BOLL,UB,LB)
    fileprivate static func calculateBOLL(dayCount:Int, k:Int=2 ,datas:[KLineModel]) -> ([Double],[Double],[Double]) {
        
        var bollValues = [Double]()
        var ubValues = [Double]()
        var lbValues = [Double]()
        
        // n天标准差
        var mdArray = calculateBOLLSTD(dayCount: dayCount, datas: datas)
        // n天均值
        var mbArray = calculateSMA(dayCount: dayCount, datas: datas)
        
        for i in 0 ..< datas.count {
            let md = mdArray[i]
            let mb = mbArray[i]
            let ub = mb + Double(k) * md
            let lb = mb - Double(k) * md
            bollValues.append(mbArray[i])
            ubValues.append(ub)
            lbValues.append(lb)
        }
        return (bollValues,ubValues,lbValues)
    }
    
    /// 计算布林线中的MA平方差
    ///
    /// - Parameters:
    ///   - dayCount: 天数
    ///   - datas: 数据集
    /// - Returns: 结果
    fileprivate static func calculateBOLLSTD(dayCount:Int, datas:[KLineModel]) -> [Double] {
        
        var mdArray = [Double]()
        
        // n天均值
        var maArray = calculateSMA(dayCount: dayCount, datas: datas)
        
        for index in 0 ..< datas.count {
            if index + 1 >= dayCount {
                var dx:Double = 0.0
                for i in stride(from: index, through: index + 1 - dayCount, by: -1) {
                    dx += pow(datas[i].close - maArray[i], 2)
                }
                var md = dx / Double(dayCount)
                md = pow(md, 0.5)
                mdArray.append(md)
            }else{
                var dx:Double = 0.0
                for i in stride(from: index, through: 0, by: -1) {
                    dx += pow(datas[i].close - maArray[i], 2)
                }
                var md = dx / Double(dayCount)
                md = pow(md, 0.5)
                mdArray.append(md)
            }
        }
        return mdArray
    }
    

    /// MACD(平滑异同移动平均线)
    ///
    /// - Parameters:
    ///   - p1: 天数1 （12）
    ///   - p2: 天数2 （26）
    ///   - p3: 天数3 （9）
    ///   - datas: 数据集
    /// - Returns: ([DIF],[DEA],[BAR])
    fileprivate static func calculateMACD(p1:Int, p2:Int, p3:Int, datas:[KLineModel]) -> ([Double],[Double],[Double]){
        var difArray = [Double]()
        var deaArray = [Double]()
        var barArray = [Double]()
        
        //EMA（p1）=2/（p1+1）*（C-昨日EMA）+昨日EMA；
        let p1EmaArray = calculateEMA(dayCount: p1, datas: datas)
        //EMA（p2）=2/（p2+1）*（C-昨日EMA）+昨日EMA；
        let p2EmaArray = calculateEMA(dayCount: p2, datas: datas)
        //昨日dea
        var prevDea:Double = 0.0
        
        for i in 0 ..< datas.count {
            //DIF=今日EMA（p1）- 今日EMA（p2）
            let dif = p1EmaArray[i] - p2EmaArray[i]
            //dea（p3）=2/（p3+1）*（dif-昨日dea）+昨日dea；
            let dea = prevDea + (dif - prevDea) * 2 / (Double(p3) + 1)
            //BAR=2×(DIF－DEA)
            let bar = 2 * (dif - dea)
            prevDea = dea
            
            difArray.append(dif)
            deaArray.append(dea)
            barArray.append(bar)
        }
        return (difArray,deaArray,barArray)
    }
    
    
    /// MDJ()
    ///
    /// - Parameters:
    ///   - p1: k指标周期(9)
    ///   - p2: d指标周期(3)
    ///   - p3: j指标周期(3)
    ///   - datas: 数据集
    /// - Returns: ([K],[D],[J])
    fileprivate static func calculateKDJ(p1:Int, p2:Int, p3:Int, datas:[KLineModel]) -> ([Double],[Double],[Double]) {
        var kArray = [Double]()
        var dArray = [Double]()
        var jArray = [Double]()
        
        var prevK:Double = 50.0
        var prevD:Double = 50.0
        
        let rsvArray = calculateRSV(dayCount: p1, datas: datas)
        
        for i in 0 ..< datas.count {
            let rsv = rsvArray[i]
            let k = (2 * prevK + rsv) / 3
            let d = (2 * prevD + k) / 3
            let j = 3 * k - 2 * d
            prevK = k
            prevD = d
            kArray.append(k)
            dArray.append(d)
            jArray.append(j)
        }
        return (kArray,dArray,jArray)
    }
    
    
    /// RSV(未成熟随机值)
    ///
    /// - Parameters:
    ///   - dayCount: 计算天数范围
    ///   - index: 当前的索引位
    ///   - datas: 数据集
    /// - Returns: RSV集
    fileprivate static func calculateRSV(dayCount:Int, datas:[KLineModel]) -> [Double] {
        var rsvArray = [Double]()
        for i in (0 ..< datas.count) {
            var rsv   = 0.0
            let close = datas[i].close
            var high  = datas[i].high
            var low   = datas[i].low
            
            let startIndex = i < dayCount ? 0 : i - dayCount + 1
            //计算dayCount天内最高价最低价
            for j in (startIndex ..< i){
                high = datas[j].high > high ? datas[j].high : high
                low  = datas[j].low  < low  ? datas[j].low  : low
            }
            if high != low {
                rsv = (close - low) / (high - low) * 100
            }
            rsvArray.append(rsv)
        }
        return rsvArray
    }
    
    
    /// RSI(相对强弱指标)
    /// 算法:N日RSI =N日内收盘涨幅的平均值/(N日内收盘涨幅均值+N日内收盘跌幅均值) ×100
    ///
    /// - Parameters:
    ///   - dayCount: 周期天数
    ///   - datas: 数据源
    /// - Returns: 结果集
    fileprivate static func calculateRSI(dayCount:Int, datas:[KLineModel]) -> [Double]{
        
        var rsiArray = [Double]()   //rsi值
        var ratioArray = [Double]() //涨跌幅
        for model in datas {
            if model.open == 0 {
                ratioArray.append(0)
            } else {
                let ratio = (model.close - model.open)/model.open
                ratioArray.append(ratio)
            }
        }
        for i in 0 ..< ratioArray.count {
            let startIndex = i <= dayCount ? 0 : i-dayCount
            var upSum:Double   = 0.0
            var downSum:Double = 0.0
            for j in startIndex ... i {
                if ratioArray[j] >= 0 {
                    upSum += ratioArray[j] //n日收盘涨幅总和
                }else{
                    downSum += ratioArray[j] //n日收盘跌幅总和
                }
            }
            let upAve = upSum / Double(dayCount)
            let downAve = downSum / Double(dayCount)
            let rsi = upAve / (upAve - downAve) * 100
            rsiArray.append(rsi)
        }
        return rsiArray
    }
}
