//
//  KLineChartViewController.swift
//  Coinx
//
//  Created by Kevin on 2018/4/27.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit
import RxCocoa
import SnapKit

class KLineChartViewController: UIViewController {

    /// 构造方法
    ///
    /// - Parameters:
    ///   - bitCode: 币code
    ///   - hideBottom: 是否隐藏底部买卖按钮
    init(bitCode:String, hideBottom:Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.bitCode = bitCode
        self.hideBottomButton = hideBottom
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 币码
    private var bitCode:String!
    /// 是否隐藏底部买卖按钮
    private var hideBottomButton:Bool!
    /// k线周期
    private lazy var kPeriod:KLinePeriod = {
        let kPeriod = KLinePeriod.getDefaultKLinePeriod()
        return kPeriod
    }()
    /// 订阅管理
    private lazy var marketSubscribeManager:MarketSubscribeManager = {
        let marketSubscribeManager = MarketSubscribeManager(bitCode: bitCode)
        return marketSubscribeManager
    }()
    
    /// 返回按钮
    private lazy var backButton:UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "common_button_back_normal"), for: .normal)
        backButton.sizeToFit()
        return backButton
    }()
    /// tableView
    private lazy var tableView:UITableView = {
        let tableView = UITableView.create(frame: CGRect(), style: .grouped, edgeTop: 0, edgeBottom: hideBottomButton ? 0 :49)
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    /// headerView 
    private lazy var headerView:KLineChartHeaderView = {
        let headerView = KLineChartHeaderView()
        return headerView
    }()
    /// footerView
    private lazy var footerView:KLineChartFooterView = {
        let footerView = KLineChartFooterView()
        footerView.kLineView.delegate = self
        footerView.depthView.delegate = self
        let title = KLinePeriod.titleFor(kPeriod: self.kPeriod)
        footerView.kLineButton.setTitle(title, for: .normal)
        return footerView
    }()
    /// 选择图层
    private lazy var kCheckedView:KLineChartCheckedView = {
        let kCheckedView = KLineChartCheckedView()
        kCheckedView.isHidden = true
        return kCheckedView
    }()
    /// k线数据
    private lazy var kLineDataSource:[KLineModel] = {
        let kLineDataSource = [KLineModel]()
        return kLineDataSource
    }()
    /// 买盘数据源(深度)
    private lazy var buyDataSource:[KLineDepthModel] = {
        let buyDataSource = [KLineDepthModel]()
        return buyDataSource
    }()
    /// 卖盘数据源(深度)
    private lazy var sellDataSource:[KLineDepthModel] = {
        let sellDataSource = [KLineDepthModel]()
        return sellDataSource
    }()
    /// 最新交易数据
    private lazy var tradesDataSource:[TradesModel] = {
        let tradesDataSource = [TradesModel]()
        return tradesDataSource
    }()
    /// 市场信息
    private var markets:PagesMarketsResponse?
    /// k线请求表单
    private lazy var fromModel:KLineFM = {
        let fromModel = KLineFM(market: bitCode, limit: KLineConst.kLoadingLimit, period: 1)
        return fromModel
    }()
    
    /// 买按钮
    private lazy var buyButton:UIButton = {
        let buyButton = UIButton()
        buyButton.titleLabel?.font = FontConst.PingFangSCMedium(size: 16)
        buyButton.setTitle("买入".localized, for: .normal)
        buyButton.setTitleColor(.white, for: .normal)
        buyButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#45B854")), for: .normal)
        buyButton.isHidden = hideBottomButton
        return buyButton
    }()
    /// 卖按钮
    private lazy var sellButton:UIButton = {
        let sellButton = UIButton()
        sellButton.titleLabel?.font = FontConst.PingFangSCMedium(size: 16)
        sellButton.setTitle("卖出".localized, for: .normal)
        sellButton.setTitleColor(.white, for: .normal)
        sellButton.setBackgroundImage(UIImage.creatWithColor(UIColor(hexString: "#F2334F")), for: .normal)
        sellButton.isHidden = hideBottomButton
        return sellButton
    }()
}

//MARK: - life cycle
extension KLineChartViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "#181C26")
        
        makeUI()
        makeEvent()
        makeConstraint()
        requestKline()
        requestPagesMarkets()
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


//MARK: - private func
extension KLineChartViewController {
    
    /// 创建UI
    private func makeUI(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.view.addSubviews([tableView,buyButton,sellButton,kCheckedView])
    }
    
    /// 绑定事件
    private func makeEvent(){
        // 返回按钮
        let _ = backButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.navigationController?.popViewController(animated: true)
        })
        
        // k线按钮
        let _ = footerView.kLineButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            if self.footerView.kLineButton.isSelected == false {
                self.footerView.kLineButton.isSelected = true
                self.footerView.deepButton.isSelected = false
                self.footerView.kLineView.isHidden = false
                self.footerView.depthView.isHidden = true
                let image = self.footerView.kLineTriangleImageView.image!
                self.footerView.kLineTriangleImageView.image = image.withColor(UIColor(hexString: "#567AF2"))
            }else{
                self.kCheckedView.isHidden = false
                let frame = self.footerView.convert(self.footerView.kLineButton.frame, to: self.view)
                self.kCheckedView.refreshUI(frame: frame, kPeriod: self.kPeriod)
            }
        })
        
        // 深度按钮
        let _ = footerView.deepButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            self.footerView.kLineButton.isSelected = false
            self.footerView.deepButton.isSelected = true
            self.footerView.kLineView.isHidden = true
            self.footerView.depthView.isHidden = false
            let image = self.footerView.kLineTriangleImageView.image!
            self.footerView.kLineTriangleImageView.image = image.withColor(UIColor(hexString: "#8E9AB5"))
        })
        
        // 全屏按钮
        let _ = footerView.fullButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
            guard let `self` = self else { return }
            let fullVC = KLineFullScreenViewController(bitCode: self.bitCode, kPeriod: self.kPeriod, market: self.marketSubscribeManager)
            self.present(fullVC, animated: true, completion: nil)
        })
        
        // k线周期按钮
        for button in kCheckedView.kPeriodButtons {
            let _ = button.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
                guard let `self` = self else { return }
                let index = self.kCheckedView.kPeriodButtons.index(of: button)!
                self.kPeriod = KLinePeriod.kPeriodFor(index: index)!
                self.requestKline()
                self.kCheckedView.isHidden = true
                let title = KLinePeriod.titleFor(kPeriod: self.kPeriod)
                self.footerView.kLineButton.setTitle(title, for: .normal)
                KLinePeriod.setDefaultKLinePeriod(self.kPeriod)
            })
        }
        
//         //买入
//        let _ = buyButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
//        })
//
//        // 卖出
//        let _ = sellButton.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] (_) in
//
//        })
    }
    
    /// 创建约束
    private func makeConstraint(){
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        kCheckedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        buyButton.snp.makeConstraints { (make) in
            make.left.bottom.equalToSuperview()
            make.height.equalTo(DefaultConst.kScreenHeight == 812 ? 66 : 49)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        sellButton.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(DefaultConst.kScreenHeight == 812 ? 66 : 49)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    /// 添加最新交易数据
    private func addTradesData(trades:[TradesModel]){
        guard trades.count > 0 else {
            return
        }
        tradesDataSource.insert(contentsOf: trades, at: 0)
        
        var newTrades = [TradesModel]()
        for i in 0 ..< (tradesDataSource.count <= 10 ? tradesDataSource.count : 10) {
            newTrades.append(tradesDataSource[i])
        }
        tradesDataSource = newTrades
        self.tableView.reloadData()
    }
    
    /// 请求k线数据
    private func requestKline(){
        
        fromModel.period = KLinePeriod.minuteFor(kPeriod: kPeriod)
        footerView.kLineView.startLoading()
        
        let _ = KLineService.requestObject(target: KLineTarget.kline(fromModel: fromModel), success: { [weak self] (res) in
            guard let `self` = self else { return }
            self.footerView.kLineView.stopLoading()
            if let models = res?.models{
                self.kLineDataSource = models
                let period = KLinePeriod.minuteFor(kPeriod: self.kPeriod)
                self.footerView.kLineView.setPeriod(UInt(period))
                self.footerView.kLineView.reloadData()
            }
        }, failure: { [weak self] (msg,res) in
            guard let `self` = self else { return }
            self.footerView.kLineView.stopLoading()
            self.requestKline()
        }, responseModel: KLineResponse.self)
    }
    
    /// 请求市场信息
    private func requestPagesMarkets() {
        let _ = KLineService.requestFormat(target: KLineTarget.pagesMarkets(code: bitCode), success: { [weak self] (res) in
            
            guard let `self` = self else { return }
            self.title = res.data?.name
            self.headerView.refreshUI(viewModel: res.data)
            if let trades = res.data?.trades {
                self.addTradesData(trades: trades)
            }
            self.markets = res.data
        }, failure: { [weak self] (msg,_) in
            guard let `self` = self else { return }
            self.requestPagesMarkets()
        }, responseModel: PagesMarketsResponse.self)
    }
}

//MARK: - k线图 代理
extension KLineChartViewController : KLineViewDataSource {
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
        return kLineDataSource
    }
}

//MARK: - 深度图 代理
extension KLineChartViewController : KLineDepthViewDataSource {
    /// 深度图买盘数据
    func kLineDepthViewForBuyData(_ kLineDepthView: KLineDepthView) -> [KLineDepthModel] {
        return buyDataSource
    }
    /// 深度图买盘数据
    func kLineDepthViewForSellData(_ kLineDepthView: KLineDepthView) -> [KLineDepthModel] {
        return sellDataSource
    }
}

//MARK: - tabelView 代理
extension KLineChartViewController : UITableViewDelegate {
    
}

extension KLineChartViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 161
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return headerView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 522
        default:
            return 0.01
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return footerView
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        default:
            return tradesDataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return KLineChartCell.createCell(tableView: tableView, indexPath: indexPath, viewModel: tradesDataSource[indexPath.row])
    }
}

//MARK: - 数据订阅
extension KLineChartViewController : MarketSubscribeManagerDelegate {
    /// 最新交易回调
    func subscribeTrades(datas: [TradesModel]) {
        self.addTradesData(trades: datas)
        self.requestPagesMarkets()
    }
    /// 深度数据回调
    func subscribeDepthUpdate(buyData: [KLineDepthModel], sellData: [KLineDepthModel]) {
        self.buyDataSource = buyData
        self.sellDataSource = sellData
        self.footerView.depthView.reloadData()
    }
}
