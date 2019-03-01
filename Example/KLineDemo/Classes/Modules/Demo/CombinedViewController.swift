//
//  CombinedViewController.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Charts
import RxCocoa

//组合图
class CombinedViewController: UIViewController {

    private lazy var chartView:CombinedChartView = {
        let chartView = CombinedChartView()
        chartView.delegate = self
        return chartView
    }()
    
    private lazy var rightButton:UIButton = {
        let rightButton = UIButton()
        rightButton.setTitle("改变缩放比例", for: .normal)
        rightButton.setTitleColor(UIColor.blue, for: .normal)
        rightButton.sizeToFit()
        return rightButton
    }()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.title = "组合图"
        
        makeUI()
        makeEvent()
        makeConstraint()
        settingChartViewUI()
        settingChartViewData()
    }
    
    private func makeUI(){
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        self.view.addSubview(chartView)
    }
    
    private func makeEvent(){
        
        
        let _ = rightButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { (_) in
        
            self.chartView.viewPortHandler.setMinimumScaleX(5)
            self.chartView.viewPortHandler.setMaximumScaleX(20)
            self.chartView.notifyDataSetChanged()
        })

    }
    
    private func addDate(){
        
        
        
    }
    
    private func makeConstraint(){
        chartView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(60)
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
        
        //绘制图表顺序
        let drawOrder = [CombinedChartView.DrawOrder.candle.rawValue,
                         CombinedChartView.DrawOrder.line.rawValue,
                         CombinedChartView.DrawOrder.bar.rawValue,
                         CombinedChartView.DrawOrder.bubble.rawValue,
                         CombinedChartView.DrawOrder.scatter.rawValue]
        chartView.drawOrder = drawOrder
        
        //显示完整的蜡烛图(不被左右轴截去)
        chartView.xAxis.spaceMin = 0.5
        chartView.xAxis.spaceMax = 0.5
        
        //x轴坐标值显示
        chartView.xAxis.valueFormatter = self
        chartView.xAxis.labelTextColor = .red
        
        //高亮
        chartView.highlightPerTapEnabled = true
        
        //缩放最大最小值
        chartView.viewPortHandler.setMinimumScaleX(2)
        chartView.viewPortHandler.setMaximumScaleX(3)
    }
    
    private func settingChartViewData(){
        
        
        let data = CombinedChartData()
//        data.lineData = setupLineData()
//        data.candleData = setupCandleStickData()
        if let candleDate = setupCandleStickForSampleData() {
            data.candleData = candleDate
        }
        
        if let lineData = setupLineForSampleData() {
            data.lineData = lineData
        }
        
        chartView.data = data
    }
    //设置设置线数据
    private func setupLineData() -> LineChartData{
        //生成坐标点
        let values = (0..<50).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(30)+3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        //点集
        let set1 = LineChartDataSet(values: values, label: "line1")
        //是否绘制y图标（未知）
        set1.drawIconsEnabled = false
        //折线颜色
        //set1.setColor(UIColor.red)
        set1.colors = [UIColor.red]
        //折线点的颜色
        //set1.setCircleColor(UIColor.yellow)
        set1.circleColors = [UIColor.red]
        //折线的宽度
        set1.lineWidth = 2
        //折线点的宽度
        set1.circleRadius = 1
        //折线点的字体的大小
        //set1.valueFont = UIFont.systemFont(ofSize: 16)
        //是否绘制折线点值
        set1.drawValuesEnabled = false
        //填充
        let gradientColors = [ChartColorTemplates.colorFromString("#5C96EC").cgColor,
                              ChartColorTemplates.colorFromString("#2A2B34").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        //是否开启填充
        set1.drawFilledEnabled = true
        
        let data = LineChartData(dataSets: [set1])
        
        return data
        
    }
    //设置蜡烛线数据
    private func setupCandleStickData() -> CandleChartData{
        
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
    //设置柱状图数据
    private func setupBarData(){
        
        
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
        for i in (0..<models.count/2) {
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
    
    /// 设置MD5示例数据
    private func setupLineForSampleData() -> LineChartData? {
        guard let jsonData = UtilSampleData.getKLineForDay() else {
            return nil
        }
        let sampleData = KLineSampleDataResponse(JSON: jsonData)
        guard let models = sampleData?.chartlist else {
            return nil
        }
        var ma5Values = [ChartDataEntry]()
        var ma10Values = [ChartDataEntry]()
        var ma20Values = [ChartDataEntry]()
        var ma30Values = [ChartDataEntry]()
        for i in (0..<models.count/2) {
            let model = models[i]
            let ma5 = model.ma5 ?? 0.0
            let ma10 = model.ma10 ?? 0.0
            let ma20 = model.ma20 ?? 0.0
            let ma30 = model.ma30 ?? 0.0
            let ma5Entry = ChartDataEntry(x: Double(i), y: ma5)
            let ma10Entry = ChartDataEntry(x: Double(i), y: ma10)
            let ma20Entry = ChartDataEntry(x: Double(i), y: ma20)
            let ma30Entry = ChartDataEntry(x: Double(i), y: ma30)
            ma5Values.append(ma5Entry)
            ma10Values.append(ma10Entry)
            ma20Values.append(ma20Entry)
            ma30Values.append(ma30Entry)
        }
        let ma5Set = LineChartDataSet(values: ma5Values, label: "")
        setupLineChartDataSet(set: ma5Set, lineColor: .yellow)
        let ma10Set = LineChartDataSet(values: ma10Values, label: "")
        setupLineChartDataSet(set: ma10Set, lineColor: .red)
        let ma20Set = LineChartDataSet(values: ma20Values, label: "")
        setupLineChartDataSet(set: ma20Set, lineColor: .blue)
        let ma30Set = LineChartDataSet(values: ma30Values, label: "")
        setupLineChartDataSet(set: ma30Set, lineColor: .cyan)
        
        let data = LineChartData(dataSets: [ma5Set,ma10Set,ma20Set,ma30Set])
        return data
    }
    
    private func setupLineChartDataSet(set:LineChartDataSet, lineColor:UIColor) {
        
        //是否绘制y图标（未知）
        set.drawIconsEnabled = false
        //折线颜色
        //set1.setColor(UIColor.red)
        set.colors = [lineColor]
        //折线点的颜色
        //set1.setCircleColor(UIColor.yellow)
        set.circleColors = [lineColor]
        //折线的宽度
        set.lineWidth = 2
        //折线点的宽度
        set.circleRadius = 1
        //折线点的字体的大小
        //set1.valueFont = UIFont.systemFont(ofSize: 16)
        //是否绘制折线点值
        set.drawValuesEnabled = false
        //是否绘制折线点
        set.drawCirclesEnabled = false
        
    }
}

extension CombinedViewController : ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
//        print("chartValueSelected:\n\(chartView.highlighted)\n\(chartView.highlightPerTapEnabled)")
        
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
//        print("chartValueNothingSelected")
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
//        print("chartScaled:\(scaleX)  ,\(scaleY)")
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
//        print("chartTranslated:\(dX)  , \(dY)")
    }
    
}

extension CombinedViewController : IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "2018-4-1"
    }
}
