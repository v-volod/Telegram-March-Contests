//
//  LineCell.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/24/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit
import Chart

class LineCell: UITableViewCell {
    
    @objc dynamic var titleTextColor: UIColor? = .black {
        didSet {
            titleLabel?.textColor = titleTextColor
        }
    }
    
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = titleTextColor
        colorView.layer.cornerRadius = 2.0
    }
    
    func show(_ line: Graph) {
        colorView.backgroundColor = line.color
        titleLabel.text = line.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        accessoryType = selected ? .checkmark : .none
    }
    
}
