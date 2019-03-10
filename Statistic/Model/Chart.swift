//
//  Chart.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/10/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation

struct Chart {
    let xCoordinates: [Int]
    let yCoordinates: [[Int]]
    let colors: [String]
    
    init?(dict: [String: Any]) {
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
        
        self.colors = [y0Color, y1Color]
        self.xCoordinates = xCoordinates
        self.yCoordinates = [y0Coordinates, y1Coordinates]
    }
}

extension Chart {
    
    func xAt(_ index: Int) -> Int {
        return xCoordinates[index]
    }
    
    func yAt(_ index: Int, forLine line: Int) -> Int {
        return yCoordinates[line][index]
    }
    
    func colorForLine(_ line: Int) -> String {
        return colors[line]
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
