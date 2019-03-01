//
//  KLineView.swift
//  Coinx
//
//  Created by Kevin on 2018/4/27.
//  Copyright © 2018年 lizhengyi. All rights reserved.
//

import UIKit
import DGActivityIndicatorView
import Charts

/// k线类型
enum KType {
    case kLine          //k线
    case kTimeLine      //分时线`default`
}

/// 上图k线指标
enum KIndexTop {
    case SMA            //简单均线（5日、10日、20日均线）`default`
    case EMA            //指数平均指标
    case BOLL           //布林轨道
}

/// 下图指标线
enum KIndexBottom {
    case VOL            //成交量`default`
    case MACD           //指数平滑异同平均线
    case KDJ            //随机指标
    case RSI            //相对强弱指标
}

protocol KLineViewDataSource : NSObjectProtocol {
    
    /// 获取图形类型
    func kLineViewForType(_ kLineView:KLineView) -> KType
    
    /// 获取k线模型
    func kLineViewForData(_ kLineView:KLineView) -> [KLineModel]
}

class KLineView: KLineBaseView {

    /// k线类型
    private var kType:KType = .kTimeLine
    /// 上图指标类型
    private var kIndexTop:KIndexTop = .SMA
    /// 下图指标类型
    private var kIndexBottom:KIndexBottom = .VOL
    /// k线图的时间间隔
    private var period:UInt = 1    //初始一分钟
    
    private var showDefaultCount:Int = KLineConst.showDefaultCount
    private var showMinCount:Int = KLineConst.showMinCount
    private var showMaxCount:Int = KLineConst.showMaxCount
    
    /// 代理
    weak var delegate:KLineViewDataSource?
    
    /// 顶部组合图与底部组合图的高度比重 （3/4 、 1/4）
    private var topHighly:Double    = 3
    private var bottomHighly:Double = 1
    
    /// k线数据源
    private lazy var dataSource:[KLineModel] = {
        let dataSource = [KLineModel]()
        return dataSource
    }()
    
    /// 顶部组合图数据
    private lazy var topCombinedChartData:CombinedChartData = {
        let topCombinedChartData = CombinedChartData()
        return topCombinedChartData
    }()
    
    /// 低部组合图数据
    private lazy var bottomCombinedChartData:CombinedChartData = {
        let bottomCombinedChartData = CombinedChartData()
        return bottomCombinedChartData
    }()
    
    /// 加载动画
    private lazy var loadingView:DGActivityIndicatorView = {
        let loadingView = DGActivityIndicatorView(type: .lineScale, tintColor: UIColor(hexString: "#567AF2"))
        loadingView?.isHidden = true
        return loadingView!
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#141821")
        makeUI()
        makeConstraint()
        makeGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 顶部组合图
    private lazy var topChartView:CombinedChartView = {
        let topChartView = CombinedChartView()
        setupTopChart(chartView: topChartView)
        topChartView.delegate = self
        topChartView.xAxis.valueFormatter = self
        return topChartView
    }()
    
    /// 底部组合图
    private lazy var bottomChartView:CombinedChartView = {
        let bottomChartView = CombinedChartView()
        setupBottomChart(chartView: bottomChartView)
        bottomChartView.delegate = self
        return bottomChartView
    }()
    
    /// 长按显示的信息图层
    private lazy var infoView:KLineInfoView = {
        let infoView = KLineInfoView()
        infoView.isHidden = true
        return infoView
    }()
    
    
    private var firstReloadData:Bool = true
    /// 重新加载数据
    public func reloadData(){
        
        if let data = self.delegate?.kLineViewForData(self) {
            dataSource = data
        }
        
        if let kType = self.delegate?.kLineViewForType(self) {
            self.kType = kType
        }
        
        topChartView.data = getTopChartData()
        
        bottomChartView.data = getBottomChartData()
        
        topChartView.setVisibleXRange(minXRange: Double(showMinCount), maxXRange: Double(showMaxCount))
        
        bottomChartView.setVisibleXRange(minXRange: Double(showMinCount), maxXRange: Double(showMaxCount))
        
        if firstReloadData && showDefaultCount <= dataSource.count {
            topChartView.zoom(scaleX: CGFloat(showMaxCount)/CGFloat(showDefaultCount), scaleY: 0, x: 0, y: 0)
            bottomChartView.zoom(scaleX: CGFloat(showMaxCount)/CGFloat(showDefaultCount), scaleY: 0, x: 0, y: 0)
            firstReloadData = false
        }
     
        moveToLast(chartView: topChartView)
        
        moveToLast(chartView: bottomChartView)
        
        topChartView.notifyDataSetChanged()
        
        bottomChartView.notifyDataSetChanged()
    }
    
    /// 设置显示蜡烛图条数的最大最小值默认值
    public func setShowCount(min:Int, max:Int ,show:Int){
        showMinCount = min
        showMaxCount = max
        showDefaultCount = show
    }
    
    /// 设置k线时间间隔(影响x轴显示的时间，间隔12小时内显示HH:mm,大于12小时显示yyyy.MM.dd)
    public func setPeriod(_ period:UInt){
        self.period = period
    }
    
    /// 设置x轴显示的标签数
    public func setXAxisLabelCount(_ count:Int){
        topChartView.xAxis.labelCount = count
    }
    
    /// 设置顶部组合图与底部组合图的高度比重
    public func setHighly(topHeight:Double, bottomHeight:Double){
        self.topHighly = topHeight
        self.bottomHighly = bottomHeight
        
        topChartView.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(topHeight / (topHeight + bottomHeight))
        }
    }
    
    /// 设置顶部图表指标
    public func setKIndexTop(index:KIndexTop) {
        self.kIndexTop = index
        guard dataSource.count > 0 else {
            return
        }
        topChartView.data = getTopChartData()
        topChartView.notifyDataSetChanged()
    }
    
    /// 设置底部图表指标
    public func setKIndexBottom(index:KIndexBottom){
        self.kIndexBottom = index
        guard dataSource.count > 0 else {
            return
        }
        bottomChartView.data = getBottomChartData()
        bottomChartView.notifyDataSetChanged()
    }
    
    /// 开始加载动画
    public func startLoading(){
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    /// 结束加载动画
    public func stopLoading(){
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }
}

//MARK: - private func
extension KLineView {
    
    /// 初始化视图
    private func makeUI(){
        self.addSubviews([bottomChartView,topChartView,loadingView,infoView])
    }
    
    /// 创建约束
    private func makeConstraint(){
        
        topChartView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(topHighly/(topHighly+bottomHighly))
        }
        
        bottomChartView.snp.makeConstraints { (make) in
            make.top.equalTo(topChartView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        infoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    /// 创建手势
    private func makeGesture(){
        
        let topLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureAction(_:)))
        let bottomLongPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGestureAction(_:)))
        topChartView.addGestureRecognizer(topLongPress)
        bottomChartView.addGestureRecognizer(bottomLongPress)
    }
    
    
    /// 长按手势处理
    @objc private func handleLongPressGestureAction(_ recognizer: UILongPressGestureRecognizer){
        
        if recognizer.state == .began || recognizer.state == .changed
        {
            let topH = topChartView.getHighlightByTouchPoint(recognizer.location(in: self))
            let bottomH = bottomChartView.getHighlightByTouchPoint(recognizer.location(in: self))
            topChartView.highlightValue(topH, callDelegate: true)
            bottomChartView.highlightValue(bottomH, callDelegate: false)
        }else{
            topChartView.lastHighlighted = nil
            bottomChartView.lastHighlighted = nil
            topChartView.highlightValue(nil, callDelegate: true)
            bottomChartView.highlightValue(nil, callDelegate: false)
        }
    }
    
    /// 获取顶部视图数据
    private func getTopChartData() -> CombinedChartData? {
        
        guard dataSource.count > 0 else {
            return nil
        }
        
//        let topCombinedChartData = CombinedChartData()
        
        switch kType {
        case .kTimeLine:
            if let lineData = getTimeLineData(datas: dataSource) {
                topCombinedChartData.lineData = lineData
            }
            
            topCombinedChartData.candleData = nil
        case .kLine:
            // 蜡烛图数据
            if let candleData = getCandleData(datas: dataSource) {
                topCombinedChartData.candleData = candleData
            }
            // 折线线
            var lineSets = [LineChartDataSet]()
            // 收盘价隐藏线
            if let closeHiddenLineSet = getCandleClosePriceLineDataSet(datas: dataSource) {
                lineSets.append(closeHiddenLineSet)
            }
            //指标线
            switch kIndexTop {
            case .SMA://简单均线
                if let smaSets = getSMALineDataSet(datas: dataSource) {
                    lineSets += smaSets
                }
            case .EMA://指数均线
                if let emaSets = getEMALineDataSet(datas: dataSource) {
                    lineSets += emaSets
                }
            case .BOLL://布林轨道
                if let bollSets = getBOLLLineDataSet(datas: dataSource) {
                    lineSets += bollSets
                }
            }
            // 折线数据
            let lineData = LineChartData(dataSets: lineSets)
            topCombinedChartData.lineData = lineData
        }
        
        return topCombinedChartData
    }
    
    /// 获取底部视图数据
    private func getBottomChartData() -> CombinedChartData? {
        
        guard dataSource.count > 0 else {
            return nil
        }
        
//        let bottomCombinedChartData = CombinedChartData()
        
        switch kType {
        case .kTimeLine:
            if let barData = getBarData(datas: dataSource) {
                bottomCombinedChartData.barData = barData
            }
            bottomCombinedChartData.lineData = nil
        case .kLine:
            switch kIndexBottom {
            case .VOL:
                if let barData = getBarData(datas: dataSource) {
                    bottomCombinedChartData.barData = barData
                }
                bottomCombinedChartData.lineData = nil
            case .MACD:
                if let lineData = getMACDLineData(datas: dataSource) {
                    bottomCombinedChartData.lineData = lineData
                }
                if let barData = getMACDBarData(datas: dataSource) {
                    bottomCombinedChartData.barData = barData
                }
            case .KDJ:
                bottomCombinedChartData.barData = nil
                if let lineData = getKDJLineData(datas: dataSource){
                    bottomCombinedChartData.lineData = lineData
                }
            case .RSI:
                bottomCombinedChartData.barData = nil
                if let lineData = getKRSILineData(datas: dataSource){
                    bottomCombinedChartData.lineData = lineData
                }
            }
        }
        return bottomCombinedChartData
    }
    
}

//MARK: - ChartViewDelegate
extension KLineView : ChartViewDelegate {
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
        let srcMatrix = chartView.viewPortHandler.touchMatrix
        
        syncChart(chartViews: [topChartView,bottomChartView], touchMatrix: srcMatrix)
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
        let srcMatrix = chartView.viewPortHandler.touchMatrix
        
        syncChart(chartViews: [topChartView,bottomChartView], touchMatrix: srcMatrix)
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        infoView.isHidden = true
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        infoView.isHidden = false
        let viewModel = KLineInfoViewModel()
        viewModel.highlight = highlight
        viewModel.kLineModel = dataSource[Int(highlight.x)]
        viewModel.kType = kType
        viewModel.kIndexTop = kIndexTop
        viewModel.kIndexBottom = kIndexBottom
        viewModel.topHighly = topHighly
        viewModel.bottomHighly = bottomHighly
        infoView.refreshUI(viewModel: viewModel)
    }
}

extension KLineView : IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        if 0 <= index  &&  index < dataSource.count {
            if dataSource.count < 10 {
                if !(index == 1 || index == 4 || index == 7 ){
                    return ""
                }
            }
            var formatter = ""
            switch self.period {
            case 1...720:
                formatter = "HH:mm"
            default:
                formatter = "yyyy.MM.dd"
            }
            return UtilDate.toString(formatter: formatter, timeIntervalSince1970: Int(dataSource[index].timestamp))
        }
        return ""
    }
}
