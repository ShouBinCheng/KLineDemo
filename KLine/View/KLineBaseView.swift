//
//  KLineBaseView.swift
//  Coinx
//
//  Created by Kevin on 2018/4/27.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

//MARK: public
class KLineBaseView: UIView {
    
    /// 移动到最右
    public func moveToLast(chartView:CombinedChartView) {
        chartView.moveViewToX(Double(Int.max))
    }
    
    /// 图表同步
    public func syncChart(chartViews:[CombinedChartView], touchMatrix:CGAffineTransform){
        for chartView in chartViews {
            chartView.viewPortHandler.refresh(newMatrix: touchMatrix, chart: chartView, invalidate: true)
        }
    }
    
    /// 顶部组合图属性设置
    public func setupTopChart(chartView:CombinedChartView){
        setupChart(chartView)
        
        chartView.xAxis.yOffset = 0.0
    }
    
    /// 底部组合图属性设置
    public func setupBottomChart(chartView:CombinedChartView){
        setupChart(chartView)
        chartView.xAxis.drawLabelsEnabled = false
//        chartView.autoScaleMinMaxEnabled = false
    }
    
    /// 获取分时线数据
    public func getTimeLineData(datas:[KLineModel]) -> LineChartData? {
        guard datas.count > 0 else {
            return nil
        }
        var yValues = [ChartDataEntry]()
        var aveValues = [ChartDataEntry]()
        for i in 0 ..< datas.count {
            let model = datas[i]
            let yEntry = ChartDataEntry(x: Double(i), y: model.close)
            let aveEntry = ChartDataEntry(x: Double(i), y: model.avePrice)
            yValues.append(yEntry)
            aveValues.append(aveEntry)
        }
        let ySet = LineChartDataSet(values: yValues, label: "timeline")
        setupLineChartDataSet(set: ySet, color: .clear)
        ySet.highlightEnabled = true
        ySet.colors = [KLineConst.kTimeLineColor]
        ySet.lineWidth = 0.5
        let gradientColors = [KLineConst.kTimeLineColor.cgColor,
                              KLineConst.kTimeLineColor.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        ySet.fillAlpha = 0.1
        ySet.fill = Fill(linearGradient: gradient, angle: 90)
        ySet.drawFilledEnabled = true
        
        let aveSet = LineChartDataSet(values: aveValues, label: "ave line")
        setupLineChartDataSet(set: aveSet, color: KLineConst.kTimeLineAveLineColor)
        aveSet.lineWidth = 0.5
        
        let data = LineChartData(dataSets: [ySet,aveSet])
        return data
    }
    
    /// 获取蜡烛图数据
    public func getCandleData(datas:[KLineModel]) -> CandleChartData? {
        
        guard datas.count > 0 else {
            return nil
        }
        var yValues = [CandleChartDataEntry]()
        for i in 0 ..< datas.count {
            let model = datas[i]
            let h = model.high
            let l = model.low
            let open = model.open
            let close = model.close
            let entry = CandleChartDataEntry(x: Double(i), shadowH: h, shadowL: l, open: open, close: close)
            yValues.append(entry)
        }
        let set = CandleChartDataSet(values: yValues, label: "candle")
        setupCandleChartDataSet(set)
        set.valueFormatter = DefaultValueFormatter(block: { (value, _, _, _) -> String in
            return value.toString(pointCount: 8)
        })
        let data = CandleChartData(dataSets: [set])
        return data
    }
    
    /// 获取柱状图数据
    public func getBarData(datas:[KLineModel]) -> BarChartData? {
        guard datas.count > 0 else {
            return nil
        }
        var yValues = [BarChartDataEntry]()
        var xColors = [UIColor]()
        for i in 0 ..< datas.count {
            let model = datas[i]
            let entry = BarChartDataEntry(x: Double(i), y: model.volume)
            yValues.append(entry)
            if  model.open > model.close {
                xColors.append(KLineConst.kCandleRedColor)
            }else{
                xColors.append(KLineConst.kCandleGreenColor)
            }
        }
        let set = BarChartDataSet(values: yValues, label: "volume")
        setupBarChartDataSet(set:set)
        set.colors = xColors
        let data = BarChartData(dataSet: set)
        data.barWidth = 0.9
        return data
    }
    
    /// 获取蜡烛图收盘价折线数据集(隐藏线)
    public func getCandleClosePriceLineDataSet(datas:[KLineModel]) -> LineChartDataSet? {
        guard datas.count > 0 else {
            return nil
        }
        var yValues = [ChartDataEntry]()
        for i in 0 ..< datas.count {
            let model = datas[i]
            let entry = ChartDataEntry(x: Double(i), y: model.close)
            yValues.append(entry)
        }
        let set = LineChartDataSet(values: yValues, label: "hidden line")
        setupLineChartDataSet(set: set, color: .clear)
        //启用高亮，只绘制水平线
        set.highlightEnabled = true
        set.drawVerticalHighlightIndicatorEnabled = false
        set.drawHorizontalHighlightIndicatorEnabled = false
//        set.isHighlightPerDragEnabled
        return set
    }
    
    /// 获取SMA线
    public func getSMALineDataSet(datas:[KLineModel]) -> [LineChartDataSet]? {
        guard datas.count > 0 else {
            return nil
        }
        var line1Values = [ChartDataEntry]()
        var line2Values = [ChartDataEntry]()
        for (index, model) in datas.enumerated() {
            if !model.smaLine1.isNaN {
                let entry1 = ChartDataEntry(x: Double(index), y: model.smaLine1)
                line1Values.append(entry1)
            }
            if !model.smaLine2.isNaN {
                let entry2 = ChartDataEntry(x: Double(index), y: model.smaLine2)
                line2Values.append(entry2)
            }
        }
        let set1 = LineChartDataSet(values: line1Values, label: "sma line1")
        setupLineChartDataSet(set: set1, color: KLineConst.kSMALine1Color)
        let set2 = LineChartDataSet(values: line2Values, label: "sma line2")
        setupLineChartDataSet(set: set2, color: KLineConst.kSMALine2Color)
        return [set1,set2]
    }
    
    /// 获取EMA线
    public func getEMALineDataSet(datas:[KLineModel]) -> [LineChartDataSet]? {
        guard datas.count > 0 else {
            return nil
        }
        var line1Values = [ChartDataEntry]()
        var line2Values = [ChartDataEntry]()
        for (index, model) in datas.enumerated() {
            if !model.emaLine1.isNaN {
                let entry1 = ChartDataEntry(x: Double(index), y: model.emaLine1)
                line1Values.append(entry1)
            }
            if !model.emaLine2.isNaN {
                let entry2 = ChartDataEntry(x: Double(index), y: model.emaLine2)
                line2Values.append(entry2)
            }
        }
        let set1 = LineChartDataSet(values: line1Values, label: "ema line1")
        setupLineChartDataSet(set: set1, color: KLineConst.kEMALine1Color)
        let set2 = LineChartDataSet(values: line2Values, label: "ema line2")
        setupLineChartDataSet(set: set2, color: KLineConst.kEMALine2Color)
        return [set1,set2]
    }
    
    /// 获取BOLL线
    public func getBOLLLineDataSet(datas:[KLineModel]) -> [LineChartDataSet]? {
        guard datas.count > 0 else {
            return nil
        }
        var bollValues = [ChartDataEntry]()
        var ubValues = [ChartDataEntry]()
        var lbValues = [ChartDataEntry]()
        for (index, model) in datas.enumerated() {
            if !model.boll.isNaN {
                let bollEntry = ChartDataEntry(x: Double(index), y: model.boll)
                bollValues.append(bollEntry)
            }
            if !model.ub.isNaN {
                let ubEntry = ChartDataEntry(x: Double(index), y: model.ub)
                ubValues.append(ubEntry)
            }
            if !model.lb.isNaN {
                let lbEntry = ChartDataEntry(x: Double(index), y: model.lb)
                lbValues.append(lbEntry)
            }
        }
        let bollSet = LineChartDataSet(values: bollValues, label: "boll line")
        setupLineChartDataSet(set: bollSet, color: KLineConst.kBOLLLineColor)
        let ubSet = LineChartDataSet(values: ubValues, label: "ub line")
        setupLineChartDataSet(set: ubSet, color: KLineConst.kBOLLLineColor)
        let lbSet = LineChartDataSet(values: lbValues, label: "lb line")
        setupLineChartDataSet(set: lbSet, color: KLineConst.kBOLLLineColor)
        return [bollSet,ubSet,lbSet]
    }
    
    /// 获取MACD线数据
    public func getMACDLineData(datas:[KLineModel]) -> LineChartData? {
        guard datas.count > 0 else {
            return nil
        }
        var difValues = [ChartDataEntry]()
        var deaValues = [ChartDataEntry]()
        for (index, model) in datas.enumerated() {
            if !model.boll.isNaN {
                let difEntry = ChartDataEntry(x: Double(index), y: model.dif)
                difValues.append(difEntry)
            }
            if !model.ub.isNaN {
                let deaEntry = ChartDataEntry(x: Double(index), y: model.dea)
                deaValues.append(deaEntry)
            }
        }
        let difSet = LineChartDataSet(values: difValues, label: "macd dif line")
        setupLineChartDataSet(set: difSet, color: KLineConst.kMACDDifLineColor)
        let deaSet = LineChartDataSet(values: deaValues, label: "macd dea line")
        setupLineChartDataSet(set: deaSet, color: KLineConst.kMACDDeaLineColor)
        
        let data = LineChartData(dataSets: [difSet,deaSet])
        return data
    }
    
    /// 获取MACD柱状图数据
    public func getMACDBarData(datas:[KLineModel]) -> BarChartData? {
        guard datas.count > 0 else {
            return nil
        }
        var yValues = [BarChartDataEntry]()
        var xColors = [UIColor]()
        for i in 0 ..< datas.count {
            let model = datas[i]
            let entry = BarChartDataEntry(x: Double(i), y: model.bar)
            yValues.append(entry)
            if  model.bar >= 0 {
                xColors.append(KLineConst.kCandleGreenColor)
            }else{
                xColors.append(KLineConst.kCandleRedColor)
            }
        }
        let set = BarChartDataSet(values: yValues, label: "macd bar")
        setupBarChartDataSet(set:set)
        set.colors = xColors
        let data = BarChartData(dataSet: set)
        data.barWidth = 0.9
        return data
    }
    
    /// 获取KDJ线数据
    public func getKDJLineData(datas:[KLineModel]) -> LineChartData? {
        guard datas.count > 0 else {
            return nil
        }
        var kValues = [ChartDataEntry]()
        var dValues = [ChartDataEntry]()
        var jValues = [ChartDataEntry]()
        for i in 0 ..< datas.count {
            let model = datas[i]
            if !model.k.isNaN {
                let kEntry = ChartDataEntry(x: Double(i), y: model.k)
                kValues.append(kEntry)
            }
            if !model.d.isNaN {
                let dEntry = ChartDataEntry(x: Double(i), y: model.d)
                dValues.append(dEntry)
            }
            if !model.j.isNaN {
                let jEntry = ChartDataEntry(x: Double(i), y: model.j)
                jValues.append(jEntry)
            }
        }
        let kSet = LineChartDataSet(values: kValues, label: "k line")
        let dSet = LineChartDataSet(values: dValues, label: "d line")
        let jSet = LineChartDataSet(values: jValues, label: "j line")
        setupLineChartDataSet(set: kSet, color: KLineConst.kKDJKLineColor)
        setupLineChartDataSet(set: dSet, color: KLineConst.kKDJDLineColor)
        setupLineChartDataSet(set: jSet, color: KLineConst.kKDJJLineColor)
        let data = LineChartData(dataSets: [kSet,dSet,jSet])
        return data
    }
    
    /// 获取RSI线数据
    public func getKRSILineData(datas:[KLineModel]) -> LineChartData?{
        guard datas.count > 0 else {
            return nil
        }
        var line1Values = [ChartDataEntry]()
        var line2Values = [ChartDataEntry]()
        var line3Values = [ChartDataEntry]()
        for i in 0 ..< datas.count {
            let model = datas[i]
            if !model.rsiLine1.isNaN {
                let entry = ChartDataEntry(x: Double(i), y: model.rsiLine1)
                line1Values.append(entry)
            }
            if !model.rsiLine2.isNaN {
                let entry = ChartDataEntry(x: Double(i), y: model.rsiLine2)
                line2Values.append(entry)
            }
            if !model.rsiLine3.isNaN {
                let entry = ChartDataEntry(x: Double(i), y: model.rsiLine3)
                line3Values.append(entry)
            }
        }
        let line1Set = LineChartDataSet(values: line1Values, label: "rsi line1")
        let line2Set = LineChartDataSet(values: line2Values, label: "rsi line2")
        let line3Set = LineChartDataSet(values: line3Values, label: "rsi line3")
        setupLineChartDataSet(set: line1Set, color: KLineConst.kRSILine1Color)
        setupLineChartDataSet(set: line2Set, color: KLineConst.kRSILine2Color)
        setupLineChartDataSet(set: line3Set, color: KLineConst.kRSILine3Color)
        let data = LineChartData(dataSets: [line1Set,line2Set,line3Set])
        return data
    }
}

//MARK: - private
extension KLineBaseView {
    
    /// 折线数据集属性设置
    private func setupLineChartDataSet(set:LineChartDataSet, color:UIColor){
        //是否绘制y图标（未知）
        set.drawIconsEnabled = false
        //折线颜色
        //set1.setColor(UIColor.red)
        set.colors = [color]
        //折线点的颜色
        //set1.setCircleColor(UIColor.yellow)
        set.circleColors = [color]
        //折线的宽度
        set.lineWidth = 0.5
        //折线点的宽度
        set.circleRadius = 0.5
        //折线点的字体的大小
        //set1.valueFont = UIFont.systemFont(ofSize: 16)
        //是否绘制折线点值
        set.drawValuesEnabled = false
        //是否绘制折线点
        set.drawCirclesEnabled = false
        //不使用高亮
        set.highlightEnabled = false
    }
    
    /// 蜡烛图数据集属性设置
    private func setupCandleChartDataSet(_ set:CandleChartDataSet){
        set.drawValuesEnabled = false
        set.axisDependency = .left
        set.valueTextColor = .white
        set.valueFont = UIFont.boldSystemFont(ofSize: 10)
        set.setColor(UIColor(white: 80/255, alpha: 1))
        set.drawIconsEnabled = false
//        set.shadowColor = .darkGray
        set.shadowWidth = 0.7
//        set.decreasingColor = .red
        set.decreasingColor = KLineConst.kCandleRedColor
        set.decreasingFilled = true
//        set.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set.increasingColor = KLineConst.kCandleGreenColor
        set.increasingFilled = true
        set.neutralColor = KLineConst.kCandleGreenColor
        set.highlightEnabled = false
        set.shadowColorSameAsCandle = true
    }
    
    /// 柱状图数据集属性设置
    private func setupBarChartDataSet(set:BarChartDataSet){
        set.drawValuesEnabled = false
        set.highlightEnabled = false
    }
    
    /// 组合图属性设置
    private func setupChart(_ chartView:CombinedChartView){
        //画板颜色
        chartView.gridBackgroundColor = KLineConst.kLineBgColor
        chartView.drawGridBackgroundEnabled = true
        //边框颜色
        chartView.borderColor = UIColor(hexString: "#DAD8DA")
        chartView.drawBordersEnabled = false
        chartView.borderLineWidth = DefaultConst.kPixelSize
        
        /// 属性设置
        //(垂直方向拖拽)
        chartView.scaleYEnabled = false
        //图表描述
        chartView.chartDescription?.enabled = false
        
        //(是否支持x、y方向同时缩放)
        chartView.pinchZoomEnabled = false
        //(数字展示的最大蜡烛个数)
        //chartView.maxVisibleCount = 0
        
        //图例 （不使用图例）
        chartView.legend.enabled = false
        
        //空数据
        chartView.noDataText = ""
        
        //双击缩放（关闭）
        chartView.doubleTapToZoomEnabled = false
        
        /// x轴
        //轴向
        chartView.xAxis.labelPosition = .bottom
        //是否绘制x轴坐标点
        //chartView.xAxis.drawLabelsEnabled = false
        //坐标轴上最多显示多少个坐标点
        chartView.xAxis.labelCount = 4
        //是否绘制网格线（不绘制）
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        
        /// 左轴
        //是否绘制网格线（不绘制）
        chartView.leftAxis.drawGridLinesEnabled = false
        //是否绘制坐标点（不绘制）
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        
        /// 右轴
        //是否绘制网格线（不绘制）
        chartView.rightAxis.drawGridLinesEnabled = false
        //是否绘制坐标点（不绘制）
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        
        //y轴自动缩放开启
        chartView.autoScaleMinMaxEnabled = true
        
        //绘制图表顺序
        let drawOrder = [CombinedChartView.DrawOrder.candle.rawValue,
                         CombinedChartView.DrawOrder.bar.rawValue,
                         CombinedChartView.DrawOrder.line.rawValue,
                         CombinedChartView.DrawOrder.bubble.rawValue,
                         CombinedChartView.DrawOrder.scatter.rawValue]
        chartView.drawOrder = drawOrder
        
        //显示完整的蜡烛图(不被左右轴截去)
        chartView.xAxis.spaceMin = 0.5
        chartView.xAxis.spaceMax = 0.5
        
        //x轴坐标值显示
        chartView.xAxis.labelTextColor = UIColor.white
        
        //手势
        chartView.highlightPerTapEnabled = false
        
        // 关闭拖手势
        chartView.highlightPerDragEnabled = false
        
        // 边距值
        chartView.minOffset = 0.0
    }
}
