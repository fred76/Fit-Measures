//
//  PageMenuBodyMeasurment.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 18/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class PageMenuBodyMeasurment: UIViewController {
    
    @IBOutlet var contentView: UIView!
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    var parameters: [CAPSPageMenuOption] = []
    
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @discardableResult func didLoadView(v: UIViewController)->UIView? {
        guard let view = v.view else {
            return nil
        } 
        return view
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboardGirth = UIStoryboard(name: "GirthStoryboard", bundle: nil)
        let controllerGirth : UIViewController = (storyboardGirth.instantiateViewController(withIdentifier: "MeasureMainController") as? GirthsMainController)!
        controllerGirth.title = "Body Girths"
       _ = StaticClass.didLoadView(v: controllerGirth)
        controllerArray.append(controllerGirth)
        
        let storyboardSkinFold = UIStoryboard(name: "SkinFoldStoryboard", bundle: nil)
        let controllerJackson_7 : PlicheMoethodController = (storyboardSkinFold.instantiateViewController(withIdentifier: "PlicheMoethodController") as? PlicheMoethodController)!
        controllerJackson_7.title = "Jackson & Polloc 7"
        _ = StaticClass.didLoadView(v: controllerJackson_7)
        controllerJackson_7.plicheMethod = .jackson_7
        controllerArray.append(controllerJackson_7)
        
        let controllerJackson_3 : PlicheMoethodController = (storyboardSkinFold.instantiateViewController(withIdentifier: "PlicheMoethodController") as? PlicheMoethodController)!
        _ = StaticClass.didLoadView(v: controllerJackson_3)
        if UserDefaultsSettings.biologicalSexSet == "Male" {
            controllerJackson_3.title = "Jackson & Polloc 3"
            controllerJackson_3.plicheMethod = .jackson_3_Man
            controllerArray.append(controllerJackson_3)
        } else {
            controllerJackson_3.title = "Jackson & Polloc 3"
            controllerJackson_3.plicheMethod = .jackson_3_Woman
            controllerArray.append(controllerJackson_3)
        }
        
        let controllerSloan : PlicheMoethodController = (storyboardSkinFold.instantiateViewController(withIdentifier: "PlicheMoethodController") as? PlicheMoethodController)!
        _ = StaticClass.didLoadView(v: controllerSloan)
        if UserDefaultsSettings.biologicalSexSet == "Male" {
            controllerSloan.title = "Sloan"
            controllerSloan.plicheMethod = .sloanMen
            controllerArray.append(controllerSloan)
        } else {
            controllerSloan.title = "Sloan"
            controllerSloan.plicheMethod = .sloanWoman
            controllerArray.append(controllerSloan)
        }
        
        let controllerDurnin : PlicheMoethodController = (storyboardSkinFold.instantiateViewController(withIdentifier: "PlicheMoethodController") as? PlicheMoethodController)!
        _ = StaticClass.didLoadView(v: controllerDurnin)
        controllerDurnin.title = "Durnin e Womersley"
        controllerDurnin.plicheMethod = .DurninMan
        controllerArray.append(controllerDurnin)
        
        parameters  = [
            .scrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .viewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .selectionIndicatorColor(UIColor.orange),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .menuHeight(40.0),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .centerMenuItems(true),
            .enableHorizontalBounce(false),
            .addBottomMenuHairline(true),
            .titleTextSizeBasedOnMenuItemWidth(true),
            .scrollAnimationDurationOnMenuItemTap(500)
        ]
		
         pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height), pageMenuOptions: parameters)
		pageMenu?.currentOrientationIsPortrait = true
        self.addChild(pageMenu!)
        self.contentView.addSubview(pageMenu!.view)
        self.pageMenu?.didMove(toParent: self)
    }
    
   
}


