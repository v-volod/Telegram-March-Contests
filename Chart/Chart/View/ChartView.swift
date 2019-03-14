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
        set {
            chartLayer.frame = bounds
            chartLayer.lineWidth = lineWidth
            chartLayer.setChart(newValue, range: newValue.x.range)
        }
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        chart = .interfaceBuilderChart
    }
    
}
