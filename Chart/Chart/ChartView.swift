//
//  ChartView.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/10/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit

public protocol ChartViewDataSource: class {
    func numberOfLines() -> Int
    
    func valuesFoxXAxis() -> [Int]
    func valuesForYAxisForLine(_ line: Int) -> [Int]
    
    func colorForLine(_ line: Int) -> UIColor
}

@IBDesignable
public class ChartView: UIView {
    
    open weak var dataSource: ChartViewDataSource?

    override public func draw(_ rect: CGRect) {
        guard let dataSource = dataSource else { return }
        
        let numberOfLines = dataSource.numberOfLines()
        let xCoordinates = dataSource.valuesFoxXAxis()
        
        guard numberOfLines > 0 && xCoordinates.count > 0 else { return }
        
        var maxValue: Int = dataSource.valuesForYAxisForLine(0).first!
        
        for line in 0..<numberOfLines {
            maxValue = max(dataSource.valuesForYAxisForLine(line).max()!, maxValue)
        }
        
        let xStep = rect.width / CGFloat(xCoordinates.count)
        let yStep = rect.height / CGFloat(maxValue)
        
        
        for line in 0..<numberOfLines {
            let color = dataSource.colorForLine(line)
            color.setStroke()
            color.setFill()
            
            let linePath = UIBezierPath()
            
            let yCoordinates = dataSource.valuesForYAxisForLine(line)
            
            for index in 0..<xCoordinates.count {
                let x = CGFloat(index) * xStep
                let y = rect.height - yStep * CGFloat(yCoordinates[index])
                let point = CGPoint(x: x, y: y)
                
                if index == 0 {
                    linePath.move(to: point)
                } else {
                    linePath.addLine(to: point)
                }
            }
            
            linePath.stroke()
        }
    }

}
