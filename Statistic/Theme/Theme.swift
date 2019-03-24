//
//  Theme.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/24/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit

enum Theme {
    case light
    case dark
    
    var mainColor: UIColor {
        switch self {
        case .light:
            return .lightMain
        case .dark:
            return .nightMain
        }
    }
    
    var backColor: UIColor {
        switch self {
        case .light:
            return .lightBack
        case .dark:
            return .nightBack
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    var navigationBarStyle: UIBarStyle {
        switch self {
        case .light:
            return .default
        case .dark:
            return .black
        }
    }
    
    var actionTitle: String {
        switch self {
        case .light:
            return "Switch to Night Mode"
        case .dark:
            return "Switch to Day Mode"
        }
    }
    
    static var current: Theme = .light {
        didSet {
            current.apply()
        }
    }
    
    static func toggle() {
        current = current == .light ? .dark : .light
    }

    func apply() {
        UINavigationBar.appearance().barStyle = navigationBarStyle
        UINavigationBar.appearance().barTintColor = mainColor
        
        UITableView.appearance().backgroundColor = backColor
        UITableView.appearance().separatorColor = backColor
        
        UITableViewCell.appearance().backgroundColor = mainColor
        
        LineCell.appearance().titleTextColor = textColor
        ButtonCell.appearance().isSelected = self == .dark
        
        for window in UIApplication.shared.windows {
            for view in window.subviews {
                view.removeFromSuperview()
                window.addSubview(view)
            }
        }
    }
}

extension UIColor {
    static let nightMain = UIColor(rgb: 0x22303F)
    static let nightBack = UIColor(rgb: 0x18222D)
    
    static let lightMain = UIColor.white
    static let lightBack = UIColor(rgb: 0xEFEFF4)
}
