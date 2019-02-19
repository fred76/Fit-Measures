//
//  CustomViewDoubleColor.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 26/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class CustomViewDoubleColor: UIView {
    
    override func layoutSubviews() { setup() } // "layoutSubviews" is best
   
    func setup() { 
        
        self.backgroundColor = StaticClass.alertViewBackgroundColor
        
        let r : CGFloat = 16.0
        
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius:r)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
       self.layer.mask = mask
        
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.bounds.width, height: 32)).cgPath
        layer.fillColor = StaticClass.alertViewHeaderColor.cgColor
        self.layer.insertSublayer(layer, at: 0)
    
       
        
}
}
