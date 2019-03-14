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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
        
        let repository = ChartRepository()
        repository.load { [weak self] result in
            guard let controller = self else { return }
            
            switch result {
            case let .success(data):
                if let chart = data.first {
                    controller.chartView.chart = chart
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

    @objc func didTap(_ sender: UITapGestureRecognizer) {
        
    }
}
