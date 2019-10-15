//
//  Constants.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/15/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import UIKit

struct Constants {
    
    struct API {
        static let baseURL = "<REMOVED>"
        
        enum endPoint: String {
            case dataset = "datasetId"
            case vehicles = "%@/vehicles"
            case vehicleInfo = "%@/vehicles/%d"
            case dealershipInfo = "%@/dealers/%d"
            case allData = "%@/cheat"
        }
    }
    struct UserDefaults {
        static let isDataDownloaded = "isDataDownloaded"
    }
    struct CoreData {
        enum entityName: String {
            case dealership = "Dealership"
            case vehicle = "Vehicle"
        }
    }
    struct UI {
        enum Stroryboard: String {
            case main = "Main"
            case dealership = "Dealership"
        }
        
        enum ViewController: String {
            case vehicle = "VehiclesViewController"
        }
        
        static let dealershipRowHeight: CGFloat = 200
        static let vehicleRowHeight: CGFloat = 400
    }
}
