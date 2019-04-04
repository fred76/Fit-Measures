//
//  DataManagerAdMob.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 02/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import GoogleMobileAds

extension DataManager {
    
    // MARK: - Add-Mobs:
    
    func AddMobs() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }

}
