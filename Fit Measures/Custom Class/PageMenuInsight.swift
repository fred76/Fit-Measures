//
//  PageMenuInsight.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 18/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class PageMenuInsight: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    @IBOutlet var contentView: UIView!
    var parameters: [CAPSPageMenuOption] = []
     
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Insight"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
		
		AddMobManager.shared.injectInterstitial()
		
    }
	
	override func viewWillAppear(_ animated: Bool) {
		
		
		let storyboardInsight = UIStoryboard(name: "InsightStoryboard", bundle: nil)
		
		let controllerInsightGirths : InsightReusableController = (storyboardInsight.instantiateViewController(withIdentifier: "InsightReusableControllerID") as! InsightReusableController)
		_ = StaticClass.didLoadView(v: controllerInsightGirths)
		controllerInsightGirths.parentNavigationController = self.navigationController
		controllerInsightGirths.title = "Girths Graph"
		controllerInsightGirths.graphSelection = .Girths
		if DataManager.shared.bodyMeasurementExist() {
			controllerArray.append(controllerInsightGirths)
		}
		
		let controllerInsightSkinFolds : InsightReusableController = (storyboardInsight.instantiateViewController(withIdentifier: "InsightReusableControllerID") as! InsightReusableController)
		_ = StaticClass.didLoadView(v: controllerInsightSkinFolds)
		controllerInsightSkinFolds.parentNavigationController = self.navigationController
		controllerInsightSkinFolds.title = "SkinFolds Graph"
		if DataManager.shared.plicheMeasurementExist(){
		controllerInsightSkinFolds.graphSelection = .SkinFolds
			controllerArray.append(controllerInsightSkinFolds)
		}
		
		let controllerInsightGirthsOverSkinfolds : InsightReusableController = (storyboardInsight.instantiateViewController(withIdentifier: "InsightReusableControllerID") as! InsightReusableController)
		_ = StaticClass.didLoadView(v: controllerInsightGirthsOverSkinfolds)
		controllerInsightGirthsOverSkinfolds.parentNavigationController = self.navigationController
		controllerInsightGirthsOverSkinfolds.title = "Girths over SkinFolds"
		controllerInsightGirthsOverSkinfolds.graphSelection = .GirthsOverSkinFolds
		if DataManager.shared.bodyMeasurementExist() && DataManager.shared.plicheMeasurementExist() {
			controllerArray.append(controllerInsightGirthsOverSkinfolds)
		}
		
		let controllerPhoto : PhotoGallery = (storyboardInsight.instantiateViewController(withIdentifier: "PhotoGallery") as! PhotoGallery)
		controllerPhoto.parentNavigationController = self.navigationController
		_ = StaticClass.didLoadView(v: controllerPhoto)
		controllerPhoto.title = "Photos" 
		controllerArray.append(controllerPhoto)
			
		
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
		self.addChild(pageMenu!)
		pageMenu?.delegate = self
		self.contentView.addSubview(pageMenu!.view)
		self.pageMenu?.didMove(toParent: self)
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		controllerArray = []
	}
	
	func didMoveToPage(_ controller: UIViewController, index: Int) {
		if index > 0 {
			AddMobManager.shared.showInterstitialWhenSelect(viewcontroller: self, upperLimit: 3, index: index)
		}
	}
}

