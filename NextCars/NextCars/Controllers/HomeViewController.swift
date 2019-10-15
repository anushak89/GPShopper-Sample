//
//  HomeViewController.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/15/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private var dataManager: DataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up activity indicator
        self.setupActivityIndicator()
    }
    
    func configure(with dataManager: DataManager) {
        self.dataManager = dataManager
    }
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
    }
    
    @IBAction func exploreData(_ sender: UIButton) {
        activityIndicator.startAnimating()
        dataManager?.fetchAllData({ (success) in
            self.activityIndicator.stopAnimating()
            guard success else {
                self.showAlert("Could not fetch data at this time. Please try again later.")
                return
            }
            
            // Navigate to Dealership ViewController
            AppDelegate.shared.rootViewController.showDealershipView()
        })
    }
    
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
