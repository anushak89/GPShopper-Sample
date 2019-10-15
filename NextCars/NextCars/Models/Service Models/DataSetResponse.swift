//
//  DataSetResponse.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/16/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import Foundation

struct DataSet: Codable {
    var id: String
    private enum CodingKeys: String, CodingKey {
        case id = "datasetId"
    }
}
