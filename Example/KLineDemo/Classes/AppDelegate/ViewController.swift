//
//  ViewController.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/14.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Charts
import SnapKit

class ViewController: UIViewController {

    private lazy var tableView:UITableView = {
        let tableView = UITableView.create(frame: CGRect(), style: .grouped, edgeTop: 0, edgeBottom: 0)
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var dataSource:[String] = {
        var dataSource = [String]()
        dataSource.append("折线图(阴影)")
        dataSource.append("折线图")
        dataSource.append("蜡烛图")
        dataSource.append("柱状图")
        dataSource.append("组合图")
        dataSource.append("两个组合图联动")
        dataSource.append("KLine")
        return dataSource
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Root"
        self.view.backgroundColor = ColorConst.kLineBgColor
        
        makeUI()
        makeConstraint()
        
    }
    
    private func makeUI(){
        
        self.view.addSubview(tableView)
        
    }
    
    private func makeConstraint(){
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func createData(){
        
        
    }
    
    private func refreshUI(){
        
    }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .landscapeRight
//    }
    
}

extension ViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(LineChartViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(Line2ChartViewController(), animated: true)
        case 2:
            self.navigationController?.pushViewController(CandleStickViewController(), animated: true)
        case 3:
            self.navigationController?.pushViewController(BarViewController(), animated: true)
        case 4:
            self.navigationController?.pushViewController(CombinedViewController(), animated: true)
        case 5:
            self.navigationController?.pushViewController(Combined2ViewController(), animated: true)
        case 6:
            self.navigationController?.pushViewController(KLineViewController(), animated: true);
        default:
            break
        }
    }
    
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return ViewControllerCell.createCell(tableView: tableView, indexPath: indexPath, viewModel: dataSource[indexPath.row])
    }
    
}

