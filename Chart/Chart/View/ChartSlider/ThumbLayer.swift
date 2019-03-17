//
//  ThumbLayer.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/16/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import QuartzCore

private let arrowWidth = CGFloat(2)

class ThumbLayer: CAShapeLayer {
    lazy var leftArrowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        addSublayer(layer)
        return layer
    }()
    
    lazy var rightArrowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        addSublayer(layer)
        return layer
    }()
    
    var arrowColor: CGColor?
    
    func setSize(_ size: CGSize, border borderWidth: CGFloat, handle handleWidth: CGFloat, corner cornerRadius: CGFloat) {
        anchorPoint = .zero
        bounds = CGRect(origin: anchorPoint, size: size)
        
        let innerOrigin = CGPoint(x: handleWidth, y: borderWidth)
        let innerSize = CGSize(width: size.width - 2 * handleWidth, height: size.height - 2 * borderWidth)
        let innerPath = UIBezierPath(rect: CGRect(origin: innerOrigin, size: innerSize))
        
        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true
        
        path = outerPath.cgPath
        fillRule = .evenOdd
        
        let arrowWidth = handleWidth / 4
        let handleSize = CGSize(width: arrowWidth, height: min(bounds.height, handleWidth))
        
        let arrowX = (handleWidth - arrowWidth) / 2
        let arrowY = (bounds.height - handleSize.height) / 2
        
        let leftArrowPosition = CGPoint(x: arrowX, y: arrowY)
        let rightArrowPosition = CGPoint(x: bounds.width - arrowX - handleSize.width, y: arrowY)
       
        leftArrowLayer.frame = CGRect(origin: leftArrowPosition, size: handleSize)
        leftArrowLayer.setArrow(forward: false, color: arrowColor)
        
        rightArrowLayer.frame = CGRect(origin: rightArrowPosition, size: handleSize)
        rightArrowLayer.setArrow(forward: true, color: arrowColor)
    }
}

fileprivate extension CAShapeLayer {
    func setArrow(forward isForward: Bool, color: CGColor?) {
        strokeColor = color
        fillColor = UIColor.clear.cgColor
        lineWidth = arrowWidth
        lineJoin = .round
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: isForward ? bounds.minX : bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: isForward ? bounds.maxX : bounds.minX, y: bounds.midY))
        path.addLine(to: CGPoint(x: isForward ? bounds.minX : bounds.maxX, y: bounds.maxY))
        self.path = path.cgPath
    }
}
