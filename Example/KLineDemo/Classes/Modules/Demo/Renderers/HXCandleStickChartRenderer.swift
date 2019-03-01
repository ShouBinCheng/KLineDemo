//
//  HXCandleStickChartRenderer.swift
//  kLineDemo
//
//  Created by Kevin on 2018/4/23.
//  Copyright © 2018年 Kevin. All rights reserved.
//

import UIKit
import Charts

class HXCandleStickChartRenderer: CandleStickChartRenderer {

    private func isInBoundsX(entry e: ChartDataEntry, dataSet: IBarLineScatterCandleBubbleChartDataSet) -> Bool
    {
        let entryIndex = dataSet.entryIndex(entry: e)
        return Double(entryIndex) < Double(dataSet.entryCount) * animator.phaseX
    }
    
    /// 重写该方法修改高亮原点的位置
    override func drawHighlighted(context: CGContext, indices: [Highlight]) {
        guard
            let dataProvider = dataProvider,
            let candleData = dataProvider.candleData
            else { return }
        
        context.saveGState()
        
        for high in indices
        {
            guard
                let set = candleData.getDataSetByIndex(high.dataSetIndex) as? ICandleChartDataSet,
                set.isHighlightEnabled
                else { continue }
            
            guard let e = set.entryForXValue(high.x, closestToY: high.y) as? CandleChartDataEntry else { continue }
            
            if !isInBoundsX(entry: e, dataSet: set)
            {
                continue
            }
            
            let trans = dataProvider.getTransformer(forAxis: set.axisDependency)
            
            context.setStrokeColor(set.highlightColor.cgColor)
            context.setLineWidth(set.highlightLineWidth)
            
            if set.highlightLineDashLengths != nil
            {
                context.setLineDash(phase: set.highlightLineDashPhase, lengths: set.highlightLineDashLengths!)
            }
            else
            {
                context.setLineDash(phase: 0.0, lengths: [])
            }
            
            //let lowValue = e.low * Double(animator.phaseY)
            //let highValue = e.high * Double(animator.phaseY)
            //let y = (lowValue + highValue) / 2.0
            let y = e.close
            
            let pt = trans.pixelForValues(x: e.x, y: y)
            
            high.setDraw(pt: pt)
            
            // draw the lines
            drawHighlightLines(context: context, point: pt, set: set)
        }
        
        context.restoreGState()
    }
}
