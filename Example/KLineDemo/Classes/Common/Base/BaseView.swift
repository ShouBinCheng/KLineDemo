//
//  BaseView.swift
//  KLineDemo
//
//  Created by 程守斌 on 2019/2/28.
//  Copyright © 2019 程守斌. All rights reserved.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
        makeConstraint()
        makeEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //创建UI 子类需override
    func makeUI(){
    }
    
    //创建约束 子类需override
    func makeConstraint(){
    }
    
    //创建事件 子类需override
    func makeEvent() {
    }
    
    //刷新UI 子类需override
    func refreshUI(viewModel:Any?){
    }

}
