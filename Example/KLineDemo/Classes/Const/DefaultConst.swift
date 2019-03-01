//
//  DefaultConst.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/18.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import Foundation
import UIKit

class DefaultConst: NSObject {

    //屏幕宽高
    static let kScreenWidth:CGFloat = UIScreen.main.bounds.size.width
    static let kScreenHeight:CGFloat = UIScreen.main.bounds.size.height
    //一个像素宽度
    static let kPixelSize:CGFloat = (1.0/UIScreen.main.scale)
}
