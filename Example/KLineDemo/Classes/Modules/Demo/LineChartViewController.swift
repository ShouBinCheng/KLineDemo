//
//  LineChartViewController.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Charts

//折线图（阴影）
class LineChartViewController: UIViewController {

    private lazy var chartView:LineChartView = {
        let chartView = LineChartView()
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorConst.kLineBgColor
        self.title = "折线图（阴影）"
        
        makeUI()
        makeConstraint()
        settingChartViewUI()
        settingChartViewData()
    }
    
    private func makeUI(){
        
        self.view.addSubview(chartView)
    }
    
    private func makeConstraint(){
        chartView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(60)
        }
    }
    
    private func settingChartViewUI(){
        
        //颜色
        chartView.gridBackgroundColor = .red
        chartView.drawGridBackgroundEnabled = true
        
    }
    
    //设置数据
    private func settingChartViewData(){
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
        chartView.data = data
    }
    
    
}
