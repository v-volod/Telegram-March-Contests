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
            let colors = dict[Key.colors] as? [String: String],
            let columnTypes = dict[Key.types] as? [String: String] else { return nil }
        
        var columnValues: [String: [Int]] = [:]
        var columnColors: [String: UIColor] = [:]
        
        columns.forEach {
            if let column = $0.first as? String, let values = Array.init($0.dropFirst()) as? [Int] {
                columnValues[column] = values
            }
        }
        
        colors.forEach {
            columnColors[$0] = UIColor(hex: $1)!
        }
        
        guard let xColumn = (columnTypes.first { $0.value == ColumnType.x.rawValue })?.key else { return nil }
        
        guard let x = columnValues[xColumn] else { return nil }
        
        var lines: [Graph] = []
        
        let lineNames = columnTypes.keys.filter({ columnTypes[$0] == ColumnType.line.rawValue })
        
        for name in lineNames.sorted() {
            if let values = columnValues[name], let color = columnColors[name] {
                lines.append(Graph(name: name, color: color, values: values))
            }
        }
        
        self.init(x: x, lines: lines)
    }
}

private enum Key {
    static let types = "types"
    static let colors = "colors"
    static let columns = "columns"
    static let names = "names"
}

private enum ColumnType: String, CaseIterable {
    case x
    case line
}
