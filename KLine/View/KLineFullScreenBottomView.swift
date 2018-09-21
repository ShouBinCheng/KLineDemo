//
//  KLineFullScreenBottomView.swift
//  Coinx
//
//  Created by Kevin on 2018/5/4.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit

class KLineFullScreenBottomView: BaseView {

    /// 分时
    public lazy var timeLineButton:UIButton = {
        let timeLineButton = UIButton()
        timeLineButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        timeLineButton.setTitle("分时", for: .normal)
        timeLineButton.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
        timeLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
        timeLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
        return timeLineButton
    }()
    
    /// 日线
    public lazy var dayLineButton:UIButton = {
        let dayLineButton = UIButton()
        dayLineButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        dayLineButton.setTitle("日线", for: .normal)
        dayLineButton.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
        dayLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
        dayLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
        return dayLineButton
    }()
    
    /// 周线
    public lazy var weekLineButton:UIButton = {
        let weekLineButton = UIButton()
        weekLineButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        weekLineButton.setTitle("周线", for: .normal)
        weekLineButton.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
        weekLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
        weekLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
        return weekLineButton
    }()
    
    /// 小时
    public lazy var hourLineButton:UIButton = {
        let hourLineButton = UIButton()
        hourLineButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        hourLineButton.setTitle("小时", for: .normal)
        hourLineButton.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
        hourLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
        hourLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
        return hourLineButton
    }()
    public lazy var hourLineTriangleImageView:UIImageView = {
        let hourLineTriangleImageView = UIImageView()
        hourLineTriangleImageView.image = UIImage(named: "kline_icon_triangle_normal")
        return hourLineTriangleImageView
    }()
    
    /// 分钟
    public lazy var minuteLineButton:UIButton = {
        let minuteLineButton = UIButton()
        minuteLineButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        minuteLineButton.setTitle("分钟", for: .normal)
        minuteLineButton.setTitleColor(UIColor(hexString: "#8E9AB5"), for: .normal)
        minuteLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: .selected)
        minuteLineButton.setTitleColor(UIColor(hexString: "#567AF2"), for: [.selected,.highlighted])
        return minuteLineButton
    }()
    public lazy var minuteLineTriangleImageView:UIImageView = {
        let minuteLineTriangleImageView = UIImageView()
        minuteLineTriangleImageView.image = UIImage(named: "kline_icon_triangle_normal")
        return minuteLineTriangleImageView
    }()
    
    override func makeUI() {
        
        hourLineButton.addSubview(hourLineTriangleImageView)
        
        minuteLineButton.addSubview(minuteLineTriangleImageView)
        
        self.addSubviews([timeLineButton,dayLineButton,weekLineButton,
                          hourLineButton,minuteLineButton])
    }
    
    override func makeConstraint() {
        
        hourLineTriangleImageView.snp.makeConstraints { (make) in
            make.top.equalTo(hourLineButton.titleLabel!.snp.top)
            make.left.equalTo(hourLineButton.titleLabel!.snp.right).offset(1)
            make.height.width.equalTo(5)
        }
        
        minuteLineTriangleImageView.snp.makeConstraints { (make) in
            make.top.equalTo(minuteLineButton.titleLabel!.snp.top)
            make.left.equalTo(minuteLineButton.titleLabel!.snp.right).offset(1)
            make.height.width.equalTo(5)
        }
        
        let buttons:[UIButton] = [timeLineButton,dayLineButton,weekLineButton,hourLineButton,minuteLineButton]
        
        for (index, button) in buttons.enumerated() {
            button.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(index > 0 ? buttons[index-1].snp.right : 0)
                make.width.equalToSuperview().multipliedBy(1.0/5.0)
            }
        }
    }
    
    func refreshUI(kPeriod:KLinePeriod) {
        let buttons:[UIButton] = [timeLineButton,dayLineButton,weekLineButton,hourLineButton,minuteLineButton]
        
        for button in buttons {
            button.isSelected = false
        }
        
        hourLineTriangleImageView.image = UIImage(named: "kline_icon_triangle_normal")?.withColor(UIColor(hexString: "#8E9AB5"))
        minuteLineTriangleImageView.image = UIImage(named: "kline_icon_triangle_normal")?.withColor(UIColor(hexString: "#8E9AB5"))
        hourLineButton.setTitle("小时", for: .normal)
        minuteLineButton.setTitle("分钟", for: .normal)
        
        switch kPeriod {
        case .periodTimeLine:
            timeLineButton.isSelected = true
        case .periodDay:
            dayLineButton.isSelected = true
        case .periodWeek:
            weekLineButton.isSelected = true
        case .periodHour_1,.periodHour_2,.periodHour_4,.periodHour_6,.periodHour_12:
            hourLineButton.isSelected = true
            let title = KLinePeriod.titleFor(kPeriod: kPeriod)
            hourLineButton.setTitle(title, for: .normal)
            hourLineTriangleImageView.image = UIImage(named: "kline_icon_triangle_normal")
        case .periodMinute_1,.periodMinute_5,.periodMinute_15,.periodMinute_30:
            minuteLineButton.isSelected = true
            let title = KLinePeriod.titleFor(kPeriod: kPeriod)
            minuteLineButton.setTitle(title, for: .normal)
            minuteLineTriangleImageView.image = UIImage(named: "kline_icon_triangle_normal")
        }
    }
}
