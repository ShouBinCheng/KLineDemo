//
//  KLineChartFooterView.swift
//  Coinx
//
//  Created by Kevin on 2018/5/3.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

class KLineChartFooterView: BaseView {

    /// k线按钮
    public lazy var kLineButton:UIButton = {
        let kLineButton = UIButton()
        kLineButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        kLineButton.setTitle("分时", for: .normal)
        kLineButton.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
        kLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
        kLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
        kLineButton.isSelected = true
        kLineButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: .highlighted)
        kLineButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: [.selected,.highlighted])
        kLineButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: .selected)
        return kLineButton
    }()
    public lazy var kLineTriangleImageView:UIImageView = {
        let kLineTriangleImageView = UIImageView()
        kLineTriangleImageView.image = UIImage(named: "kline_icon_triangle_normal")
        return kLineTriangleImageView
    }()
    
    /// 深度按钮
    public lazy var deepButton:UIButton = {
        let deepButton = UIButton()
        deepButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        deepButton.setTitle("深度", for: .normal)
        deepButton.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
        deepButton.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
        deepButton.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
        deepButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: .highlighted)
        deepButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: [.selected,.highlighted])
        deepButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: .selected)
        return deepButton
    }()
    
    /// 全屏按钮
    public lazy var fullButton:UIButton = {
        let fullButton = UIButton()
        fullButton.setBackgroundImage(UIImage(named: "kline_button_full_normal"), for: .normal)
        return fullButton
    }()

    /// k线图
    public lazy var kLineView:KLineView = {
        let kLineView = KLineView()
        kLineView.setHighly(topHeight: 4.0, bottomHeight: 1.0)
        return kLineView
    }()
    
    /// 深度图 
    public lazy var depthView:KLineDepthView = {
        let depthView = KLineDepthView()
        depthView.isHidden = true
        return depthView
    }()
    
    /// 最新成交
    private lazy var newIconImageView:UIImageView = {
        let newIconImageView = UIImageView()
        newIconImageView.image = UIImage(named: "kline_icon_deal_normal")
        return newIconImageView
    }()
    private lazy var newLabelDescrLabel:UILabel = {
        let newLabelDescrLabel = UILabel.create(text: "最新成交", font: UIFont.systemFont(ofSize: 12), color: UIColor(hexString: "#8E9AB5"))
        return newLabelDescrLabel
    }()
    
    /// 底部背景线
    private lazy var bottomBgView:UIView = {
        let bottomBgView = UIView()
        bottomBgView.backgroundColor = UIColor(hexString: "#141821")
        return bottomBgView
    }()
    
    /// 时间
    private lazy var timeDescrLabel:UILabel = {
        let timeDescrLabel = UILabel.create(text: "时间", font: UIFont.systemFont(ofSize: 12), color: UIColor(hexString: "#8E9AB5"))
        return timeDescrLabel
    }()
    
    /// 数量
    private lazy var volumeDescrLabel:UILabel = {
        let volumeDescrLabel = UILabel.create(text: "数量", font: UIFont.systemFont(ofSize: 12), color: UIColor(hexString: "#8E9AB5"))
        return volumeDescrLabel
    }()
    
    /// 价格
    private lazy var priceDescrLabel:UILabel = {
        let priceDescrLabel = UILabel.create(text: "价格", font: UIFont.systemFont(ofSize: 12), color: UIColor(hexString: "#8E9AB5"))
        return priceDescrLabel
    }()
    
    override func makeUI() {
        self.addSubviews([deepButton,kLineButton,fullButton,depthView
            ,kLineView,newIconImageView,newLabelDescrLabel,bottomBgView
            ,timeDescrLabel,volumeDescrLabel,priceDescrLabel])
        
        kLineButton.addSubview(kLineTriangleImageView)
    }
    
    override func makeConstraint() {
        
        kLineTriangleImageView.snp.makeConstraints { (make) in
            make.top.equalTo(kLineButton.titleLabel!.snp.top)
            make.left.equalTo(kLineButton.titleLabel!.snp.right).offset(1)
            make.height.width.equalTo(5)
        }
        
        fullButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.top.equalTo(10)
            make.right.equalTo(-5)
        }
        
        kLineButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(25)
            make.left.equalTo(10)
            make.centerY.equalTo(fullButton)
        }
        
        deepButton.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(25)
            make.left.equalTo(kLineButton.snp.right).offset(10)
            make.centerY.equalTo(kLineButton)
        }
        
        kLineView.snp.makeConstraints { (make) in
            make.height.equalTo(375)
            make.left.right.equalToSuperview()
            make.top.equalTo(fullButton.snp.bottom).offset(16)
        }
        
        depthView.snp.makeConstraints { (make) in
            make.edges.equalTo(kLineView)
        }
        
        newIconImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(10)
            make.left.equalTo(10)
            make.top.equalTo(kLineView.snp.bottom).offset(39)
        }
        
        newLabelDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.lessThanOrEqualToSuperview()
            make.left.equalTo(newIconImageView.snp.right).offset(5)
            make.centerY.equalTo(newIconImageView)
        }
        
        bottomBgView.snp.makeConstraints { (make) in
            make.height.equalTo(25)
            make.left.right.bottom.equalToSuperview()
        }
        
        timeDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalTo(DefaultConst.kScreenWidth/6)
            make.centerY.equalTo(bottomBgView)
        }
        
        volumeDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalTo(bottomBgView)
        }
        
        priceDescrLabel.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.lessThanOrEqualToSuperview()
            make.centerX.equalTo(DefaultConst.kScreenWidth/6*5)
            make.centerY.equalTo(bottomBgView)
        }
    }
}
