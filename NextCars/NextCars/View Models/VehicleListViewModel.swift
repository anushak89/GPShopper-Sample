//
//  VehicleListViewModel.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/16/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import Foundation

class VehicleListViewModel {
    
    // To fetch and manage Vehicle Data
    let dealership: Dealership
    
    // Closures to inform actions
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    // To hold all cell viewModels with relevant data
    private var cellViewModels = [VehicleCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    init(dealer: Dealership) {
        self.dealership = dealer
    }
    
    func fetchVehicles() {
        self.isLoading = true
        guard let vehicles = dealership.vehicles?.allObjects as? [Vehicle] else {
            self.isLoading = false
            self.alertMessage = "Data not available"
            return
        }
        self.isLoading = false
        self.processFetchedListings(vehicles)
    }
    
    private func processFetchedListings(_ vehicles: [Vehicle]) {
        var viewModels = [VehicleCellViewModel]()
        for vehicle in vehicles {
            viewModels.append(createCellViewModel(vehicle))
        }
        self.cellViewModels = viewModels
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> VehicleCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(_ vehicle: Vehicle) -> VehicleCellViewModel {
        return VehicleCellViewModel(id: "\(vehicle.id)", year: "\(vehicle.year)", make: vehicle.make ?? "", model: vehicle.model ?? "", dealerId: "\(dealership.id)")
    }
}
