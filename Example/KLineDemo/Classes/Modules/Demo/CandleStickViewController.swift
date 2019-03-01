//
//  CandleStickViewController.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Charts

//蜡烛图
class CandleStickViewController: UIViewController {

    private lazy var chartView:CandleStickChartView = {
        let chartView = CandleStickChartView()
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorConst.kLineBgColor
        self.title = "蜡烛图"
        
        makeUI()
        makeConstraint()
        settingChartViewUI()
        
        if let data = setupCandleStickForSampleData() {
            chartView.data = data
        }
    }
    
    private func makeUI(){
        
        self.view.addSubview(chartView)
    }
    
    private func makeConstraint(){
        chartView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func settingChartViewUI(){
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
        
        //y轴自动缩放开启
        chartView.autoScaleMinMaxEnabled = true
        
        //选中时绘制的标记视图
//        chartView.drawMarkers = true
//        let markerView = MarkerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//        markerView.backgroundColor = UIColor.red
//        markerView.offset = CGPoint(x: -50, y: -50)
//        chartView.marker = markerView
        
        //渲染
        let renderer = HXCandleStickChartRenderer(dataProvider: chartView, animator: Animator(), viewPortHandler: ViewPortHandler(width: DefaultConst.kScreenWidth, height: DefaultConst.kScreenHeight))
        chartView.renderer = renderer
        
        
        //MARK:- 缩放最大最小值??
        
    }
    
    private func settingChartViewData(){
        
        let yVals1 = (0..<100).map { (i) -> CandleChartDataEntry in
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
        chartView.data = data
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
}

