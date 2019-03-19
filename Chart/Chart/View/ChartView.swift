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

private let labelOffset = CGFloat(2)

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
            axisLinesLayer.lineWidth = _axisLineWidth
            axisLinesLayer.setNeedsDisplay()
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

    @IBInspectable public var axisLineColor: UIColor = .gray {
        didSet {
            axisLinesLayer.strokeColor = axisLineColor.cgColor
            axisLinesLayer.setNeedsDisplay()
        }
    }
    
    private var _axisTextSize: CGFloat = UIFont.systemFontSize {
        didSet {
//            axisLayer.textSize = _axisTextSize
//            axisLayer.setNeedsDisplay()
        }
    }
    @IBInspectable public var axisTextSize: CGFloat {
        get {
            return _axisTextSize
        }
        set {
            _axisTextSize = max(0, newValue)
        }
    }
    @IBInspectable public var axisTextColor: UIColor = .gray {
        didSet {
//            axisLayer.textColor = axisTextColor
//            axisLayer.setNeedsDisplay()
        }
    }
    
    private let chartLayer = ChartLayer()
    
    private let axisLinesLayer = CAShapeLayer()
    private let axisTitlesLayer = CALayer()
    
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
        layer.addSublayer(axisLinesLayer)
        layer.addSublayer(chartLayer)
        layer.addSublayer(axisTitlesLayer)
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
        axisLinesLayer.frame = bounds
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
        
        updateAxis(chart: chart, range: range)
        
        chartLayer.lineWidth = lineWidth
        chartLayer.setChart(chart, range: range)
        
        CATransaction.commit()
    }
    
    private func updateAxis(chart: Chart, range: Range<Int>) {
        axisTitlesLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let maxValue = chart.maxValue(in: range)
        let maxRoundedValue = Int(10 * (CGFloat(maxValue) / 10.0).rounded(.up))
        
        let count = yAxisCount
        let valueStep = count == 0 ? 0 : maxRoundedValue / (count + 1)
        
        let yStep = bounds.size.height / CGFloat(count)
        let font = UIFont.systemFont(ofSize: axisTextSize)
        
        var y: CGFloat!
        
        let linesPath = UIBezierPath()
        for index in 0..<count {
            y = bounds.size.height - CGFloat(index) * yStep
            
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: bounds.minX, y: y))
            linePath.addLine(to: CGPoint(x: bounds.maxX, y: y))
            
            linesPath.append(linePath)
            
            let textLayer = CATextLayer()
            textLayer.rasterizationScale = UIScreen.main.scale
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.string = "\(index * valueStep)"
            textLayer.foregroundColor = axisTextColor.cgColor
            textLayer.font = font
            textLayer.fontSize = axisTextSize

            let size = textLayer.preferredFrameSize()

            y = y - size.height - labelOffset

            textLayer.frame = CGRect(origin: CGPoint(x: bounds.minX, y: y), size: size)

            axisTitlesLayer.addSublayer(textLayer)
        }
        
        axisLinesLayer.path = linesPath.cgPath
    }
    
}
