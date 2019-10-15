//
//  Services.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/15/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import Foundation

enum APIError: String, Error {
    case noNetwork = "No Network"
    case invalidURL = "Not a valid URL"
    case dataError = "Data not in required format"
}

protocol APIService {
    func getDataSet(_ endPoint: String, complete: @escaping (_ success: Bool, _ dataSetId: String?, _ error: APIError? )->())
    func fetchDealerships(_ endPoint: String, complete: @escaping (_ success: Bool, _ dealerships: [DealershipInfo], _ error: APIError? )->())
    func fetchPhoto(_ photoURL: String, complete: @escaping (Data?, APIError?) -> Void)
}

