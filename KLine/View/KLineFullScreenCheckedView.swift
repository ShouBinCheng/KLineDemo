//
//  KLineFullScreenCheckedView.swift
//  Coinx
//
//  Created by Kevin on 2018/5/4.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

class KLineFullScreenCheckedView: BaseView {

    /// 小时气泡
    private lazy var hourBubbleView:UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = UIColor(hexString: "#1F232D")
        return bubbleView
    }()
    
    /// 分钟气泡
    private lazy var minuteBubbleView:UIView = {
        let bubbleView = UIView()
        bubbleView.backgroundColor = UIColor(hexString: "#1F232D")
        return bubbleView
    }()
    
    /// 小时按钮
    public lazy var hourButtons:[UIButton] = {
        var hourButtons = [UIButton]()
        let titles = ["1小时","2小时","4小时","6小时","12小时"]
        for title in titles {
            let button = UIButton()
            button.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
            button.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
            button.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
            button.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: .highlighted)
            button.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: [.selected,.highlighted])
            button.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#181C26")), for: .selected)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            hourButtons.append(button)
        }
        return hourButtons
    }()
    
    
    /// 分钟按钮
    public lazy var minuteButtons:[UIButton] = {
        var minuteButtons = [UIButton]()
        let titles = ["1分","5分","15分","30分"]
        for title in titles {
            let button = UIButton()
            button.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
            button.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
            button.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
            button.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: .highlighted)
            button.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#1F232D")), for: [.selected,.highlighted])
            button.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#181C26")), for: .selected)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            minuteButtons.append(button)
        }
        return minuteButtons
    }()
    
    override func makeUI() {
        
        hourBubbleView.addSubviews(hourButtons)
        
        minuteBubbleView.addSubviews(minuteButtons)
        
        self.addSubviews([hourBubbleView,minuteBubbleView])
        
    }
    
    override func makeConstraint() {
        
        hourBubbleView.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.centerX.equalTo(DefaultConst.kScreenHeight/10*7)
            make.bottom.equalTo(-40)
        }
        
        minuteBubbleView.snp.makeConstraints { (make) in
            make.width.equalTo(90)
            make.centerX.equalTo(DefaultConst.kScreenHeight/10*9)
            make.bottom.equalTo(-40)
        }
        
        for (index, button) in hourButtons.enumerated() {
            button.snp.makeConstraints { (make) in
                make.height.equalTo(25)
                make.width.equalTo(55)
                make.centerX.equalToSuperview()
                make.top.equalTo(index > 0 ? hourButtons[index-1].snp.bottom : hourBubbleView).offset(15)
                if index == hourButtons.count-1 {
                    make.bottom.equalTo(-15)
                }
            }
        }

        for (index, button) in minuteButtons.enumerated() {
            button.snp.makeConstraints { (make) in
                make.height.equalTo(25)
                make.width.equalTo(55)
                make.centerX.equalToSuperview()
                make.top.equalTo(index > 0 ? minuteButtons[index-1].snp.bottom : minuteBubbleView).offset(15)
                if index == minuteButtons.count-1 {
                    make.bottom.equalTo(-15)
                }
            }
        }
    }
    
    override func makeEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureAction(_:)))
        self.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: nil)
        hourBubbleView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: nil)
        minuteBubbleView.addGestureRecognizer(tap2)
    }
    
    @objc private func handleTapGestureAction(_ recognizer: UILongPressGestureRecognizer){
        self.isHidden = true
    }
    
    func refreshUI(isHour:Bool, kPeriod:KLinePeriod) {
        hourBubbleView.isHidden = !isHour
        minuteBubbleView.isHidden = isHour
        
        let buttons = hourButtons + minuteButtons
        for button in buttons {
            button.isSelected = false
        }
        
        switch kPeriod {
        case .periodHour_1:
            hourButtons[0].isSelected = true
        case .periodHour_2:
            hourButtons[1].isSelected = true
        case .periodHour_4:
            hourButtons[2].isSelected = true
        case .periodHour_6:
            hourButtons[3].isSelected = true
        case .periodHour_12:
            hourButtons[4].isSelected = true
        case .periodMinute_1:
            minuteButtons[0].isSelected = true
        case .periodMinute_5:
            minuteButtons[1].isSelected = true
        case .periodMinute_15:
            minuteButtons[2].isSelected = true
        case .periodMinute_30:
            minuteButtons[3].isSelected = true
        default:
            break
        }
    }
}
