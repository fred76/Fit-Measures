//
//  IngredientsUIView.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 08/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class LabelProductUIView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var ingredientsLabel: UIImageView!
    @IBOutlet var labelImage: UIImageView!
    @IBOutlet var labelLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ComminInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ComminInit()
        fatalError("init(coder:) has not been implemented")
        
        
    }
    
    private func ComminInit() {
        Bundle.main.loadNibNamed("IngredientsUIView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
