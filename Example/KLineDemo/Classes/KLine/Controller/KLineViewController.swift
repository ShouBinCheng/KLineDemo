//
//  KLineViewController.swift
//  KLineDemo
//
//  Created by 程守斌 on 2019/3/1.
//  Copyright © 2019 程守斌. All rights reserved.
//

import UIKit

class KLineViewController: UIViewController {
    
    // k线数据
    private lazy var kLineDataSource:[KLineModel] = {
        var kLineDataSource = [KLineModel]()
        guard let jsonData = UtilSampleData.getKLineForDay() else {
            return kLineDataSource
        }
        let sampleData = KLineSampleDataResponse(JSON: jsonData)
        guard let models = sampleData?.chartlist else {
            return kLineDataSource
        }
        for item in models {
            let model = KLineModel(timestamp: 0, open: item.open!, high: item.high!, low: item.low!, close: item.close!, volume: item.volume!);
            kLineDataSource.append(model);
        }
        UtilAlgorithm.calculationResults(models: kLineDataSource)
        return kLineDataSource
    }()
    
    private lazy var kLineView:KLineView = {
        let kLineView = KLineView()
        kLineView.delegate = self
        return kLineView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = KLineConst.kLineBgColor
        makeUI()
        makeConstraint()
        kLineView.reloadData()
    }
}

//MARK: - private
extension KLineViewController {
    
    func makeUI() {
        self.view.addSubviews([kLineView]);
    }
    
    func makeConstraint() {
        kLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(200)
            make.height.equalTo(400)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.present(KLineFullScreenViewController(), animated: true, completion: nil)
    }
}

extension KLineViewController : KLineViewDataSource {
    
    func kLineViewForType(_ kLineView: KLineView) -> KType {
        return .kLine
    }
    
    func kLineViewForData(_ kLineView: KLineView) -> [KLineModel] {
        return kLineDataSource
    }
}

