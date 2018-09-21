//
//  KLineFullScreenTopInfoView.swift
//  Coinx
//
//  Created by Kevin on 2018/5/4.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

class KLineFullScreenTopInfoView: BaseView {

    /// 价格
    private lazy var priceLabel:UILabel = {
        
        let priceLabel = UILabel.create(text: "------", font: FontConst.DINAlternateBold(size: 20), color: UIColor(hexString: "#F2334F"))
        return priceLabel
    }()
    
    /// 约等于（法钱）
    private lazy var moneyLabel:UILabel = {
        let moneyLabel = UILabel.create(text: "----", font: FontConst.DINAlternateBold(size: 12), color: UIColor(hexString: "#8E9AB5"))
        return moneyLabel
    }()
    
    /// 涨跌幅
    private lazy var percentLabel:UILabel = {
        let percentLabel = UILabel.create(text: "----", font: FontConst.DINAlternateBold(size: 12), color: UIColor(hexString: "#F2334F"))
        return percentLabel
    }()
    
    /// 最高价
    private lazy var highDescrLabel:UILabel = {
        
        let highDescrLabel = UILabel.create(text: "高：".localized, font: FontConst.PingFangSCRegular(size: 10), color: UIColor(hexString: "#8E9AB5"))
        return highDescrLabel
    }()
    private lazy var highLabel:UILabel = {
        let highLabel = UILabel.create(text: "----", font: FontConst.PingFangSCRegular(size: 10), color: UIColor(hexString: "#8E9AB5"))
        return highLabel
    }()
    
    /// 最低价
    private lazy var lowDescrLabel:UILabel = {
        let lowDescrLabel = UILabel.create(text: "低：".localized, font: FontConst.PingFangSCRegular(size: 10), color: UIColor(hexString: "#8E9AB5"))
        return lowDescrLabel
    }()
    private lazy var lowLabel:UILabel = {
        let lowLabel = UILabel.create(text: "----", font: FontConst.PingFangSCRegular(size: 10), color: UIColor(hexString: "#8E9AB5"))
        return lowLabel
    }()
    
    /// 成交量
    private lazy var volumeDescrLabel:UILabel = {
        let volumeDescrLabel = UILabel.create(text: "24H量：".localized, font: FontConst.PingFangSCRegular(size: 10), color: UIColor(hexString: "#8E9AB5"))
        return volumeDescrLabel
    }()
    private lazy var volumeLabel:UILabel = {
        let volumeLabel = UILabel.create(text: "----", font: FontConst.PingFangSCRegular(size: 10), color: UIColor(hexString: "#8E9AB5"))
        return volumeLabel
    }()
    
    /// 关闭
    lazy var closeButton:UIButton = {
        let closeButton = UIButton()
        closeButton.setBackgroundImage(UIImage(named: "kline_button_close_normal"), for: .normal)
        return closeButton
    }()

    override func makeUI() {
        self.addSubviews([priceLabel,moneyLabel,percentLabel,highDescrLabel
            ,highLabel,lowDescrLabel,lowLabel,volumeDescrLabel,volumeLabel
            ,closeButton])
    }
    
    override func makeConstraint() {
        
        priceLabel.snp.makeConstraints { (make) in
            make.height.equalTo(24)
            make.width.lessThanOrEqualToSuperview()
            make.left.equalTo(DefaultConst.kScreenHeight == 812 ? 30 : 15)
            make.centerY.equalToSuperview()
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.lessThanOrEqualToSuperview()
            make.left.equalTo(priceLabel.snp.right).offset(11)
            make.centerY.equalToSuperview()
        }
        
        percentLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.width.lessThanOrEqualToSuperview()
            make.left.equalTo(moneyLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        
        volumeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.width.lessThanOrEqualToSuperview()
            make.right.equalTo(closeButton.snp.left).offset(-15)
            make.centerY.equalToSuperview()
        }
        
        volumeDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.width.lessThanOrEqualToSuperview()
            make.right.equalTo(volumeLabel.snp.left)
            make.centerY.equalToSuperview()
        }
        
        lowLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.width.lessThanOrEqualToSuperview()
            make.right.equalTo(volumeDescrLabel.snp.left).offset(-15)
            make.centerY.equalToSuperview()
        }
        
        lowDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.width.lessThanOrEqualToSuperview()
            make.right.equalTo(lowLabel.snp.left)
            make.centerY.equalToSuperview()
        }
        
        highLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.width.lessThanOrEqualToSuperview()
            make.right.equalTo(lowDescrLabel.snp.left).offset(-15)
            make.centerY.equalToSuperview()
        }
        highDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.width.lessThanOrEqualToSuperview()
            make.right.equalTo(highLabel.snp.left)
            make.centerY.equalToSuperview()
        }
    }
    
    override func refreshUI(viewModel: Any?) {
        guard viewModel is PagesMarketsResponse else {
            return
        }
        let model = viewModel as! PagesMarketsResponse
        
        priceLabel.text = model.ticker_last
        if let cny = model.ticker_last_cny {
            if let cnyString = Double(cny)?.toString2f() {
                moneyLabel.text = "≈￥\(cnyString)"
            }
        }
        if let ratioStr = model.ticker_change_ratio, let ratio = Double(ratioStr) {
            percentLabel.text = "\((ratio*100).toString2f())%"
        }
        if let volume = model.ticker_volume {
            volumeLabel.text = Double(volume)?.toString(maxLongCount: 9)
        }
        if let high = model.ticker_high {
            highLabel.text = Double(high)?.toString(maxLongCount: 9)
        }
        if let low = model.ticker_low {
            lowLabel.text = Double(low)?.toString(maxLongCount: 9)
        }
        
        if let ratio = model.ticker_change_ratio,let ratioD = Double(ratio), ratioD >= 0 {
            priceLabel.textColor = KLineConst.kCandleGreenColor
            percentLabel.textColor = KLineConst.kCandleGreenColor
        }else{
            priceLabel.textColor = KLineConst.kCandleRedColor
            percentLabel.textColor = KLineConst.kCandleRedColor
        }
        
    }
}
