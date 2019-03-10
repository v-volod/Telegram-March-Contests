//
//  Result.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/10/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(data: T)
    case failure(error: Error)
}
