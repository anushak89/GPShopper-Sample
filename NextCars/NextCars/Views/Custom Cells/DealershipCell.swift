//
//  DealershipCell.swift
//  NextCars
//
//  Created by Anusha Kottiyal on 7/17/19.
//  Copyright © 2019 NextDigit. All rights reserved.
//

import UIKit

class DealershipCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var cellViewModel: DealershipCellViewModel? {
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
        nameLabel.text = ""
        idLabel.text = ""
    }
    func updateCellDisplay() {
        nameLabel.text = cellViewModel?.name
        idLabel.text = cellViewModel?.id
    }
}
