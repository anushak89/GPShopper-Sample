//
//  Vehicle+CoreDataProperties.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/17/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//
//

import Foundation
import CoreData


extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle")
    }

    @NSManaged public var id: Int64
    @NSManaged public var make: String?
    @NSManaged public var model: String?
    @NSManaged public var year: Int16
    @NSManaged public var dealer: Dealership?
}
