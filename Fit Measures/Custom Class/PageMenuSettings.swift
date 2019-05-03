//
//  PageMenuSettings.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 02/05/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit

class PageMenuSettings : UIViewController {
    
    
    @IBOutlet var contentView: UIView!
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    var parameters: [CAPSPageMenuOption] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let storyboardInsight = UIStoryboard(name: "SettingStoryboard", bundle: nil)
        let controllerInsight : SettingsMainTableViewController = (storyboardInsight.instantiateViewController(withIdentifier: "Settings") as! SettingsMainTableViewController)
        _ = StaticClass.didLoadView(v: controllerInsight)
        controllerInsight.parentNavigationController = self.navigationController
        controllerInsight.title = "Settings"
        
        
        controllerArray.append(controllerInsight)
        let controllerPhoto : ShoppingController = (storyboardInsight.instantiateViewController(withIdentifier: "Shopping") as! ShoppingController)
        controllerPhoto.parentNavigationController = self.navigationController
        
        controllerPhoto.title = "Shopping 🛒"
        controllerArray.append(controllerPhoto)
        
        
        parameters  = [
            .scrollMenuBackgroundColor(UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)),
            .viewBackgroundColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)),
            .selectionIndicatorColor(UIColor.orange),
            .bottomMenuHairlineColor(UIColor(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 13.0)!),
            .menuHeight(40.0),
            .menuItemWidth(self.view.frame.width/2),
            .centerMenuItems(true),
            .enableHorizontalBounce(true),
            .addBottomMenuHairline(true),
            .titleTextSizeBasedOnMenuItemWidth(true),
            .scrollAnimationDurationOnMenuItemTap(500)
        ]
        
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height), pageMenuOptions: parameters)
        self.addChild(pageMenu!)
        self.contentView.addSubview(pageMenu!.view)
        
        self.pageMenu?.didMove(toParent: self)
    }
    
    
}

