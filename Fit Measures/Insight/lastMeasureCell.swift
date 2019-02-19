//
//  lastMeasureCell.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 02/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit

class lastMeasureCell: UITableViewCell {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var imageCell: UIImageView!
    
    @IBOutlet var methodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
