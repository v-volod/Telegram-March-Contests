//
//  Graph.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/12/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit

public class Graph {
    public let name: String
    public let color: UIColor
    public let values: [Int]
    
    public init(name: String, color: UIColor, values: [Int]) {
        self.name = name
        self.color = color
        self.values = values
    }
    
    public func maxValue(in range: Range<Int>) -> Int {
        return values[range].max() ?? 0
    }
}

extension Graph: Equatable {
    public static func == (lhs: Graph, rhs: Graph) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Graph: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
