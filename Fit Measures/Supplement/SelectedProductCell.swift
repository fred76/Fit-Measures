//
//  SelectedProductCell.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 14/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class SelectedProductCell: UITableViewCell {
    
    @IBOutlet var productName: UILabel!
    @IBOutlet var carbs: UILabel!
    @IBOutlet var fat: UILabel!
    @IBOutlet var pro: UILabel!
    @IBOutlet var imageProduct: UIImageView!
    @IBOutlet var dailyQuantity: UILabel!
    @IBOutlet var endScortDate: UILabel!
    @IBOutlet var weekAnDays: UILabel!
    @IBOutlet var circleView: CirclePieView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
