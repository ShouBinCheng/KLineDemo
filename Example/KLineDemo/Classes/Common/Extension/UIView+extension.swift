//
//  UIView+extension.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/16.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    //添加多个View
    func addSubviews(_ views:[UIView]){
        for view in views {
            self.addSubview(view)
        }
    }
}


