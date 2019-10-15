//
//  DealershipViewController.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/16/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import UIKit

class DealershipViewController: UITableViewController {

    var viewModel: DealershipListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure View
        configureView()
        // Configure Used Car List ViewModel
        configureViewModel()
    }
    
    func configureView() {
        self.title = "Dealers"
    }
    
    func configureViewModel() {
        
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 0.3
                    })
                } else {
                    UIView.animate(withDuration: 0.2, animations: {
                        self?.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        // Fetch all the dealerships
        viewModel.fetchDealerships()
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table view data source and Delegates

extension DealershipViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DealershipCell", for: indexPath) as? DealershipCell else { fatalError("Cell not designed")}
        cell.cellViewModel = viewModel.getCellViewModel(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.UI.dealershipRowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Show Vehicles for the selected dealer
        let vehiclesViewController = NavigationManager.getVehiclesScreen()
        let cellViewModel = viewModel.getCellViewModel(at: indexPath)
        
        if let dealers = viewModel.dataManager.getDealershipData(id: Int64(cellViewModel.id)), dealers.count > 0 {
            vehiclesViewController.viewModel = VehicleListViewModel(dealer: dealers.first!)
        }
        
        self.navigationController?.pushViewController(vehiclesViewController, animated: true)
    }
}
