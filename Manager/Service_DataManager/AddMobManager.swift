//
//  AddMobManager.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 25/05/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import GoogleMobileAds
class AddMobManager: NSObject {
	
	static let shared = AddMobManager()
	
	var interstitial: GADInterstitial!
	var showInterstitial : Bool = false
	var bannerView: GADBannerView!
	
	let GandCBannerStringTest : String = "ca-app-pub-3940256099942544/2934735716"
	let GandCInterstitialTest : String = "ca-app-pub-3940256099942544/4411468910"
	let GandCBannerStringProduction : String = "ca-app-pub-9833367902957453/8227301931"
	let GandCInterstitialProduction : String = "ca-app-pub-9833367902957453/4404866177"
	
	func AddMobs() {
		GADMobileAds.sharedInstance().start(completionHandler: nil) 
	}
	
}

extension AddMobManager : GADBannerViewDelegate {
	
	func addBanner(v: UIView, controller: UIViewController){
		if  DataManager.shared.purchasedGirthsAndSkinfilds() {
			print("something purchased")} else {
			bannerView = GADBannerView(adSize: kGADAdSizeBanner)
			addBannerViewToView(bannerView, v: v)
			bannerView.adUnitID = GandCBannerStringProduction
			bannerView.rootViewController = controller
			bannerView.load(GADRequest())
			bannerView.delegate = self}
	}
	
	func addBannerViewToView(_ bannerView: GADBannerView, v: UIView) {
		bannerView.translatesAutoresizingMaskIntoConstraints = false
		
		v.addSubview(bannerView)
		if #available(iOS 11.0, *) {
			positionBannerAtBottomOfSafeArea(bannerView, v: v)
		}
		else {
			positionBannerAtBottomOfView(bannerView, v: v)
		}
	}
	
	@available (iOS 11, *)
	func positionBannerAtBottomOfSafeArea(_ bannerView: UIView, v: UIView) {
		let guide: UILayoutGuide = v.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate(
			[bannerView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
			 bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)]
		)
	}
	
	func positionBannerAtBottomOfView(_ bannerView: UIView, v: UIView) {
		// Center the banner horizontally.
		v.addConstraint(NSLayoutConstraint(item: bannerView,
										   attribute: .centerX,
										   relatedBy: .equal,
										   toItem: v,
										   attribute: .centerX,
										   multiplier: 1,
										   constant: 0))
		// Lock the banner to the top of the bottom layout guide.
		v.addConstraint(NSLayoutConstraint(item: bannerView,
										   attribute: .bottom,
										   relatedBy: .equal,
										   toItem: v.safeAreaLayoutGuide.bottomAnchor,
										   attribute: .top,
										   multiplier: 1,
										   constant: 0))
	}
	
}

extension AddMobManager : GADInterstitialDelegate {
	
	func showInterstitialWhenSelect(viewcontroller : UIViewController){
		let randomBool = Bool.random()
		print("randomBool \(randomBool)")
		if randomBool{
			
			if  DataManager.shared.purchasedGirthsAndSkinfilds() { print("something purchased") } else {
				if interstitial.isReady {
					interstitial.present(fromRootViewController: viewcontroller)
				} else {
					print("Ad wasn't ready")
				}
			}
		}
	}
	
	func injectInterstitial () {
		interstitial = createAndLoadInterstitial()
	}
	
	 func createAndLoadInterstitial() -> GADInterstitial {
		let interstitial = GADInterstitial(adUnitID: GandCInterstitialProduction)
		interstitial.delegate = self
		interstitial.load(GADRequest())
		return interstitial
	}
	
	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
		interstitial = createAndLoadInterstitial()
	}
//
//	func isShouldShowInterstitial() -> Bool{
//		if showInterstitial {
//			return true
//		} else {
//			return false
//		}
//	}
//	
//	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//		showInterstitial = true
//		 createAndLoadInterstitial()
//	}
	
	 
	
}
