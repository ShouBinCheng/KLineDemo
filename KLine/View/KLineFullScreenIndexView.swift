//
//  KLineFullScreenIndexView.swift
//  Coinx
//
//  Created by Kevin on 2018/5/4.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

class KLineFullScreenIndexView: BaseView {

    public lazy var indexButtons:[UIButton] = {
        var indexButtons = [UIButton]()
        let indexs = ["SMA","EMA","BOLL","VOL","MACD","KDJ","RSI"]
        for title in indexs {
            let button = UIButton()
            button.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
            button.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
            button.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            indexButtons.append(button)
        }
        
        return indexButtons
    }()

    override func makeUI() {
//        self.layer.borderWidth = DefaultConst.kPixelSize
//        self.layer.borderColor = UIColor(hexString: "#F0F2F5").cgColor
        
        self.addSubviews(indexButtons)
    }
    
    override func makeConstraint() {
        
        for (index, button) in indexButtons.enumerated() {
            button.snp.makeConstraints { (make) in
                make.height.equalToSuperview().multipliedBy(1.0/CGFloat(indexButtons.count))
                make.left.right.equalToSuperview()
                make.top.equalTo(index > 0 ? indexButtons[index-1].snp.bottom : self)
            }
        }
    }
    
    func refreshUI(topIndex:KIndexTop, bottomIndex:KIndexBottom) {
        
        for button in indexButtons {
            button.isSelected = false
        }
        
        switch topIndex {
        case .SMA:
            indexButtons[0].isSelected = true
        case .EMA:
            indexButtons[1].isSelected = true
        case .BOLL:
            indexButtons[2].isSelected = true
        }
        
        switch bottomIndex {
        case .VOL:
            indexButtons[3].isSelected = true
        case .MACD:
            indexButtons[4].isSelected = true
        case .KDJ:
            indexButtons[5].isSelected = true
        case .RSI:
            indexButtons[6].isSelected = true
        }
    }
}
