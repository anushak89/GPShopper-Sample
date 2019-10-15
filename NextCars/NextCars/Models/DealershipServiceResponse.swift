//
//  DealershipServiceResponse.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/15/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import Foundation

struct Result: Codable {
    var dealers = [DealershipInfo]()
}

struct DealershipInfo: Codable {
    var dealerId: Int64
    var name: String
}

struct VehicleInfo: Codable {
    var vehicleId: Int64
    var year: Int16
    var make: String
    var model: String
    var dealerId: Int64
}
