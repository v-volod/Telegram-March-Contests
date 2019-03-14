//
//  ChartLayer.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/13/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation

private let defaultLineWidth: CGFloat = 1

class ChartLayer: CALayer {
    public var chart: Chart = .empty
    public var range: Range<Int> = .zero
    
    public var lineWidth: CGFloat = defaultLineWidth {
        didSet {
            lineLayers.forEach {
                $0.lineWidth = lineWidth
            }
        }
    }
    
    var lineLayers: [GraphLayer] {
        return sublayers?.compactMap({ $0 as? GraphLayer }) ?? []
    }
    
    public func setChart(_ chart: Chart, range: Range<Int>) {
        self.chart = chart
        self.range = range
      
        let maxValue = chart.maxValue(in: range)
        
        let xLength = bounds.width / CGFloat(range.count)
        let yLength = bounds.height / CGFloat(maxValue)
        
        let size = CGSize(width: xLength, height: yLength)
        let origin = CGPoint(x: -CGFloat(range.startIndex) * size.width, y: 0)
        
        let graphBounds = CGRect(origin: origin, size: bounds.size)
        
        for line in chart.lines {
            let lineLayer = GraphLayer()
            lineLayer.lineWidth = lineWidth
            
            addSublayer(lineLayer)
            
            lineLayer.setGraph(line, size: size, in: graphBounds)
        }
    }
}
