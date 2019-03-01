//
//  UILabel+extension.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    //便利构建器
    static func create(text:String?, font:UIFont?, color:UIColor?) -> UILabel {
        let label = UILabel()
        if let text = text {
            label.text = text
        }
        if let font = font {
            label.font = font
        }
        if let color = color {
            label.textColor = color
        }
        return label
    }
    
    //获取文本宽度，text已经有值时使用
    func widthForAuto() -> CGFloat {
        let label = UILabel.create(text: self.text, font: self.font, color: self.textColor)
        label.sizeToFit()
        return label.frame.size.width
    }
    
    //获取文本高度,设定宽度时使用
    func heightWith(width:CGFloat) -> CGFloat {
        let label = UILabel.create(text: self.text, font: self.font, color: self.textColor)
        label.attributedText = self.attributedText
        label.frame.size.width = width
        label.sizeToFit()
        return label.frame.size.height
    }
}
