//
//  KLineInfoView.swift
//  Coinx
//
//  Created by Kevin on 2018/4/27.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit
import Charts

class KLineInfoView: BaseView {

    /// 垂线
    private lazy var vLineView:UIView = {
        let vLineView = UIView()
        vLineView.backgroundColor = KLineConst.kInfoLineColor
        return vLineView
    }()
    
    /// 横线
    private lazy var hLineView:UIView = {
        let hLineView = UIView()
        hLineView.backgroundColor = KLineConst.kInfoLineColor
        return hLineView
    }()
    
    /// x坐标值
    private lazy var xLabel:UILabel = {
        let xLabel = UILabel.create(text: nil, font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#181C26"))
        xLabel.backgroundColor = UIColor(hexString: "#8E9AB5")
        return xLabel
    }()
    
    /// y坐标值
    private lazy var yLabel:UILabel = {
        let yLabel = UILabel.create(text: nil, font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#181C26"))
        yLabel.backgroundColor = UIColor(hexString: "#8E9AB5")
        return yLabel
    }()
    
    /// 顶部背景
    private lazy var topBgView:UIView = {
        let topBgView = UIView()
        topBgView.backgroundColor = UIColor(hexString: "#1F232D").withAlphaComponent(0.9)
//        topBgView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        return topBgView
    }()
    
    /// 开盘价
    private lazy var openDescrLabel:UILabel = {
        let openDescrLabel = UILabel.create(text: "开", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#8E9AB5"))
        return openDescrLabel
    }()
    private lazy var openLabel:UILabel = {
        let openLabel = UILabel.create(text: nil, font: UIFont(name: "DINAlternate-Bold", size: 10), color: KLineConst.kCandleRedColor)
        return openLabel
    }()
    /// 最高价
    private lazy var highDescrLabel:UILabel = {
        let highDescrLabel = UILabel.create(text: "高", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#8E9AB5"))
        return highDescrLabel
    }()
    private lazy var highLabel:UILabel = {
        let highLabel = UILabel.create(text: nil, font: UIFont(name: "DINAlternate-Bold", size: 10), color: KLineConst.kCandleGreenColor)
        return highLabel
    }()
    /// 最低价
    private lazy var lowDescrLabel:UILabel = {
        let lowDescrLabel = UILabel.create(text: "低", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#8E9AB5"))
        return lowDescrLabel
    }()
    private lazy var lowLabel:UILabel = {
        let lowLabel = UILabel.create(text: nil, font: UIFont(name: "DINAlternate-Bold", size: 10), color: KLineConst.kCandleRedColor)
        return lowLabel
    }()
    /// 收盘价
    private lazy var closeDescrLabel:UILabel = {
        let closeDescrLabel = UILabel.create(text: "收", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#8E9AB5"))
        return closeDescrLabel
    }()
    private lazy var closeLabel:UILabel = {
        let closeLabel = UILabel.create(text: nil, font: UIFont(name: "DINAlternate-Bold", size: 10), color: KLineConst.kCandleRedColor)
        return closeLabel
    }()
    /// 涨跌幅
    private lazy var percentDescrLabel:UILabel = {
        let percentDescrLabel = UILabel.create(text: "幅", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#8E9AB5"))
        return percentDescrLabel
    }()
    private lazy var percentLabel:UILabel = {
        let percentLabel = UILabel.create(text: nil, font: UIFont(name: "DINAlternate-Bold", size: 10), color: KLineConst.kCandleRedColor)
        return percentLabel
    }()
    
    /// 成交量
    private lazy var volumeDescrLabel:UILabel = {
        let volumeDescrLabel = UILabel.create(text: "量", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#8E9AB5"))
        return volumeDescrLabel
    }()
    private lazy var volumeLabel:UILabel = {
        let volumeLabel = UILabel.create(text: nil, font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#8E9AB5"))
        return volumeLabel
    }()
    /// 日期
    private lazy var dateLabel:UILabel = {
        let dateLabel = UILabel.create(text: nil, font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#8E9AB5"))
        return dateLabel
    }()
    
    /// 上指标详情
    private lazy var topIndexLabels:(UILabel,UILabel,UILabel) = {
        let indexLabel1 = UILabel.create(text: "nil", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#F4F4F6"))
        let indexLabel2 = UILabel.create(text: "nil", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#F4F4F6"))
        let indexLabel3 = UILabel.create(text: "nil", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#F4F4F6"))
        return (indexLabel1,indexLabel2,indexLabel3)
    }()
    
    /// 下指标详情
    private lazy var bottomBoxView:UIView = {
        let bottomBoxView = UIView()
        return bottomBoxView
    }()
    private lazy var bottomIndexLabel:UILabel = {
        let bottomIndexLabel = UILabel.create(text: "nil", font: UIFont(name: "DINAlternate-Bold", size: 10), color: UIColor(hexString: "#F4F4F6"))
        return bottomIndexLabel
    }()
    
    
    
    private lazy var topSubViews:[UIView] = {
        var topSubViews = [UIView]()
        let descriLabels:[UIView] = [openDescrLabel,highDescrLabel,lowDescrLabel,closeDescrLabel,
                                     percentDescrLabel,volumeDescrLabel,dateLabel]
        let labels:[UIView] = [openLabel,highLabel,lowLabel,closeLabel,
                               percentLabel,volumeLabel,UIView()]
        
        for i in 0 ..< descriLabels.count {
            let view = UIView()
            view.addSubviews([descriLabels[i],labels[i]])
            descriLabels[i].snp.makeConstraints { (make) in
                make.width.height.lessThanOrEqualToSuperview()
                make.left.equalTo(10)
                make.centerY.equalToSuperview()
            }
            labels[i].snp.makeConstraints { (make) in
                make.width.height.lessThanOrEqualToSuperview()
                make.left.equalTo(descriLabels[i].snp.right).offset(5)
                make.centerY.equalToSuperview()
            }
            topSubViews.append(view)
        }
        return topSubViews
    }()
    
    override func makeUI(){
        
        self.addSubviews([vLineView,hLineView,xLabel,yLabel
            ,topBgView])
        
        topBgView.addSubviews(topSubViews)
        
        self.addSubviews([topIndexLabels.0,topIndexLabels.1,topIndexLabels.2,bottomBoxView])
        
        bottomBoxView.addSubview(bottomIndexLabel)
    }
    
    override func makeConstraint(){
        
        vLineView.snp.makeConstraints { (make) in
            make.width.equalTo(DefaultConst.kPixelSize)
            make.top.bottom.left.equalToSuperview()
        }
        
        hLineView.snp.makeConstraints { (make) in
            make.height.equalTo(DefaultConst.kPixelSize)
            make.top.left.right.equalToSuperview()
        }
        
        xLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.width.lessThanOrEqualToSuperview()
        }
        
        yLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.width.lessThanOrEqualToSuperview()
        }
        
        topBgView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(self.snp.top)
        }
        
        for (index, subView) in topSubViews.enumerated() {
            subView.snp.makeConstraints { (make) in
                make.height.equalToSuperview().multipliedBy(0.5)
                make.width.equalToSuperview().multipliedBy(0.25)
                make.top.equalTo(index < 4 ? 0 : topSubViews[index-4].snp.bottom)
                make.left.equalTo(index % 4 == 0 ? 0 : topSubViews[index-1].snp.right)
            }
        }
        
        topIndexLabels.0.snp.makeConstraints { (make) in
            make.width.height.lessThanOrEqualToSuperview()
            make.top.left.equalTo(5)
        }
        topIndexLabels.1.snp.makeConstraints { (make) in
            make.width.height.lessThanOrEqualToSuperview()
            make.top.equalTo(5)
            make.left.equalTo(topIndexLabels.0.snp.right).offset(10)
        }
        topIndexLabels.2.snp.makeConstraints { (make) in
            make.width.height.lessThanOrEqualToSuperview()
            make.top.equalTo(5)
            make.left.equalTo(topIndexLabels.1.snp.right).offset(10)
        }
        bottomBoxView.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.25)
        }
        bottomIndexLabel.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(DefaultConst.kScreenWidth)
            make.height.lessThanOrEqualToSuperview()
            make.left.equalTo(5)
            make.top.equalTo(5)
            make.right.equalTo(-1)
        }
    }
    
    override func makeEvent() {
        
    }
    
    override func refreshUI(viewModel:Any?) {
        
        guard viewModel is KLineInfoViewModel else {
            return
        }
        
        let model = viewModel as! KLineInfoViewModel
        
        guard let highlight = model.highlight else {
            return
        }
        guard let kLineModel = model.kLineModel else {
            return
        }
        guard let kIndexTop = model.kIndexTop else {
            return
        }
        guard let kIndexBottom = model.kIndexBottom else {
            return
        }
        guard let kType = model.kType else {
            return
        }
        guard let topHighly = model.topHighly else {
            return
        }
        guard let bottomHighly = model.bottomHighly else {
            return
        }

        xLabel.text = UtilDate.toString(formatter: "yyyy-MM-dd HH:mm", timeIntervalSince1970: Int(kLineModel.timestamp))
        yLabel.text = kLineModel.close.toString(maxLongCount: 9)
        
        openLabel.text = kLineModel.open.toString(maxLongCount: 9)
        highLabel.text = kLineModel.high.toString(maxLongCount: 9)
        lowLabel.text = kLineModel.low.toString(maxLongCount: 9)
        closeLabel.text = kLineModel.close.toString(maxLongCount: 9)
        volumeLabel.text = kLineModel.volume.toString(maxLongCount: 9)
        dateLabel.text = UtilDate.toString(formatter: "yyyy-MM-dd HH:mm", timeIntervalSince1970: Int(kLineModel.timestamp))
        percentLabel.text = "\(((kLineModel.close-kLineModel.open)/kLineModel.open*100).toString2f())%"
        
        if kLineModel.open > kLineModel.close {
            openLabel.textColor = KLineConst.kCandleRedColor
            closeLabel.textColor = KLineConst.kCandleRedColor
            percentLabel.textColor = KLineConst.kCandleRedColor
        }else{
            openLabel.textColor = KLineConst.kCandleGreenColor
            closeLabel.textColor = KLineConst.kCandleGreenColor
            percentLabel.textColor = KLineConst.kCandleGreenColor
        }
        topIndexLabels.0.isHidden = true
        topIndexLabels.1.isHidden = true
        topIndexLabels.2.isHidden = true
        switch kType {
        case .kTimeLine:
            bottomIndexLabel.text = "VOL \(kLineModel.volume.toString(maxLongCount: 7))"
            topIndexLabels.0.text = "BOLL(21,2)"
            topIndexLabels.0.textColor = UIColor(hexString: "#000101")
            topIndexLabels.0.isHidden = false
        case .kLine:
            switch kIndexTop {
            case .SMA:
                topIndexLabels.0.isHidden = false
                topIndexLabels.1.isHidden = false
                topIndexLabels.0.text = "MA(\(KLineConst.kSMALine1Days)):\(kLineModel.smaLine1.toString(maxLongCount: 7))"
                topIndexLabels.0.textColor = KLineConst.kSMALine1Color
                topIndexLabels.1.text = "MA(\(KLineConst.kSMALine2Days)):\(kLineModel.smaLine2.toString(maxLongCount: 7))"
                topIndexLabels.1.textColor = KLineConst.kSMALine2Color
            case .EMA:
                topIndexLabels.0.isHidden = false
                topIndexLabels.1.isHidden = false
                topIndexLabels.0.text = "EMA(\(KLineConst.kEMALine1Days)):\(kLineModel.emaLine1.toString(maxLongCount: 7))"
                topIndexLabels.0.textColor = KLineConst.kEMALine1Color
                topIndexLabels.1.text = "EMA(\(KLineConst.kEMALine2Days)):\(kLineModel.emaLine2.toString(maxLongCount: 7))"
                topIndexLabels.1.textColor = KLineConst.kEMALine2Color
            case .BOLL:
                topIndexLabels.0.isHidden = false
                topIndexLabels.0.text = "BOLL(\(kLineModel.ub.toString(maxLongCount: 7)),\(kLineModel.boll.toString(maxLongCount: 7)),\(kLineModel.lb.toString(maxLongCount: 7)))"
                topIndexLabels.0.textColor = UIColor(hexString: "#F4F4F6")
            }
            
            switch kIndexBottom {
            case .VOL:
                bottomIndexLabel.text = "VOL \(kLineModel.volume.toString(maxLongCount: 7))"
            case .MACD:
                let text = "MACD(\(KLineConst.kMACD_P1),\(KLineConst.kKDJ_P2),\(KLineConst.kKDJ_p3)):w\(kLineModel.dif.toString(maxLongCount: 7)),\(kLineModel.dea.toString(maxLongCount: 7)),\(kLineModel.bar.toString(maxLongCount: 7))"
                bottomIndexLabel.text = text
            case .KDJ:
                let text = "KDJ(\(KLineConst.kKDJ_P1),\(KLineConst.kKDJ_P2),\(KLineConst.kKDJ_p3))K:\(kLineModel.k.toString(maxLongCount: 7)),D:\(kLineModel.d.toString(maxLongCount: 7)),J:\(kLineModel.j.toString(maxLongCount: 7))"
                bottomIndexLabel.text = text
            case .RSI:
                let text = "RSI(\(KLineConst.kRSILine1DayCount),\(KLineConst.kRSILine2DayCount),\(KLineConst.kRSILine3DayCount)):\(kLineModel.rsiLine1.toString(maxLongCount: 9)),\(kLineModel.rsiLine2.toString(maxLongCount: 9)),\(kLineModel.rsiLine3.toString(maxLongCount: 9))"
                bottomIndexLabel.text = text
            }
        }
        
        remakeConstraint(highlight: highlight, topHighly:topHighly, bottomHighly:bottomHighly)
    }
    
    /// 更新约束
    private func remakeConstraint(highlight:Highlight, topHighly:Double, bottomHighly:Double){
        vLineView.snp.remakeConstraints { (make) in
            make.width.equalTo(DefaultConst.kPixelSize)
            make.top.bottom.equalToSuperview()
            make.centerX.equalTo(highlight.xPx)
        }
        
        hLineView.snp.remakeConstraints { (make) in
            make.height.equalTo(DefaultConst.kPixelSize)
            make.left.right.equalToSuperview()
            make.centerY.equalTo(highlight.yPx)
        }
        
        xLabel.snp.remakeConstraints { (make) in
            let width = xLabel.widthForAuto()
            let maxWidth = self.frame.width
            if highlight.xPx < width/2 {
                make.left.equalToSuperview()
            }else if highlight.xPx > maxWidth - width/2 {
                make.right.equalToSuperview()
            }else{
                make.centerX.equalTo(highlight.xPx)
            }
            make.bottom.equalToSuperview()
            make.height.width.lessThanOrEqualToSuperview()
        }
        yLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.centerY.equalTo(highlight.yPx)
            make.height.width.lessThanOrEqualToSuperview()
        }
        bottomBoxView.snp.remakeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(bottomHighly/(topHighly+bottomHighly))
        }
    }
}
