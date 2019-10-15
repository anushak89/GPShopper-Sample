//
//  DealershipListViewModel.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/16/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import Foundation

class DealershipListViewModel {
    
    // To fetch and manage Dealers Data
    let dataManager: DataManager
    
    // Closures to inform actions
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    // To hold all cell viewModels with relevant data
    private var cellViewModels = [DealershipCellViewModel]() {
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
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func fetchDealerships() {
        self.isLoading = true
        guard let dealerships = dataManager.getDealershipData() else {
            self.isLoading = false
            self.alertMessage = "Data not available"
            return
        }
        self.isLoading = false
        self.processFetchedListings(dealerships)
    }
    
    private func processFetchedListings(_ dealerships: [Dealership]) {
        var viewModels = [DealershipCellViewModel]()
        for dealer in dealerships {
            viewModels.append(createCellViewModel(dealer))
        }
        self.cellViewModels = viewModels
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> DealershipCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(_ dealer: Dealership) -> DealershipCellViewModel {
        return DealershipCellViewModel(id: "\(dealer.id)", name: dealer.name ?? "Unknown")
    }
}
