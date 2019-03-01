//
//  KLineFullScreenViewController.swift
//  KLineDemo
//
//  Created by 程守斌 on 2019/3/1.
//  Copyright © 2019 程守斌. All rights reserved.
//

import UIKit

class KLineFullScreenViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}

//MARK: - life cycle
extension KLineFullScreenViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = KLineConst.kLineBgColor
        let transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
        self.view.layer.setAffineTransform(transform)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}
