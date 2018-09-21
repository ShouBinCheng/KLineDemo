//
//  KLineFullScreenViewController.swift
//  Coinx
//
//  Created by Kevin on 2018/4/27.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit
import RxCocoa
import SnapKit

class KLineFullScreenViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(bitCode:String, kPeriod:KLinePeriod,market marketSubscribeManager:MarketSubscribeManager) {
        super.init(nibName: nil, bundle: nil)
        self.bitCode = bitCode
        self.kPeriod = kPeriod
        self.marketSubscribeManager = marketSubscribeManager
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 币码
    private var bitCode:String!
    /// k线周期
    private var kPeriod:KLinePeriod = .periodTimeLine
    /// 订阅管理
    private var marketSubscribeManager:MarketSubscribeManager!
    /// 上图指标
    private var kIndexTop:KIndexTop = .SMA
    /// 下图指标
    private var kIndexBottom:KIndexBottom = .VOL
    
    /// k线数据
    private lazy var dataSource:[KLineModel] = {
        let dataSource = [KLineModel]()
        return dataSource
    }()
    
    // 行情数据
    private var markets:PagesMarketsResponse?
    
    /// k线请求表单
    private lazy var fromModel:KLineFM = {
        let fromModel = KLineFM(market: bitCode, limit: KLineConst.kLoadingLimit, period: 1)
        return fromModel
    }()
    
    /// 顶部信息
    private lazy var topInfoView:KLineFullScreenTopInfoView = {
        let topInfoView = KLineFullScreenTopInfoView()
        topInfoView.backgroundColor = UIColor(hexString: "#1F232D")
        return topInfoView
    }()
    
    /// k线视图
    private lazy var kLineView:KLineView = {
        let kLineView = KLineView()
        kLineView.delegate = self
        return kLineView
    }()
    
    /// 指标视图 
    private lazy var kIndexView:KLineFullScreenIndexView = {
        let kIndexView = KLineFullScreenIndexView()
        kIndexView.backgroundColor = UIColor(hexString: "#141821")
        kIndexView.refreshUI(topIndex: kIndexTop, bottomIndex: kIndexBottom)
        return kIndexView
    }()
    
    /// 底部视图 
    private lazy var bottomView:KLineFullScreenBottomView = {
        let bottomView = KLineFullScreenBottomView()
        bottomView.backgroundColor = UIColor(hexString: "#1F232D")
        bottomView.refreshUI(kPeriod: kPeriod)
        return bottomView
    }()
    
    /// 选择图层 
    private lazy var kCheckedView:KLineFullScreenCheckedView = {
        let kCheckedView = KLineFullScreenCheckedView()
        kCheckedView.isHidden = true
        return kCheckedView
    }()

    deinit {
        print("\(self) deinit")
    }
}

//MARK: - life cycle
extension KLineFullScreenViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor(hexString: "#181C26")
        let transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/2));
        self.view.layer.setAffineTransform(transform)
        
        makeUI()
        makeEvent()
        makeConstraint()
        requestKline()
        requestPagesMarkets()
        refreshUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        marketSubscribeManager.addDelegate(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        marketSubscribeManager.removeDelegate(self)
    }
}

//MARK: - private
extension KLineFullScreenViewController {
    
    /// 创建添加视图
    private func makeUI(){
        self.view.addSubviews([topInfoView,kLineView,kIndexView,bottomView,kCheckedView])
    }
    
    /// 绑定事件
    private func makeEvent(){
        // 关闭
        let _ = topInfoView.closeButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.dismiss(animated: true, completion: nil)
        })
        
        // 分时
        let _ = bottomView.timeLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kPeriod = .periodTimeLine
            self.requestKline()
            self.bottomView.refreshUI(kPeriod: self.kPeriod)
            self.refreshUI()
        })
        
        // 日线
        let _ = bottomView.dayLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kPeriod = .periodDay
            self.requestKline()
            self.bottomView.refreshUI(kPeriod: self.kPeriod)
            self.refreshUI()
        })
        
        // 周线
        let _ = bottomView.weekLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kPeriod = .periodWeek
            self.requestKline()
            self.bottomView.refreshUI(kPeriod: self.kPeriod)
            self.refreshUI()
        })
        
        // 小时
        let _ = bottomView.hourLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kCheckedView.isHidden = false
            self.kCheckedView.refreshUI(isHour: true, kPeriod: self.kPeriod)
        })
        
        // 分钟
        let _ = bottomView.minuteLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.kCheckedView.isHidden = false
            self.kCheckedView.refreshUI(isHour: false, kPeriod: self.kPeriod)
        })
        
        //小时按钮
        for button in kCheckedView.hourButtons {
            let _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                let index = self.kCheckedView.hourButtons.index(of: button)
                switch index {
                case 0?:
                    self.kPeriod = .periodHour_1
                case 1?:
                    self.kPeriod = .periodHour_2
                case 2?:
                    self.kPeriod = .periodHour_4
                case 3?:
                    self.kPeriod = .periodHour_6
                case 4?:
                    self.kPeriod = .periodHour_12
                default:
                    break
                }
                self.requestKline()
                self.bottomView.refreshUI(kPeriod: self.kPeriod)
                self.kCheckedView.isHidden = true
                self.refreshUI()
            })
        }
        
        //分钟按钮
        for button in kCheckedView.minuteButtons {
            let _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                let index = self.kCheckedView.minuteButtons.index(of: button)
                switch index {
                case 0?:
                    self.kPeriod = .periodMinute_1
                case 1?:
                    self.kPeriod = .periodMinute_5
                case 2?:
                    self.kPeriod = .periodMinute_15
                case 3?:
                    self.kPeriod = .periodMinute_30
                default:
                    break
                }
                self.requestKline()
                self.bottomView.refreshUI(kPeriod: self.kPeriod)
                self.kCheckedView.isHidden = true
                self.refreshUI()
            })
        }
        
        //指标按钮
        for button in kIndexView.indexButtons {
            let _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                let index = self.kIndexView.indexButtons.index(of: button)
                switch index {
                case 0?:
                    self.kIndexTop = .SMA
                case 1?:
                    self.kIndexTop = .EMA
                case 2?:
                    self.kIndexTop = .BOLL
                case 3?:
                    self.kIndexBottom = .VOL
                case 4?:
                    self.kIndexBottom = .MACD
                case 5?:
                    self.kIndexBottom = .KDJ
                case 6?:
                    self.kIndexBottom = .RSI
                default:
                    break
                }
                self.kLineView.setKIndexTop(index: self.kIndexTop)
                self.kLineView.setKIndexBottom(index: self.kIndexBottom)
                self.kIndexView.refreshUI(topIndex: self.kIndexTop, bottomIndex: self.kIndexBottom)
            })
        }
    }
    
    /// 创建约束
    private func makeConstraint(){
        topInfoView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.top.left.right.equalToSuperview()
        }
        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.bottom.right.equalToSuperview()
        }
        kLineView.snp.makeConstraints { (make) in
            make.left.equalTo(DefaultConst.kScreenHeight == 812 ? 30 : 0)
            make.right.equalTo(kIndexView.snp.left).offset(-5)
            make.top.equalTo(topInfoView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top).offset(-5)
        }
        kIndexView.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.width.equalTo(DefaultConst.kScreenHeight == 812 ? 80 : 50)
            make.top.equalTo(topInfoView.snp.bottom).offset(5)
            make.bottom.equalTo(bottomView.snp.top).offset(-5)
        }
        kCheckedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 刷新UI布局
    private func refreshUI(){
        switch kPeriod {
        case .periodTimeLine:
            kIndexView.isHidden = true
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else { return }
                self.kIndexView.snp.remakeConstraints({ (make) in
                    make.right.equalTo(DefaultConst.kScreenHeight == 812 ? 80 : 50)
                    make.width.equalTo(DefaultConst.kScreenHeight == 812 ? 80 : 50)
                    make.top.equalTo(self.topInfoView.snp.bottom).offset(5)
                    make.bottom.equalTo(self.bottomView.snp.top).offset(-5)
                })
                self.kIndexView.layoutIfNeeded()
            }
        default:
            kIndexView.isHidden = false
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else { return }
                self.kIndexView.snp.remakeConstraints({ (make) in
                    make.right.equalTo(0)
                    make.width.equalTo(DefaultConst.kScreenHeight == 812 ? 80 : 50)
                    make.top.equalTo(self.topInfoView.snp.bottom).offset(5)
                    make.bottom.equalTo(self.bottomView.snp.top).offset(-5)
                })
                self.kIndexView.layoutIfNeeded()
            }
        }
    }
    
    /// 请求k线数据
    private func requestKline(){
        fromModel.period = KLinePeriod.minuteFor(kPeriod: kPeriod)
        kLineView.startLoading()
        
        let _ = KLineService.requestObject(target: KLineTarget.kline(fromModel: fromModel), success: { [weak self] (res) in
            guard let `self` = self else { return }
            self.kLineView.stopLoading()
            if let models = res?.models {
                self.dataSource = models
                let period = KLinePeriod.minuteFor(kPeriod: self.kPeriod)
                self.kLineView.setPeriod(UInt(period))
                self.kLineView.reloadData()
            }
        }, failure: { [weak self] (msg,res) in
            guard let `self` = self else { return }
            self.kLineView.stopLoading()
            self.requestKline()
        }, responseModel: KLineResponse.self)
    }
    
    /// 请求市场信息
    private func requestPagesMarkets() {
        let _ = KLineService.requestFormat(target: KLineTarget.pagesMarkets(code: bitCode), success: { [weak self] (res) in
            guard let `self` = self else { return }
            self.markets = res.data
            self.topInfoView.refreshUI(viewModel: self.markets)
        }, failure: { (msg,_) in
                
        }, responseModel: PagesMarketsResponse.self)
    }
}

//MARK: - k线 代理
extension KLineFullScreenViewController : KLineViewDataSource {
    /// k线显示类型
    func kLineViewForType(_ kLineView: KLineView) -> KType {
        switch kPeriod {
        case .periodTimeLine:
            return .kTimeLine
        default:
            return .kLine
        }
    }
    /// k线数据
    func kLineViewForData(_ kLineView: KLineView) -> [KLineModel] {
        return dataSource
    }
}

//MARK: - 订阅回调
extension KLineFullScreenViewController : MarketSubscribeManagerDelegate {
    /// 最新交易
    func subscribeTrades(datas: [TradesModel]) {
        self.requestPagesMarkets()
    }
    /// 深度数据
    func subscribeDepthUpdate(buyData: [KLineDepthModel], sellData: [KLineDepthModel]) {
        
    }
}
