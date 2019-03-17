//
//  CAShapeLayer+Track.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/16/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import QuartzCore

extension CAShapeLayer {
    func setTrack(x: CGFloat, width: CGFloat) {
        let innerPath = UIBezierPath(rect: CGRect(origin: CGPoint(x: x, y: 0), size: CGSize(width: width, height: bounds.height)))
        let outerPath = UIBezierPath(rect: bounds)
        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true
        
        path = outerPath.cgPath
        fillRule = .evenOdd
    }
}
