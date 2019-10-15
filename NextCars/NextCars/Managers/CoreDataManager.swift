//
//  CoreDataManager.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/16/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    // Singleton Instance
    static let sharedInstance = CoreDataManager()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "NextCars")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Manage Application Data

extension CoreDataManager {
    
    // MARK: Create Objects
    func createDealership(_ dealershipInfo: DealershipInfo, complete: ((Dealership) -> ())?) {
        Dealership.create(with: dealershipInfo, into: persistentContainer.viewContext, complete: { dealership in
            complete?(dealership)
        })
    }
    
    func createVehicle(_ vehicleInfo: VehicleInfo, dealership: Dealership) {
        Vehicle.create(with: vehicleInfo, dealer: dealership, into: persistentContainer.viewContext)
    }
    
    // MARK: - Fetch Data
    func fetchData<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> [T]? {
        
        // Fetching data from local store
        let request: NSFetchRequest<T> = NSFetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: NSStringFromClass(T.self), in: persistentContainer.viewContext)
        request.entity = entity
        
        // Apply Sorting
        if let descriptors = sortDescriptors {
            request.sortDescriptors = descriptors
        }
        
        // Apply Predicate
        if let requestPredicate = predicate {
            request.predicate = requestPredicate
        }
        
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            if results.count > 0 {
                return results
            }
        } catch let error as NSError {
            print("error \(error.localizedDescription), \(error.userInfo)")
            abort()
        }
        return nil
    }
}
