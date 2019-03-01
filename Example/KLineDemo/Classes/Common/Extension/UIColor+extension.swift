//
//  UIColor+extension.swift
//  ejufu
//
//  Created by Kevin on 2017/12/16.
//  Copyright © 2017年 qsjr. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    public convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var formatted = hexString.replacingOccurrences(of: "0x", with: "")
        formatted = formatted.replacingOccurrences(of: "#", with: "")
        if let hex = Int(formatted, radix: 16) {
            let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16)/255.0)
            let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8)/255.0)
            let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0)/255.0)
            self.init(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        }
    }
}
