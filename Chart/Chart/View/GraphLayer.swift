//
//  GraphLayer.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/12/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit

open class GraphLayer: CAShapeLayer {
    public var graph: Graph?
    public var linePath = UIBezierPath()
    
    public func setGraph(_ graph: Graph, size: CGSize, in bounds: CGRect) {
        self.graph = graph
        
        linePath.removeAllPoints()
        linePath.addGraph(graph, size: size, in: bounds)
        
        path = linePath.cgPath
        fillColor = UIColor.clear.cgColor
        strokeColor = graph.color.cgColor
    }
    
}

extension UIBezierPath {
    
    func addGraph(_ graph: Graph, size: CGSize, in bounds: CGRect) {
        var x: CGFloat = bounds.origin.x
        var y: CGFloat!
        
        var point: CGPoint!
        
        for (index, value) in graph.values.enumerated() {
            y = bounds.height - size.height * CGFloat(value)
            
            point = CGPoint(x: x, y: y)
            
            if index == 0 {
                move(to: point)
            } else {
                addLine(to: point)
            }
            
            x += size.width
        }
    }
    
}
