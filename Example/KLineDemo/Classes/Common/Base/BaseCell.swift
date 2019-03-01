//
//  BaseCell.swift
//  ejufu
//
//  Created by Kevin on 2017/12/6.
//  Copyright © 2017年 qsjr. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

    var indexPath:IndexPath!
    var viewModel:Any?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        makeUI()
        makeConstraint()
        makeEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //创建UI 子类需override
    func makeUI(){
    }
    
    //创建约束 子类需override
    func makeConstraint(){
    }
    
    //创建事件 子类需override
    func makeEvent() {
    }
    
    //刷新UI 子类需override
    func refreshUI(viewModel:Any?) {
    }

    //创建cell
    static func createCell(tableView:UITableView, indexPath:IndexPath, viewModel:Any? = nil) -> UITableViewCell{
        tableView.register(self, forCellReuseIdentifier: "\(self.className)")
        let cell:BaseCell = tableView.dequeueReusableCell(withIdentifier: "\(self.className)", for: indexPath) as! BaseCell
        cell.indexPath = indexPath
        cell.viewModel = viewModel
        cell.refreshUI(viewModel: viewModel)
        return cell
    }
}
