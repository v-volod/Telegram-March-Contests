//
//  ChartView.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/10/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit

@IBDesignable
public class ChartView: UIView {

    override public func draw(_ rect: CGRect) {
        UIColor.black.setFill()
        
        let linePath = UIBezierPath(rect: rect)
        linePath.move(to: CGPoint(x: rect.minX, y: rect.minY))
        linePath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        linePath.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        linePath.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        linePath.stroke()
    }

}
