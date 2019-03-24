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
    
    public lazy var range: Range<Int> = (x.count - x.count / 4)..<x.count
    
    public init(x: [Int], lines: [Graph]) {
        self.x = x
        self.lines = lines
    }
}

extension Chart {
    public func maxValue(in range: Range<Int>) -> Int {
        return lines.filter({ $0.isEnabled }).compactMap { $0.values.max(in: range) }.max() ?? 0
    }
}

extension Chart : Equatable {
    public static func == (lhs: Chart, rhs: Chart) -> Bool {
        return lhs.x == rhs.x && lhs.lines == rhs.lines
    }
    
}
