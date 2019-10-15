//
//  RootViewController.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/16/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    private var dataManager: DataManager?
    private var currentViewController: UIViewController?
    
    init(_ dataManager: DataManager) {
        
        self.dataManager = dataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load Home View Controller
        let homeViewController = NavigationManager.getHomeScreen()
        homeViewController.configure(with: dataManager!)
        loadViewController(homeViewController)
    }
    
    func showDealershipView() {
        let dealershipViewController = NavigationManager.getDealershipScreen()
        dealershipViewController.viewModel = DealershipListViewModel(dataManager: dataManager!)
        let navigationController = UINavigationController(rootViewController: dealershipViewController)
        loadViewController(navigationController)
    }
    
    func showvehiclesScreen() {
        let dealershipViewController = NavigationManager.getDealershipScreen()
        dealershipViewController.viewModel = DealershipListViewModel(dataManager: dataManager!)
        let navigationController = UINavigationController(rootViewController: dealershipViewController)
        loadViewController(navigationController)
    }
    
    private func loadViewController(_ viewController: UIViewController) {
        
        if let previous = currentViewController {
            previous.willMove(toParent: nil)
            previous.view.removeFromSuperview()
            previous.removeFromParent()
        }
        
        addChild(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        currentViewController = viewController
    }
}
