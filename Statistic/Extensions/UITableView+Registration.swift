//
//  UITableView+Registration.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/24/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func  register<T: UITableViewCell>(_ cellClass: T.Type) {
        register(UINib(nibName: cellClass.identifier, bundle: nil), forCellReuseIdentifier: cellClass.identifier)
    }
    
    func  dequeue<T: UITableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath) as! T
    }
}
