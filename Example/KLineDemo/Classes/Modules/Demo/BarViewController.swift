//
//  BarViewController.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Charts

//柱状图
class BarViewController: UIViewController {

    private lazy var chartView:BarChartView = {
        let chartView = BarChartView()
        return chartView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ColorConst.kLineBgColor
        self.title = "柱状图"
        
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
        let start = 1
        
        let yVals = (start..<start+10+1).map { (i) -> BarChartDataEntry in
            let mult:UInt32 = 10 + 1
            let val = Double(arc4random_uniform(mult))
            if arc4random_uniform(100) < 25 {
                return BarChartDataEntry(x: Double(i), y: val, icon: nil)
            } else {
                return BarChartDataEntry(x: Double(i), y: val)
            }
        }
        
        var set1: BarChartDataSet! = nil
        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
            set1 = set
            set1.values = yVals
            chartView.data?.notifyDataChanged()
            chartView.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(values: yVals, label: "The year 2017")
            set1.colors = ChartColorTemplates.material()
            set1.drawValuesEnabled = false
            
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.9
            chartView.data = data
        }
    }
}
