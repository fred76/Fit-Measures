//
//  DatamanagerAlertView.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 02/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit
extension DataManager {
    // MARK: - AllertView:
    
    func allertWithParameter(title: String,message: String, viecontroller : UIViewController){
        let allertWeight = UIAlertController(title: title,
                                             message: message,
                                             preferredStyle: .alert)
        allertWeight.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        viecontroller.present(allertWeight, animated: true, completion: nil)
    }
    
    
    
    func allertWeight(viecontroller : UIViewController){
        let Weight = getLastMeasureAvailable()!.weight
        let allertWeight = UIAlertController(title: loc("Noitce"),
                                             message: "Last Weight used \n \(Weight) Kg",
            preferredStyle: .alert)
        allertWeight.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viecontroller.present(allertWeight, animated: true, completion: nil)
    }
    func showTopLevelAlert(title : String, body : String, alertActionDoIt : UIAlertAction) {
        let alertController = UIAlertController (title: title , message: body, preferredStyle: .alert)
        alertController.addAction(alertActionDoIt)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
