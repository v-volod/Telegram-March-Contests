//
//  ChartView.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/10/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//
import UIKit

private let defaultLineWidth: CGFloat = 1

@IBDesignable
open class ChartView: UIView {
    
    override open class var layerClass: AnyClass { return ChartLayer.self }
    
    open override var frame: CGRect {
        didSet {
            update()
        }
    }
    
    @IBInspectable
    public var lineWidth: CGFloat = defaultLineWidth {
        didSet {
            chartLayer.lineWidth = lineWidth
        }
    }
    
    private var chartLayer: ChartLayer { return layer as! ChartLayer }
    
    public var chart: Chart {
        get {
            return chartLayer.chart
        }
    }
    
    public var range: Range<Int> {
        return chartLayer.range
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        update(chart: .interfaceBuilderChart)
    }
    
    public func update(chart: Chart) {
        update(chart: chart, range: chart.x.range)
    }
    
    public func update(range: Range<Int>) {
        update(chart: chart, range: range)
    }
    
    public func update(chart: Chart, range: Range<Int>) {
        chartLayer.frame = bounds
        chartLayer.lineWidth = lineWidth
        chartLayer.setChart(chart, range: range)
    }
    
}
