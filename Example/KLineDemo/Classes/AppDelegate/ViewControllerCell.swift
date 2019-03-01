//
//  ViewControllerCell.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit

class ViewControllerCell: BaseCell {

    
    private lazy var titleLabel:UILabel = {
        let titleLabel = UILabel.create(text: nil, font: UIFont.systemFont(ofSize: 15), color: UIColor.black)
        return titleLabel
    }()
    
    private lazy var bottomLineView:UIView = {
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = ColorConst.lineColor
        return bottomLineView
    }()

    override func makeUI() {
        self.backgroundColor = UIColor.white
        self.selectionStyle = .default
        
        self.contentView.addSubviews([titleLabel,bottomLineView])
    }
    
    override func makeConstraint() {
        titleLabel.snp.makeConstraints { (make) in
            make.height.width.lessThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
        bottomLineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(DefaultConst.kPixelSize)
        }
    }
    
    override func refreshUI(viewModel: Any?) {
        guard viewModel is String else {
            return
        }
        let model = viewModel as! String
        titleLabel.text = model
    }
}

