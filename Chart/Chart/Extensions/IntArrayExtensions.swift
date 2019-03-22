//
//  IntArrayExtensions.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/14/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation

extension Array {
    var range: Range<Int> {
        return 0..<count
    }
}

extension Array where Element == Int {
    func max(in range: Range<Int>, opt: Int = 0) -> Int {
        return self[range].max() ?? opt
    }
}
