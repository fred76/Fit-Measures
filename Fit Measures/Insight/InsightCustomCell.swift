//
//  InsightCustomCell.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 25/05/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class InsightCustomCell: UICollectionViewCell {
	
	@IBOutlet weak var bgView: CustomViewDoubleColor!
	
	@IBOutlet weak var imageBodyPart: UIImageView!
	@IBOutlet weak var labelName: UILabel!
	@IBOutlet weak var labelValue: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		bgView.headerHeight = 16
		bgView.r = 8 
	}
	
}
