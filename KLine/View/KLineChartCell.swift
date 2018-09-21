//
//  KLineChartCell.swift
//  Coinx
//
//  Created by Kevin on 2018/5/3.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

class KLineChartCell: BaseCell {

    private lazy var timeLabel:UILabel = {
        let timeLabel = UILabel.create(text: nil, font: FontConst.PingFangSCRegular(size: 13), color: UIColor(hexString: "#8E9AB5"))
        return timeLabel
    }()
    
    private lazy var volumeLabel:UILabel = {
        let volumeLabel = UILabel.create(text: nil, font: FontConst.DINAlternateBold(size: 13), color: UIColor(hexString: "#8E9AB5"))
        return volumeLabel
    }()
    
    private lazy var priceLabel:UILabel = {
        let priceLabel = UILabel.create(text: nil, font: FontConst.DINAlternateBold(size: 15), color: UIColor(hexString: "#F2334F"))
        return priceLabel
    }()
    
    private lazy var bottomLineView:UIView = {
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor(hexString: "#0D111B")
        return bottomLineView
    }()
    
    /// 创建UI
    override func makeUI() {
        self.contentView.addSubviews([timeLabel,volumeLabel,priceLabel,bottomLineView])
    }
    
    /// 创建约束
    override func makeConstraint() {
        timeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.width.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.centerX.equalTo(DefaultConst.kScreenWidth/6)
        }
        volumeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.width.lessThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
        priceLabel.snp.makeConstraints { (make) in
            make.height.equalTo(18)
            make.width.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.centerX.equalTo(DefaultConst.kScreenWidth/6*5)
        }
        bottomLineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    /// 刷新UI
    override func refreshUI(viewModel: Any?) {
        
        guard viewModel is TradesModel else {
            return
        }
        let model = viewModel as! TradesModel
        if let date = model.date {
            timeLabel.text = UtilDate.toString(formatter: "HH:mm:ss", timeIntervalSince1970: date)
        }
        volumeLabel.text = model.amount
        priceLabel.text = model.price
        
        if let type = model.type , type == "sell" {
            priceLabel.textColor = KLineConst.kCandleRedColor
        }else{
            priceLabel.textColor = KLineConst.kCandleGreenColor
        }
    }
}
