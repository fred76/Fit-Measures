//
//  PageMenuIntro.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 19/05/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit

class PageMenuIntro : UIViewController, CAPSPageMenuDelegate {
    
    
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    var introController : UIViewController!
    var gDPRController : UIViewController!
    var healthController : UIViewController!
    var icloudController : UIViewController!
    var parameters: [CAPSPageMenuOption] = []
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if introController != nil {
            let controller : AllertViewIntro = (storyboard.instantiateViewController(withIdentifier: "AllertIntroID") as! AllertViewIntro)
            controller.pageMenu = self
            controllerArray.append(controller)
        }
        if gDPRController != nil {
            let controller : GDPRController = (storyboard.instantiateViewController(withIdentifier: "GDPRControllerID") as! GDPRController)
            controller.pageMenu = self
            controllerArray.append(controller)
        }
        if healthController != nil {
            let controller : HealthController = (storyboard.instantiateViewController(withIdentifier: "HealtControllerID") as! HealthController)
            controller.pageMenu = self
            controllerArray.append(controller)
        } 
        parameters  = [ .hideTopMenuBar(true) ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        self.addChild(pageMenu!)
        
        self.view.addSubview(pageMenu!.view)
         
        pageMenu!.delegate = self
        
        self.pageMenu?.didMove(toParent: self)
    }
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        pageMenu?.moveToPage(index)
    }
    
    
}
