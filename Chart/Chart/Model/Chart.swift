//
//  Chart.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/12/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation

public class Chart {
    public static let empty = Chart(x: [], lines: [])
    
    public let x: [Int]
    public let lines: [Graph]
    
    public init(x: [Int], lines: [Graph]) {
        self.x = x
        self.lines = lines
    }
}

extension Chart {
    public func maxValue(in range: Range<Int>) -> Int {
        return lines.compactMap { $0.values.max(in: range) }.max() ?? 0
    }
}
