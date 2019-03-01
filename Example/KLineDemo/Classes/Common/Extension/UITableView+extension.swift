//
//  UITableView+extension.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    //创建tableview
    static func create(frame:CGRect, style:UITableView.Style, edgeTop:CGFloat, edgeBottom:CGFloat) -> UITableView {
        let tableView = UITableView.init(frame: frame, style: style)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        tableView.contentInset = UIEdgeInsets(top: edgeTop, left: 0, bottom: edgeBottom, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: edgeTop, left: 0, bottom: edgeBottom, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }
}
