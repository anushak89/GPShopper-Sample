//
//  NavigationManager.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/16/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import UIKit

class NavigationManager: NSObject {
    
    class func getHomeScreen() -> HomeViewController {
        let storyboard = UIStoryboard(name: Constants.UI.Stroryboard.main.rawValue, bundle: Bundle.main)
        let homeViewController = storyboard.instantiateInitialViewController() as! HomeViewController
        return homeViewController
    }
    
    class func getDealershipScreen() -> DealershipViewController {
        let storyboard = UIStoryboard(name: Constants.UI.Stroryboard.dealership.rawValue, bundle: Bundle.main)
        let dealershipViewController = storyboard.instantiateInitialViewController() as! DealershipViewController
        return dealershipViewController
    }
    
    class func getVehiclesScreen() -> VehiclesViewController {
        let storyboard = UIStoryboard(name: Constants.UI.Stroryboard.dealership.rawValue, bundle: Bundle.main)
        let vehiclesViewController = storyboard.instantiateViewController(withIdentifier: Constants.UI.ViewController.vehicle.rawValue) as! VehiclesViewController
        return vehiclesViewController
    }
}
