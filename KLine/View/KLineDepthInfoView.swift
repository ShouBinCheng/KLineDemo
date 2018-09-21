//
//  KLineDepthInfoView.swift
//  Coinx
//
//  Created by Kevin on 2018/5/8.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

/// 深度长按信息图
class KLineDepthInfoView: BaseView {

    /// x坐标值
    private lazy var xLabel:UILabel = {
        let xLabel = UILabel.create(text: nil, font: FontConst.DINAlternateBold(size: 10), color: UIColor(hexString: "#181C26"))
        xLabel.backgroundColor = UIColor(hexString: "#8E9AB5")
        return xLabel
    }()
    
    /// y坐标值
    private lazy var yLabel:UILabel = {
        let yLabel = UILabel.create(text: nil, font: FontConst.DINAlternateBold(size: 10), color: UIColor(hexString: "#181C26"))
        yLabel.backgroundColor = UIColor(hexString: "#8E9AB5")
        return yLabel
    }()
    
    /// 原点
    private lazy var pointView:UIView = {
        let pointView = UIView()
        pointView.layer.cornerRadius = 1
        pointView.backgroundColor = UIColor(hexString: "#E2BB58")
        return pointView
    }()
    
    override func makeUI() {
        self.addSubviews([xLabel,yLabel,pointView])
    }
    
    override func makeConstraint() {
        xLabel.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.width.lessThanOrEqualToSuperview()
        }
        
        yLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.width.lessThanOrEqualToSuperview()
        }
        pointView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(2)
        }
    }
    
    override func refreshUI(viewModel: Any?) {
        guard viewModel is KLineDepthInfoViewModel else {
            return
        }
        let tempViewModel = viewModel as! KLineDepthInfoViewModel
        guard let highlight = tempViewModel.highlight else {
            return
        }
        guard let model = tempViewModel.model else {
            return
        }
        
        self.isHidden = false
        
        xLabel.text = model.price.toString(maxLongCount: 9)
        yLabel.text = model.volume.toString(maxLongCount: 9)
        remakeConstraint(highlight: highlight)
    }
    
    /// 更新约束
    private func remakeConstraint(highlight:Highlight){
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
        pointView.snp.remakeConstraints { (make) in
            make.width.height.equalTo(2)
            make.centerX.equalTo(highlight.xPx)
            make.centerY.equalTo(highlight.yPx)
        }
    }
    
}
