//
//  ViewController.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/10/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import UIKit
import Chart

class ViewController: UIViewController {
    
    @IBOutlet weak var chartView: ChartView!
    
    var chart: Chart? {
        didSet {
            chartView.setNeedsDisplay()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.dataSource = self
        
        let repository = ChartRepository()
        repository.load { [weak self] result in
            guard let controller = self else { return }
            
            switch result {
            case let .success(data):
                if let chart = data.first {
                    controller.chart = chart
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

// MARK: - ChartViewDataSource -

extension ViewController: ChartViewDataSource {
    func numberOfLines() -> Int {
        return chart?.yCoordinates.count ?? 0
    }
    
    func valuesFoxXAxis() -> [Int] {
        return chart?.xCoordinates ?? []
    }
    
    func valuesForYAxisForLine(_ line: Int) -> [Int] {
        return chart?.yCoordinates[line] ?? []
    }
    
    func colorForLine(_ line: Int) -> UIColor {
        if let colorHex = chart?.colors[line], let color = UIColor(hex: colorHex) {
            return color
        }
        
        fatalError()
    }
    
    
}
