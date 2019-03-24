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
    
    open override var frame: CGRect {
        didSet {
            pointLayer.frame = CGRect(origin: .zero, size: bounds.size)
        }
    }
    
    open override func layoutSublayers() {
        super.layoutSublayers()
        
        pointLayer.frame = CGRect(origin: .zero, size: bounds.size)
    }
    
    private lazy var pointLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        addSublayer(layer)
        return layer
    }()
    
    public var linePath = UIBezierPath()
    
    public func update(_ graph: Graph, size: CGSize, in bounds: CGRect, selected selectedIndex: Int?) {
        self.graph = graph
        
        let animation = CABasicAnimation()
        animation.fromValue = path
        
        linePath.removeAllPoints()
        linePath.addGraph(graph, size: size, in: bounds)
        
        path = linePath.cgPath
        fillColor = UIColor.clear.cgColor
        strokeColor = graph.color.cgColor
        
        animation.toValue = path
        
        if let index = selectedIndex {
            let value = CGFloat(graph.values[index])
            let pointSize = CGSize(width: 4, height: 4)
            let path = UIBezierPath(ovalIn: CGRect(origin: .zero, size: pointSize))
            
            pointLayer.fillColor = UIColor.clear.cgColor
            pointLayer.fillColor = graph.color.cgColor
            pointLayer.strokeColor = graph.color.cgColor
            pointLayer.isHidden = false
            pointLayer.lineWidth = 2
            pointLayer.path = path.cgPath
            pointLayer.frame = CGRect(origin: CGPoint(x: bounds.minX + CGFloat(index) * size.width - pointSize.width / 2,
                                                      y: bounds.height - size.height * value - pointSize.height / 2),
                                      size: pointSize)
//            pointLayer.path = UIBezierPath(rect: pointLayer.frame).cgPath
            
        } else {
            pointLayer.isHidden = true
        }
        
        add(animation, forKey: #keyPath(path))
        
        needsDisplay()
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
