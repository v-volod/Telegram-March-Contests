//
//  AxisLayer.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/19/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import QuartzCore

class AxisLayer: CAShapeLayer {
    let linesPath = UIBezierPath()
    
    func update(count: Int) {
        linesPath.removeAllPoints()
        
        let yStep = bounds.size.height / CGFloat(count)
        
        var y: CGFloat!
        
        for index in 0..<count {
            y = bounds.size.height - CGFloat(index) * yStep
            
            let linePath = UIBezierPath()
            linePath.move(to: CGPoint(x: bounds.minX, y: y))
            linePath.addLine(to: CGPoint(x: bounds.maxX, y: y))
            
            linesPath.append(linePath)
        }
        
        path = linesPath.cgPath
    }
}
