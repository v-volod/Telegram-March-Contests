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
    @IBOutlet weak var chartSlider: ChartRangeSlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartSlider.addTarget(self, action: #selector(rangeDidChaged(sender:forEvent:)), for: .valueChanged)
        
        let repository = ChartRepository()
        repository.load { [weak self] result in
            guard let controller = self else { return }
            
            switch result {
            case let .success(data):
                if let chart = data.first {
                    let percent: CGFloat = 0.75
                    let count = CGFloat(chart.x.count)
                    let startIndex = Int((percent * count).rounded(.toNearestOrAwayFromZero))
                    let endIndex = chart.x.count
                    let range = startIndex ..< endIndex
                    controller.chartView.update(chart: chart, range: range)
                    controller.chartSlider.chart = chart
                    controller.chartSlider.range = range
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
    
    @objc func rangeDidChaged(sender: ChartRangeSlider, forEvent event: UIEvent) {
        chartView.update(range: sender.range)
    }
}
