//
//  DataManager.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/16/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import Foundation

class DataManager: NSObject {
    
    private var coreDataManager: CoreDataManager?
    private var apiManager: APIManager?
    
    init(_ coreDataManager: CoreDataManager, apiManager: APIManager) {
        self.coreDataManager = coreDataManager
        self.apiManager = apiManager
    }
    
    func fetchAllData(_ complete: @escaping (_ success: Bool)->()) {
        
       guard !UserDefaults.standard.bool(forKey: Constants.UserDefaults.isDataDownloaded) else {
            // Report completion
            complete(true)
            return
        }
        
        // Fetch DataSet Details
        DispatchQueue.global(qos: .background).async {
            self.getDataSetId({ (dataSetId, error) in
                guard error == nil, let dataSet = dataSetId else {
                    // Inform Failure
                    DispatchQueue.main.async {
                        complete(false)
                    }
                    return
                }
                
                // Fetch Vehicles On Data Set
                self.fetchVehiclesIds(dataSet, complete: { (vehicleIds, error) in
                    guard error == nil else {
                        // Inform Failure
                        DispatchQueue.main.async {
                            complete(false)
                        }
                        return
                    }
                    // Fetch and Create Vehicle Objects
                    self.fetchAllVehicleInfos(dataSet, vehicleIds: vehicleIds, complete: { dealerships in
                        
                        var completionCount = 0
                        
                        for (dealerId, vehicles) in dealerships {
                            self.fetchDealershipInfo(dataSet, dealerId: dealerId, complete: { (dealershipInfo, error) in
                                completionCount += 1
                                guard error == nil else {
                                    if completionCount == dealerships.count {
                                        // Set Data Status
                                        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isDataDownloaded)
                                        complete(true)
                                    }
                                    return
                                }
                                
                                DispatchQueue.main.async {
                                    
                                
                                self.coreDataManager?.createDealership(dealershipInfo!) { dealership in
                                       
                                       
                                        for vehicle in vehicles {
                                            self.coreDataManager?.createVehicle(vehicle, dealership: dealership)
                                        }
                                        // Save Data
                                        self.saveData()
                                    }
                                    if completionCount == dealerships.count {
                                        // Set Data Status
                                        UserDefaults.standard.set(true, forKey: Constants.UserDefaults.isDataDownloaded)
                                        complete(true)
                                    }
                                }
                            })
                        }
                    })
                })
            })
        }
    }
    
    private func getDataSetId(_ complete: @escaping (_ dataSetId: String?, _ error: APIError?) -> ()) {
        
        let dataSetEndPoint = Constants.API.baseURL + Constants.API.endPoint.dataset.rawValue
        
        apiManager?.getDataSet(dataSetEndPoint, complete: { (success, dataSetId, error) in
            guard success, let id = dataSetId else {
                return
            }
            complete(id, nil)
        })
    }
    
    private func fetchVehiclesIds(_ dataSetId: String, complete: @escaping (_ vehicleIds: [Int64], _ error: APIError?) -> ()) {
        let vehiclesEndPoint = Constants.API.baseURL + String(format: Constants.API.endPoint.vehicles.rawValue, dataSetId)
        
        apiManager?.fetchVehicles(vehiclesEndPoint, complete: { (success, vehicleIds, error) in
            guard success else {
                complete([], error)
                return
            }
            
            // Return Vehicle Ids
            complete(vehicleIds, nil)
        })
    }
    
    private func fetchAllVehicleInfos(_ dataSet: String, vehicleIds: [Int64], complete: @escaping ([Int64: [VehicleInfo]]) -> ()) {
        // Fetch vehicle info and Save
        var completionCount = 0
        var dealerShips = [Int64: [VehicleInfo]]()
        for id in vehicleIds {
            fetchVehicleInfo(dataSet, vehicleId: id) { (vehicleInfo, error) in
                completionCount += 1
                guard error == nil else {
                    if completionCount == vehicleIds.count {
                        complete(dealerShips)
                    }
                    return
                }
                
                guard let dealerId = vehicleInfo?.dealerId else {
                    if completionCount == vehicleIds.count {
                        complete(dealerShips)
                    }
                    return
                }
                
                // Hold Vehicle Info
                dealerShips[dealerId, default: []].append(vehicleInfo!)
                if completionCount == vehicleIds.count {
                    complete(dealerShips)
                }
            }
        }
    }
    
    private func fetchVehicleInfo(_ dataSetId: String, vehicleId: Int64, complete: @escaping (_ vehicleInfo: VehicleInfo?, _ error: APIError?) -> ()) {
        let vehicleEndPoint = Constants.API.baseURL + String(format: Constants.API.endPoint.vehicleInfo.rawValue, dataSetId, vehicleId)
        apiManager?.fetchVehicleInfo(vehicleEndPoint, complete: { (success, vehicleInfo, error) in
            guard success else {
                complete(nil, error)
                return
            }
            // Return Vehicle Info
            complete(vehicleInfo, nil)
        })
    }
    
    private func fetchDealershipInfo(_ dataSetId: String, dealerId: Int64, complete: @escaping (_ dealershipInfo: DealershipInfo?, _ error: APIError?) -> ()) {
        let dealershipEndPoint = Constants.API.baseURL + String(format: Constants.API.endPoint.dealershipInfo.rawValue, dataSetId, dealerId)
        
        apiManager?.fetchDealershipInfo(dealershipEndPoint, complete: { (success, dealershipInfo, error) in
            guard success else {
                complete(nil, error)
                return
            }
            // Return DealershipInfo
            complete(dealershipInfo, nil)
        })
    }
    
    private func fetchDealerships(_ dataSetId: String, complete: @escaping (_ dealerships: [DealershipInfo], _ error: APIError?) -> ()) {
        let dealershipsEndPoint = Constants.API.baseURL + String(format: Constants.API.endPoint.allData.rawValue, dataSetId)
        
        apiManager?.fetchDealerships(dealershipsEndPoint, complete: { (success, dealerships, error) in
            guard success else {
                complete([], error)
                return
            }
            
            // Return Dealership Info
            complete(dealerships, nil)
        })
    }
    
    private func saveDealershipsToCoreData(_ dealerships: [DealershipInfo], complete: (_ success: Bool) -> ()) {
        // Save Dealerships
        for dealership in dealerships {
            self.coreDataManager?.createDealership(dealership, complete: nil)
        }
        // Save Data
        self.saveData()
    }
    
    func saveData() {
        // Save CoreData changes
        self.coreDataManager?.saveContext()
    }
}

extension DataManager {
    
    func getDealershipData(id: Int64? = nil) -> [Dealership]? {
        
        var predicate: NSPredicate?
        if let dealershipId = id {
            predicate = NSPredicate(format: "id = %d", dealershipId)
        }
        guard let dealerships = coreDataManager?.fetchData(Dealership.self, predicate: predicate, sortDescriptors: nil) else {
            return nil
        }
        return dealerships
    }
}
