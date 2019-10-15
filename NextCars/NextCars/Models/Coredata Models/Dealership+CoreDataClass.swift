//
//  Dealership+CoreDataClass.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/15/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Dealership)
public class Dealership: NSManagedObject {

    // MARK: - Object Creation
    class func create(with dealershipInfo: DealershipInfo, into context: NSManagedObjectContext, complete: ((Dealership) -> ())?) {
        let dealership = NSEntityDescription.insertNewObject(forEntityName: Constants.CoreData.entityName.dealership.rawValue, into: context) as! Dealership
        dealership.id = dealershipInfo.dealerId
        dealership.name = dealershipInfo.name

        // Return dealership if configured
        complete?(dealership)
    }
}
