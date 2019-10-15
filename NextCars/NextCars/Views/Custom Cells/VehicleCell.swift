//
//  VehicleCell.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/17/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import UIKit

class VehicleCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var dealerIdLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var cellViewModel: VehicleCellViewModel? {
        didSet {
            updateCellDisplay()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset Data
        makeLabel.text = ""
        yearLabel.text = ""
        modelLabel.text = ""
        dealerIdLabel.text = ""
        idLabel.text = ""
    }
    func updateCellDisplay() {
        idLabel.text = cellViewModel?.id
        makeLabel.text = cellViewModel?.make
        yearLabel.text = cellViewModel?.year
        modelLabel.text = cellViewModel?.model
        dealerIdLabel.text = cellViewModel?.dealerId
    }
}
