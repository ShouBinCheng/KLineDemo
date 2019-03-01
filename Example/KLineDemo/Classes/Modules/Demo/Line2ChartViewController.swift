//
//  Line2ChartViewController.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Charts

//折线图
class Line2ChartViewController: UIViewController {

    private lazy var chartView:LineChartView = {
        let chartView = LineChartView()
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorConst.kLineBgColor
        self.title = "折线图"
        
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
            make.edges.equalToSuperview()
        }
    }
    
    private func settingChartViewUI(){
        
        
    }
    
    private func settingChartViewData(){
        
        let values = (0..<10).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(30)+3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: values, label: "line2")
        
        
        let data = LineChartData(dataSets: [set1])
        chartView.data = data
    }

}
