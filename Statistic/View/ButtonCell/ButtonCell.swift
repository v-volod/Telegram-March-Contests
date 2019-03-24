//
//  ButtonCell.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/24/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: class {
    func buttonCellDidPressed(_ cell: ButtonCell)
}

class ButtonCell: UITableViewCell {
    @IBOutlet weak var button: UIButton!
    
    weak var delegate: ButtonCellDelegate?
    
    @IBAction func didPressed(_ sender: UIButton) {
        delegate?.buttonCellDidPressed(self)
    }
}
