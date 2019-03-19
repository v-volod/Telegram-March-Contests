//
//  ChartView.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/10/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//
import UIKit
import QuartzCore

private let defaultLineWidth: CGFloat = 1
private let defaultAxisLineWidth: CGFloat = 0.5

private let animationDuration: TimeInterval = 0.3

private let defaultYAxisCount: Int = 5

@IBDesignable
open class ChartView: UIView {
    
    override open class var layerClass: AnyClass { return ChartLayer.self }
    
    open override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    @IBInspectable public var lineWidth: CGFloat = defaultLineWidth {
        didSet {
            chartLayer.lineWidth = lineWidth
        }
    }
    
    private var _yAxisCount: Int = defaultYAxisCount
    @IBInspectable public var yAxisCount: Int {
        get {
            return _yAxisCount
        }
        set {
            _yAxisCount = max(0, newValue)
            update()
        }
    }
    
    private var _axisLineWidth: CGFloat = defaultAxisLineWidth {
        didSet {
            axisLayer.lineWidth = _axisLineWidth
            axisLayer.setNeedsDisplay()
        }
    }
    @IBInspectable public var axisLineWidth: CGFloat {
        get {
            return _axisLineWidth
        }
        set {
            _axisLineWidth = max(0, defaultAxisLineWidth)
        }
    }

    @IBInspectable public var axisLineColor: UIColor = UIColor.gray {
        didSet {
            axisLayer.strokeColor = axisLineColor.cgColor
            axisLayer.setNeedsDisplay()
        }
    }
    
    private let chartLayer = ChartLayer()
    private let axisLayer = AxisLayer()
    
    public var chart: Chart {
        get {
            return chartLayer.chart
        }
    }
    
    public var range: Range<Int> {
        return chartLayer.range
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initLayers()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initLayers()
    }
    
    private func initLayers() {
        layer.addSublayer(axisLayer)
        layer.addSublayer(chartLayer)
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        update(chart: .interfaceBuilderChart)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayerFrames()
    }
    
    private func updateLayerFrames() {
        axisLayer.frame = bounds
        chartLayer.frame = bounds
        
        update()
    }
    
    public func update() {
        update(chart: chart, range: range)
    }
    
    public func update(chart: Chart) {
        update(chart: chart, range: chart.x.range)
    }
    
    public func update(range: Range<Int>) {
        update(chart: chart, range: range)
    }
    
    public func update(chart: Chart, range: Range<Int>) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))
        
        axisLayer.update(count: yAxisCount)
        
        chartLayer.lineWidth = lineWidth
        chartLayer.setChart(chart, range: range)
        
        CATransaction.commit()
    }
    
}
