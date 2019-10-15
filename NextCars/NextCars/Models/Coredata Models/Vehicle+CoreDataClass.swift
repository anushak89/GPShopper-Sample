//
//  Vehicle+CoreDataClass.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/15/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Vehicle)
public class Vehicle: NSManagedObject {
    // MARK: - Object Creation
    class func create(with vehicleInfo: VehicleInfo, dealer: Dealership, into context: NSManagedObjectContext) {
        
        let vehicle = NSEntityDescription.insertNewObject(forEntityName: Constants.CoreData.entityName.vehicle.rawValue, into: context) as! Vehicle
        vehicle.id = vehicleInfo.vehicleId
        vehicle.year = vehicleInfo.year
        vehicle.make = vehicleInfo.make
        vehicle.model = vehicleInfo.model
        vehicle.dealer = dealer
    }
}
