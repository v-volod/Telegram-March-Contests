//
//  IntExtensions.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/22/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation

extension Int {
    func step(max: Int) -> Int {
        guard self > max else { return self }

        var count = max

        while (self - count) % (count - 1) != 0 {
            count = count - 1
        }

        return (self - count) / (count - 1)
    }
}
