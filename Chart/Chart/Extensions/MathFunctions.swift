//
//  MathFunctions.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/16/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation

func bound<T: Comparable>(_ value: T, min minValue: T, max maxValue: T) -> T {
    return min(max(value, minValue), maxValue)
}
