//
//  Chart.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/10/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation
import Chart

extension Chart {
    
    convenience init?(dict: [String: Any]) {
        guard let columns = dict[Key.columns] as? [[Any]],
            let colors = dict[Key.colors] as? [String: String] else { return nil }
        
        var xValues: [Int]?
        var y0Values: [Int]?
        var y1Values: [Int]?
        
        columns.forEach { (columnValues) in
            guard let columnName = columnValues.first as? String,
                let column = Column.init(rawValue: columnName),
                let values = Array.init(columnValues.dropFirst()) as? [Int] else { return }
            
            switch (column) {
            case .x:
                xValues = values
            case .y0:
                y0Values = values
            case .y1:
                y1Values = values
            }
        }
        
        guard let y0Color = colors[Column.y0.rawValue],
            let y1Color = colors[Column.y1.rawValue],
            let xCoordinates = xValues,
            let y0Coordinates = y0Values,
            let y1Coordinates = y1Values else { return nil }
        
        let lines = [Graph(name: "y0", color: UIColor(hex: y0Color)!, values: y0Coordinates),
                     Graph(name: "y1", color: UIColor(hex: y1Color)!, values: y1Coordinates)]
        self.init(x:xCoordinates, lines:lines)
    }
}

private enum Key {
    static let types = "types"
    static let colors = "colors"
    static let columns = "columns"
}

private enum Column: String, CaseIterable {
    case x
    case y0
    case y1
}
