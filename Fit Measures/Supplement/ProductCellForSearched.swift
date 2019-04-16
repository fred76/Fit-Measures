//
//  ProductCellForSearched.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 04/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class ProductCellForSearched: UITableViewCell {

    @IBOutlet var productName: UILabel!
    @IBOutlet var brand: UILabel!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var ingredient: UILabel!
    @IBOutlet var imageProduct: UIImageView!
    
    var request : Request?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func more(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) 
    }

}



