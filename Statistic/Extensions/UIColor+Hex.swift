//
//  UIColor+Hex.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/11/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Initialization
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    convenience init(rgb: UInt32) {
        self.init(rgba: rgb << 8 | 0x000000FF)
    }
    
    convenience init(rgba: UInt32) {
        self.init(red: CGFloat((rgba & 0xFF000000) >> 24) / 255.0,
                  green: CGFloat((rgba & 0x00FF0000) >> 16) / 255.0,
                  blue: CGFloat((rgba & 0x0000FF00) >> 8) / 255.0,
                  alpha: CGFloat((rgba & 0x000000FF)) / 255.0)
    }
}
