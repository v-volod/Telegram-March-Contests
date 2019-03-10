//
//  ChartRepository.swift
//  Statistic
//
//  Created by Vojko Vladimir on 3/10/19.
//  Copyright © 2019 Vojko Vladimir. All rights reserved.
//

import Foundation

private let DefaultFileName = "chart_data"
private let FileType = "json"

public let NSSerializationErrorDomain = "NSSerializationErrorDomain"
public let NSSerializationErrorFailed = 1

class ChartRepository {
    typealias ChartsCompletion = (_ result: Result<[Chart]>)->()
    
    func load(fileName: String = DefaultFileName, completion: @escaping ChartsCompletion) {
        if let path = Bundle.main.path(forResource: fileName, ofType: FileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let array = json as? [[String: Any]] {
                    let charts = array.compactMap { Chart(dict: $0) }
                    completion(.success(data: charts))
                } else {
                    let error = NSError(domain: NSSerializationErrorDomain,
                                        code: NSSerializationErrorFailed,
                                        userInfo: nil)
                    completion(.failure(error: error))
                }
            } catch {
                completion(.failure(error: error))
            }
        }
    }
}
