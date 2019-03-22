//
//  CALayerExtensions.swift
//  Chart
//
//  Created by Vojko Vladimir on 3/20/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import QuartzCore

extension CALayer {
    func removeAllSublayers(_ callback: ((CALayer)->())? = nil) {
        sublayers?.forEach({
            if let callback = callback {
                callback($0)
            } else {
                $0.removeFromSuperlayer()
            }
        })
    }
}
