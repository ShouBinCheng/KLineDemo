//
//  KLineDepthView.swift
//  Coinx
//
//  Created by Kevin on 2018/5/7.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

protocol KLineDepthViewDataSource : NSObjectProtocol {
    /// 获取买盘模型
    func kLineDepthViewForBuyData(_ kLineDepthView:KLineDepthView) -> [KLineDepthModel]
    
    /// 获取卖盘模型
    func kLineDepthViewForSellData(_ kLineDepthView:KLineDepthView) -> [KLineDepthModel]
}

/// 深度图
class KLineDepthView: BaseView {

    /// 代理
    weak var delegate:KLineDepthViewDataSource?
    
    /// 折线图
    private lazy var lineChartView:LineChartView = {
        let lineChartView = LineChartView()
        lineChartView.delegate = self
        lineChartView.xAxis.valueFormatter = self
        lineChartView.leftAxis.valueFormatter = self
        setupChartView(lineChartView)
        return lineChartView
    }()
    
    /// 长按信息图
    private lazy var infoView:KLineDepthInfoView = {
        let infoView = KLineDepthInfoView()
        infoView.isHidden = true
        return infoView
    }()
    
    /// 买盘数据源
    private lazy var buyDataSource:[KLineDepthModel] = {
        let buyDataSource = [KLineDepthModel]()
        return buyDataSource
    }()
    
    /// 卖盘数据源
    private lazy var sellDataSource:[KLineDepthModel] = {
        let sellDataSource = [KLineDepthModel]()
        return sellDataSource
    }()
    
    /// 总数据
    private lazy var allDataSource:[KLineDepthModel] = {
        let allDataSource = [KLineDepthModel]()
        return allDataSource
    }()
    
    override func makeUI() {
        self.addSubviews([lineChartView,infoView])
    }
    
    override func makeConstraint() {
        lineChartView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        infoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    override func makeGesture() {
        let topLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureAction(_:)))
        lineChartView.addGestureRecognizer(topLongPress)
    }
    
    public func reloadData(){
        if let buyData = self.delegate?.kLineDepthViewForBuyData(self) {
            buyDataSource = buyData
        }
        if let sellData = self.delegate?.kLineDepthViewForSellData(self) {
            sellDataSource = sellData
        }
        
        lineChartView.data = getLineChartData()
        
        lineChartView.notifyDataSetChanged()
    }
}

extension KLineDepthView {
     
    /// 长按手势处理
    @objc private func handleLongPressGestureAction(_ recognizer: UILongPressGestureRecognizer){
        
        if recognizer.state == .began || recognizer.state == .changed
        {
            let h = lineChartView.getHighlightByTouchPoint(recognizer.location(in: self))
            lineChartView.highlightValue(h, callDelegate: true)
        }else{
            lineChartView.lastHighlighted = nil
            lineChartView.highlightValue(nil, callDelegate: true)
        }
    }
    
    private func getLineChartData() -> LineChartData? {
        if buyDataSource.count <= 0 && sellDataSource.count <= 0 {
            return nil
        }
        // 所有数据
        var allData = [KLineDepthModel]()
        let maxCount = buyDataSource.count > sellDataSource.count ? buyDataSource.count : sellDataSource.count
        // 合并数据
        if buyDataSource.count >= sellDataSource.count {
            allData += buyDataSource
            if let buyLastModel = buyDataSource.last, let sellFirstModel = sellDataSource.first {
                if buyLastModel.price != sellFirstModel.price {
                    allData.append(KLineDepthModel())
                }
            }
            allData += sellDataSource
            for _ in 0 ..< buyDataSource.count - sellDataSource.count {
                allData.append(KLineDepthModel())
            }
        }else{
            for _ in 0 ..< sellDataSource.count - buyDataSource.count {
                allData.append(KLineDepthModel())
            }
            allData += buyDataSource
            if let buyLastModel = buyDataSource.last, let sellFirstModel = sellDataSource.first {
                if buyLastModel.price != sellFirstModel.price {
                    allData.append(KLineDepthModel())
                }
            }
            allData += sellDataSource
        }
        allDataSource = allData
        // 点集计算
        var buyValues = [ChartDataEntry]()
        var sellValues = [ChartDataEntry]()
        var hideValues  = [ChartDataEntry]() //隐藏线
        for (index,model) in allData.enumerated() {
            if !model.volume.isNaN {
                let entry = ChartDataEntry(x: Double(index), y: model.volume)
                if index < maxCount {
                    buyValues.append(entry)
                }else{
                    sellValues.append(entry)
                }
                hideValues.append(entry)
            }
            else{
                let entry = ChartDataEntry(x: Double(index), y: 0.0)
                hideValues.append(entry)
            }
        }
        let buySet = LineChartDataSet(values: buyValues, label: "买")
        setupLineChartDataSet(set: buySet, color: KLineConst.kLineDepthBuyLineColor)
        let sellSet = LineChartDataSet(values: sellValues, label: "卖")
        setupLineChartDataSet(set: sellSet, color: KLineConst.kLineDepthSellLineColor)
        let hideSet = LineChartDataSet(values: hideValues, label: "")
        setupLineChartDataSet(set: hideSet, color: .clear)
        hideSet.highlightEnabled = false
        let data = LineChartData(dataSets: [buySet,sellSet,hideSet])
        return data
    }
    
    private func setupChartView(_ chartView:LineChartView){
        //画板颜色
        chartView.gridBackgroundColor = KLineConst.kLineBgColor
        chartView.drawGridBackgroundEnabled = true
        //边框颜色
//        chartView.borderColor = UIColor(hexString: "#DAD8DA")
        chartView.drawBordersEnabled = false
//        chartView.borderLineWidth = DefaultConst.kPixelSize
        
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
        chartView.legend.enabled = true
        chartView.legend.textColor = UIColor(hexString: "#7B818D")
        chartView.legend.font = UIFont.boldSystemFont(ofSize: 13)
        chartView.legend.verticalAlignment = .center
        chartView.legend.horizontalAlignment = .right
        chartView.legend.yOffset = -350
        chartView.legend.xOffset = -5
        chartView.legend.formSize = 13
        
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
        chartView.xAxis.labelCount = 3
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false

        //是否绘制网格线（不绘制）
//        chartView.xAxis.drawGridLinesEnabled = false
        
        /// 左轴
        //是否绘制网格线（不绘制）
//        chartView.leftAxis.drawGridLinesEnabled = false
        //是否绘制坐标点（不绘制）
        chartView.leftAxis.labelPosition = .insideChart
        chartView.leftAxis.labelTextColor = .white
        chartView.leftAxis.gridLineDashLengths = [3,3]
        chartView.leftAxis.drawAxisLineEnabled = false
        
        /// 右轴
        //是否绘制网格线（不绘制）
        chartView.rightAxis.drawGridLinesEnabled = false
        //是否绘制坐标点（不绘制）
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        
        //y轴自动缩放开启
        chartView.autoScaleMinMaxEnabled = false
        
        
        //选中时绘制的标记视图
        //        chartView.drawMarkers = true
        //        let markerView = MarkerView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //        markerView.backgroundColor = UIColor.red
        //        markerView.offset = CGPoint(x: -50, y: -50)
        //        chartView.marker = markerView
        
        //显示完整的蜡烛图(不被左右轴截去)
//        chartView.xAxis.spaceMin = 0.5
//        chartView.xAxis.spaceMax = 0.5
        
        //x轴坐标值显示
        //        chartView.xAxis.valueFormatter = self
        chartView.xAxis.labelTextColor = UIColor.white
        
        
        //缩放最大最小值
        //        chartView.viewPortHandler.setMinimumScaleX(2)
        //        chartView.viewPortHandler.setMaximumScaleX(3)
        //缩放的最大值最小值设置，（需要设置数据后再设置）
        //chartView.setVisibleXRange(minXRange: 20, maxXRange: 100)
        
        //手势
        chartView.highlightPerTapEnabled = false
        
        // 关闭拖手势
        chartView.highlightPerDragEnabled = false
        
        // 边距值
        chartView.minOffset = 0.0
        
        chartView.scaleXEnabled = false
    }
    
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
        set.circleRadius = 1
        //折线点的字体的大小
        //set1.valueFont = UIFont.systemFont(ofSize: 16)
        //是否绘制折线点值
        set.drawValuesEnabled = false
        //是否绘制折线点
        set.drawCirclesEnabled = false
        //不使用高亮
//        set.highlightEnabled = false
        
//        let gradientColors = [ChartColorTemplates.colorFromString("#5C96EC").cgColor,
//                              ChartColorTemplates.colorFromString("#2A2B34").cgColor]
        let gradientColors = [color.cgColor,
                              color.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        set.fillAlpha = 0.1
        set.fill = Fill(linearGradient: gradient, angle: 90)
        set.drawFilledEnabled = true
    }
}

extension KLineDepthView : IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if axis == lineChartView.xAxis {
            let model = allDataSource[Int(value)]
            if model.price.isNaN {
                return ""
            }else{
                if !(value == 0 || value == Double(allDataSource.count-1)) {
                    return model.price.toString(maxLongCount: 9)
                }
            }
        }
        if axis == lineChartView.leftAxis {
            if value > 0 {
                return value.toString(maxLongCount: 9)
            }else{
                return ""
            }
        }
        return ""
    }
}

extension KLineDepthView : ChartViewDelegate {
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        infoView.isHidden = true
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let index = Int(highlight.x)
        if index >= 0 && index < allDataSource.count {
            let model = allDataSource[index]
            let viewModel = KLineDepthInfoViewModel()
            viewModel.model = model
            viewModel.highlight = highlight
            infoView.refreshUI(viewModel: viewModel)
        }
    }
}
