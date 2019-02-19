//
//  NavController.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 20/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit

class NavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        
        if let topVC = viewControllers.last {
            //return the status property of each VC, look at step 2
            return topVC.preferredStatusBarStyle
        }
        
        return .default

}
}
