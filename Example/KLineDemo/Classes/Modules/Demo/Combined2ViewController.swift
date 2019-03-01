//
//  Combined2ViewController.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/19.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Charts

//两个组合图联动
class Combined2ViewController: UIViewController {

    private lazy var chartView:CombinedChartView = {
        let chartView = CombinedChartView()
        chartView.delegate = self
        return chartView
    }()
    private lazy var chart2View:CombinedChartView = {
        let chart2View = CombinedChartView()
        chart2View.delegate = self
        return chart2View
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ColorConst.kLineBgColor
        self.title = "组合图"
        
        makeUI()
        makeConstraint()
        settingChartViewUI(chartView: chartView)
        settingChartViewUI(chartView: chart2View)
        settingChartViewData()
    }
    
    private func makeUI(){
        
        self.view.addSubviews([chartView,chart2View])
    }
    
    private func makeConstraint(){
        chartView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY).offset(-5)
        }
        chart2View.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.centerY).offset(5)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    private func settingChartViewUI(chartView:CombinedChartView){
        /// 颜色
        //画板颜色
        chartView.gridBackgroundColor = ColorConst.kLineBgColor
        chartView.drawGridBackgroundEnabled = true
        //边框颜色
        chartView.borderColor = .red
        chartView.drawBordersEnabled = true
        chartView.borderLineWidth = 2
        
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
        chartView.noDataText = "没有数据"
        
        //双击缩放（关闭）
        chartView.doubleTapToZoomEnabled = false
        
        /// x轴
        //轴向
        chartView.xAxis.labelPosition = .bottom
        //是否绘制x轴坐标点
        //chartView.xAxis.drawLabelsEnabled = false
        //坐标轴上最多显示多少个坐标点
        chartView.xAxis.labelCount = 5
        //是否绘制网格线（不绘制）
        chartView.xAxis.drawGridLinesEnabled = false
        
        /// 左轴
        //是否绘制网格线（不绘制）
        chartView.leftAxis.drawGridLinesEnabled = false
        //是否绘制坐标点（不绘制）
        chartView.leftAxis.drawLabelsEnabled = false
        
        /// 右轴
        //是否绘制网格线（不绘制）
        chartView.rightAxis.drawGridLinesEnabled = false
        //是否绘制坐标点（不绘制）
        chartView.rightAxis.drawLabelsEnabled = false
        
        //MARK:- 缩放最大最小值??
        chartView.autoScaleMinMaxEnabled = true
    }
    
    private func settingChartViewData(){
        
        
        let data = CombinedChartData()
//        data.lineData = setupLineData()
        data.candleData = setupCandleStickData()
        
//        if let ddata = setupCandleStickForSampleData() {
//            data.candleData = ddata
//        }
        
        data.candleData = generateCandleData()
        
        chartView.data = data
        chart2View.data = data
        
        
    }
    
    func generateCandleData() -> CandleChartData {
        let entries = stride(from: 0, to: 12, by: 2).map { (i) -> CandleChartDataEntry in
            return CandleChartDataEntry(x: Double(i+1), shadowH: 90, shadowL: 70, open: 85, close: 75)
        }
        
        let set = CandleChartDataSet(values: entries, label: "Candle DataSet")
        set.setColor(UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1))
        set.decreasingColor = UIColor(red: 142/255, green: 150/255, blue: 175/255, alpha: 1)
        set.shadowColor = .darkGray
        set.valueFont = .systemFont(ofSize: 10)
        set.drawValuesEnabled = false
        
        return CandleChartData(dataSet: set)
    }
    
    /// 设置蜡烛图示例数据
    private func setupCandleStickForSampleData() -> CandleChartData?{
        
        guard let jsonData = UtilSampleData.getKLineForDay() else {
            return nil
        }
        let sampleData = KLineSampleDataResponse(JSON: jsonData)
        guard let models = sampleData?.chartlist else {
            return nil
        }
        
        var yValues = [CandleChartDataEntry]()
        for i in (0..<models.count) {
            let model = models[i]
            let h = model.high ?? 0.0
            let l = model.low ?? 0.0
            let open = model.open ?? 0.0
            let close = model.close ?? 0.0
            let entry = CandleChartDataEntry(x: Double(i), shadowH: h, shadowL: l, open: open, close: close)
            yValues.append(entry)
        }
        
        let set1 = CandleChartDataSet(values: yValues, label: "Data Set")
        set1.drawValuesEnabled = false
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        set1.neutralColor = .blue
        
        let data = CandleChartData(dataSet: set1)
        return data
    }
    
    //设置设置线数据
    private func setupLineData() -> LineChartData{
        let values = (0..<10).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(30)+3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: "line1")
        
        let gradientColors = [ChartColorTemplates.colorFromString("#5C96EC").cgColor,
                              ChartColorTemplates.colorFromString("#2A2B34").cgColor]
        
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        let data = LineChartData(dataSets: [set1])
        return data
    }
    //设置蜡烛线数据
    private func setupCandleStickData() -> CandleChartData{
        
        let yVals1 = (0..<10).map { (i) -> CandleChartDataEntry in
            let mult:UInt32 = 10 + 1
            let val = Double(arc4random_uniform(40) + mult)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
            let open = Double(arc4random_uniform(6) + 1)
            let close = Double(arc4random_uniform(6) + 1)
            let even = i % 2 == 0
            
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: nil)
        }
        
        let set1 = CandleChartDataSet(values: yVals1, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        set1.neutralColor = .blue
        
        let data = CandleChartData(dataSet: set1)
        return data
    }
    //设置柱状图数据
    private func setupBarData(){
        
        
    }
}

extension Combined2ViewController : ChartViewDelegate {
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
        let srcMatrix = chartView.viewPortHandler.touchMatrix
        
        if chartView != self.chartView{
            self.chartView.viewPortHandler.refresh(newMatrix: srcMatrix, chart: self.chartView, invalidate: true)
        }
     
        if chartView != self.chart2View {
            self.chart2View.viewPortHandler.refresh(newMatrix: srcMatrix, chart: self.chart2View, invalidate: true)
        }
    }
    
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
        let srcMatrix = chartView.viewPortHandler.touchMatrix
        
        if chartView != self.chartView{
            self.chartView.viewPortHandler.refresh(newMatrix: srcMatrix, chart: self.chartView, invalidate: true)
        }
        
        if chartView != self.chart2View {
            self.chart2View.viewPortHandler.refresh(newMatrix: srcMatrix, chart: self.chart2View, invalidate: true)
        }
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        
        
    }

}
