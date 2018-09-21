//
//  KLineChartHeaderView.swift
//  Coinx
//
//  Created by Kevin on 2018/5/2.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

class KLineChartHeaderView: BaseView {

    /// 背景框
    private lazy var bgView:UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor(hexString: "#1F232D")
        return bgView
    }()
    
    /// 上左右垂直线
    private lazy var vLineViews:(UIView,UIView,UIView) = {
        let vLineViews = [UIView(),UIView(),UIView()]
        for lineView in vLineViews {
            lineView.backgroundColor = UIColor(hexString: "#0D111B")
        }
        return (vLineViews[0],vLineViews[1],vLineViews[2])
    }()
    
    /// 当前价
    private lazy var priceLabel:UILabel = {
        let priceLabel = UILabel.create(text: "------", font: FontConst.DINAlternateBold(size: 30), color: UIColor(hexString: "#F2334F"))
        return priceLabel
    }()
    
    /// 涨跌标记
    private lazy var flagImageView:UIImageView = {
        let flagImageView = UIImageView()
        return flagImageView
    }()
    
    /// 约等于（法钱）
    private lazy var moneyLabel:UILabel = {
        let moneyLabel = UILabel.create(text: "----", font: FontConst.DINAlternateBold(size: 13), color: UIColor(hexString: "#8E9AB5"))
        return moneyLabel
    }()
    
    /// 涨跌幅
    private lazy var percentLabel:UILabel = {
        let percentLabel = UILabel.create(text: "----", font: FontConst.DINAlternateBold(size: 13), color: UIColor(hexString: "#F2334F"))
        return percentLabel
    }()
    
    /// 成交量
    private lazy var volumeDescrLabel:UILabel = {
        let volumeDescrLabel = UILabel.create(text: "24H成交量".localized, font: UIFont.systemFont(ofSize: 12), color: UIColor(hexString: "#8E9AB5"))
        return volumeDescrLabel
    }()
    private lazy var volumeLabel:UILabel = {
        let volumeLabel = UILabel.create(text: "----", font: FontConst.DINAlternateBold(size: 16), color: UIColor(hexString: "#F2F6FC"))
        return volumeLabel
    }()
    
    /// 最高价
    private lazy var highDescrLabel:UILabel = {
        let highDescrLabel = UILabel.create(text: "24H最高价".localized, font: UIFont.systemFont(ofSize: 12), color: UIColor(hexString: "#8E9AB5"))
        return highDescrLabel
    }()
    private lazy var highLabel:UILabel = {
        let highLabel = UILabel.create(text: "----", font: FontConst.DINAlternateBold(size: 16), color: UIColor(hexString: "#F2F6FC"))
        return highLabel
    }()
    
    /// 最低价
    private lazy var lowDescrLabel:UILabel = {
        let lowDescrLabel = UILabel.create(text: "24H最低价".localized, font: UIFont.systemFont(ofSize: 12), color: UIColor(hexString: "#8E9AB5"))
        return lowDescrLabel
    }()
    private lazy var lowLabel:UILabel = {
        let lowLabel = UILabel.create(text: "----", font: FontConst.DINAlternateBold(size: 16), color: UIColor(hexString: "#F2F6FC"))
        return lowLabel
    }()
    
    
    override func makeUI() {
        self.addSubviews([bgView,vLineViews.0,vLineViews.1,vLineViews.2
            ,priceLabel,moneyLabel,percentLabel,volumeDescrLabel
            ,volumeLabel,highDescrLabel,highLabel,lowDescrLabel
            ,lowLabel])
    }
    
    
    override func makeConstraint() {
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(16)
            make.bottom.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(bgView).offset(10)
        }

        vLineViews.0.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(10)
            make.centerX.equalTo(bgView)
            make.top.equalTo(priceLabel.snp.bottom).offset(9)
        }

        vLineViews.1.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(15)
            make.centerX.equalTo((DefaultConst.kScreenWidth-20)/3+10)
            make.bottom.equalTo(-29)
        }

        vLineViews.2.snp.makeConstraints { (make) in
            make.width.equalTo(1)
            make.height.equalTo(15)
            make.centerX.equalTo((DefaultConst.kScreenWidth-20)/3*2+10)
            make.bottom.equalTo(-29)
        }

        moneyLabel.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.width.lessThanOrEqualToSuperview()
            make.centerY.equalTo(vLineViews.0)
            make.right.equalTo(vLineViews.0.snp.left).offset(-10)
        }

        percentLabel.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.width.lessThanOrEqualToSuperview()
            make.centerY.equalTo(vLineViews.0)
            make.left.equalTo(vLineViews.0.snp.right).offset(10)
        }

        volumeDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalTo((DefaultConst.kScreenWidth-20)/6+10)
            make.bottom.equalTo(-42)
        }

        volumeLabel.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalTo(volumeDescrLabel)
            make.top.equalTo(volumeDescrLabel.snp.bottom).offset(5)
        }

        highDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalTo(volumeDescrLabel)
        }

        highLabel.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalTo(highDescrLabel)
            make.top.equalTo(highDescrLabel.snp.bottom).offset(5)
        }

        lowDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalTo((DefaultConst.kScreenWidth-20)/6*5+10)
            make.centerY.equalTo(highDescrLabel)
        }

        lowLabel.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalTo(lowDescrLabel)
            make.top.equalTo(lowDescrLabel.snp.bottom).offset(5)
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

