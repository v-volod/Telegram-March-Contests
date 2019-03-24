//
//  ChartsController.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/23/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit
import Chart

class ChartsController: UITableViewController {

    private let repository = ChartRepository()
    private var data: [Chart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(ChartCell.self)
        tableView.register(LineCell.self)
        tableView.register(ButtonCell.self)
        
        repository.load { [weak self] result in
            guard let controller = self else { return }
            
            switch result {
            case let .success(data):
                controller.data = data
                controller.tableView.reloadData()
                
                for (section, chart) in data.enumerated() {
                    for row in 0..<chart.lines.count {
                        controller.tableView.selectRow(at: IndexPath(row: row + 1, section: section), animated: false, scrollPosition: .none)
                    }
                }
                
                break
            case let .failure(error):
                let alert = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                controller.present(alert, animated: true, completion: nil)
                break
            }
        }
    }

}

// MARK: - Table view data source

extension ChartsController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == numberOfSections(in: tableView) - 1) {
            return 1
        }
        
        return 1 + data[section].lines.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section < data.count) {
            if (indexPath.row == 0) {
                let cell = tableView.dequeue(ChartCell.self, for: indexPath)
                cell.show(data[indexPath.section])
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeue(LineCell.self, for: indexPath)
                cell.show(data[indexPath.section].lines[indexPath.row - 1])
                return cell
            }
        } else {
            let cell = tableView.dequeue(ButtonCell.self, for: indexPath)
            cell.button.setTitle(Theme.current.actionTitle, for: .normal)
            cell.delegate = self
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section < data.count ? "Chart \(section + 1)" : nil
    }
}

// MARK: - Table view delegate

extension ChartsController {
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == numberOfSections(in: tableView) - 1 || indexPath.row == 0 ? nil : indexPath
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == numberOfSections(in: tableView) - 1 || indexPath.row == 0 ? nil : indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? ChartCell {
            data[indexPath.section].lines[indexPath.row - 1].isEnabled = true
            cell.update()
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as? ChartCell {
            data[indexPath.section].lines[indexPath.row - 1].isEnabled = false
            cell.update()
        }
    }
}

// MARK: - ChartCellDelegate -

extension ChartsController : ChartCellDelegate {
    func chartCell(_ cell: ChartCell, rangeDidChanged range: Range<Int>) {
        if let indexPath = tableView.indexPath(for: cell) {
            data[indexPath.section].range = range
        }
    }
}

// MARK: - ButtonCellDelegate -

extension ChartsController : ButtonCellDelegate {
    func buttonCellDidPressed(_ cell: ButtonCell) {
        Theme.toggle()
        
        cell.button.setTitle(Theme.current.actionTitle, for: .normal)
    }
}
