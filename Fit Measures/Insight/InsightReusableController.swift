//
//  InsightReusableController.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 25/05/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit
//import GoogleMobileAds

class InsightReusableController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,/*GADInterstitialDelegate,*/ UICollectionViewDelegateFlowLayout {
	
	var graphSelection = GraphSelection.Girths
	
	
	@IBOutlet weak var labelINFO: UILabel!
	
	@IBOutlet weak var myCollectionView: UICollectionView!
	var measureTitle : [String] = []
	
	var imageArray : [String] = []
	var unitMeasurWeight:String!
	var unitMeasurLenght:String!
	var measureArray : [Double] = []
	var parentNavigationController : UINavigationController?
	
	//var interstitial: GADInterstitial!
	var showInterstitial : Bool = false
	
	var plicheMethod : String!
	var plicheArray : [Double] = []
	var plicheTitle : [String] = []
	var plicheArrayThumb : [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		myCollectionView.delegate = self
		myCollectionView.dataSource = self
		
		unitMeasurLenght = " " + UserDefaultsSettings.lenghtUnitSet
		unitMeasurWeight = " " + UserDefaultsSettings.weightUnitSet
		
		//		interstitial = createAndLoadInterstitial()
		//		showInterstitial = true
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		AppStoreReviewManager.requestReviewIfAppropriate()
		AddMobManager.shared.injectInterstitial()
		AddMobManager.shared.showInterstitialWhenSelect(viewcontroller: self)
		switch graphSelection {
		case .Girths:
			if !UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths.unlock") {
				measureTitle =  [loc("LOCALWeight"),loc("LOCALNeck"),loc("LOCALBicep_L"),loc("LOCALBicep_R_Relax"),loc("LOCALForearm_L"),loc("LOCALWrist"),loc("LOCALWaist"),loc("LOCALHips"),loc("LOCALThigh_L"),loc("LOCALCalf_R")]
				imageArray = ["Weight","Neck","Bicep_L","bicep_R_Relax","Forearm_L","Wrist","Waist","Hips","Thigh_L","Calf_R"]
			} else {
				measureTitle =  [loc("LOCALWeight"),loc("LOCALNeck"),loc("LOCALBicep_R"),loc("LOCALBicep_L"),loc("LOCALBicep_R_Relax"),loc("LOCALBicep_L_Relax"),loc("LOCALForearm_R"),loc("LOCALForearm_L"),loc("LOCALWrist"),loc("LOCALChest"),loc("LOCALWaist"),loc("LOCALHips"),loc("LOCALThigh_R"),loc("LOCALThigh_L"),loc("LOCALCalf_R"),loc("LOCALCalf_L")]
				imageArray = ["Weight","Neck","Bicep_L","Bicep_R","bicep_L_Relax","bicep_R_Relax","Forearm_L","Forearm_R","Wrist","Chest","Waist","Hips","Thigh_L","Thigh_R","Calf_L","Calf_R"]
				
			}
			if let lastGirthsDate = DataManager.shared.getLastMeasureAvailable() {
				labelINFO.text = loc("LastGirths") + " - " + StaticClass.dateFormat(d: lastGirthsDate.dateOfEntry!)
			}
			measureArray = Items.sharedInstance.measureArray
			
		case .SkinFolds:
			plicheTitle = [loc("LOCALPlicheSum"),loc("LOCALBodyDensity"), loc("LOCALbodyFat%"),loc("LOCALLeanBodyMass")]
			
			plicheArray = Items.sharedInstance.plicheArray
			plicheMethod = Items.sharedInstance.method
			if let p = DataManager.shared.getLastPlicheAvailable() {
				
				var method : String = ""
				switch p.method {
				case "jackson & Polloc 7 point": method = "J&P 7"
				case "jackson & Polloc 3 point Man": method = "J&P 3"
				case "jackson & Polloc 3 point Woman": method = "J&P 3"
				case "Sloan - Men 2 point": method = "Sloan"
				case "Sloan - Woman 2 point": method = "Sloan"
				case "Durnin & Womersley Man 4 Pliche": method = "D&W"
				default : break
				}
				
				labelINFO.text = loc("LastSkinFolds") + " - " + StaticClass.dateFormat(d: p.dateOfEntry!)  + " - " + method
			}
		case .GirthsOverSkinFolds:
			plicheArrayThumb =  ["Triceps_P","Biceps_P","Subscapular_P","Suprailiac_P","Midaxillary_P","Abdominal_P","Chest_P","Thigh_P"]
			labelINFO.text = "Girths over Skinfold sites"
			
		}
		switch graphSelection {
		case .Girths: measureArray = Items.sharedInstance.measureArray
		case .SkinFolds: plicheArray = Items.sharedInstance.plicheArray
		case .GirthsOverSkinFolds: plicheMethod = Items.sharedInstance.method
		}
		parentNavigationController?.navigationBar.barTintColor = .black
		myCollectionView.reloadData()
	}
	
	
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	//	func createAndLoadInterstitial() -> GADInterstitial {
	//		let interstitial = GADInterstitial(adUnitID: StaticClass.GandCInterstitialProduction)
	//		interstitial.delegate = self
	//		interstitial.load(GADRequest())
	//		return interstitial
	//	}
	//
	//	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
	//		showInterstitial = true
	//		interstitial = createAndLoadInterstitial()
	//	}
	
	
	
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch graphSelection {
		case .Girths: return measureTitle.count
		case .SkinFolds: return plicheTitle.count
		case .GirthsOverSkinFolds: return plicheArrayThumb.count
			
		}
		
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "InsightCustomCell", for: indexPath) as! InsightCustomCell
		
		switch graphSelection {
			
		case .Girths:
			cell.labelName.text = measureTitle[indexPath.row]
			cell.imageBodyPart.image = UIImage(named: imageArray[indexPath.row])
			switch indexPath.row {
			case 0 : cell.labelValue.text = String(Items.sharedInstance.measureArray[indexPath.row]) + " " + unitMeasurWeight
			default : cell.labelValue.text = String(Items.sharedInstance.measureArray[indexPath.row]) + " " + unitMeasurLenght
			}
			
			
		case .SkinFolds:
			let skinFoldsResultImage = ["sfsumm","BMI","BFP","LeanMass"]
			cell.labelName.text = plicheTitle[indexPath.row]
			cell.imageBodyPart.image = UIImage(named: skinFoldsResultImage[indexPath.row])
			
			if indexPath.row == 0 {
				cell.labelValue.text = String(format: "%.1f", Items.sharedInstance.plicheArray[indexPath.row]) + " " + "mm"
			} else if indexPath.row == 1 {
				cell.labelValue.text = String(format: "%.1f", Items.sharedInstance.plicheArray[indexPath.row]) + " g/cc"
			} else if indexPath.row == 2 {
				cell.labelValue.text = String(format: "%.1f", Items.sharedInstance.plicheArray[indexPath.row]) + " %"
			} else if indexPath.row == 3 {
				cell.labelValue.text = String(format: "%.1f", Items.sharedInstance.plicheArray[indexPath.row]) + " " + unitMeasurWeight
			}
			
		case .GirthsOverSkinFolds:
			let overArray  = [loc("LOCALBicep_R"),loc("LOCALBicep_R"),loc("LOCALChest"),loc("LOCALWaist"),loc("LOCALChest"),loc("LOCALWaist"),loc("LOCALChest"),loc("LOCALThigh_L")]
			let toTrim = CharacterSet(charactersIn: "_P")
			let trimmed = plicheArrayThumb[indexPath.item].trimmingCharacters(in: toTrim)
			let localTrimmed = loc("LOCAL"+trimmed) + " / " + overArray[indexPath.item]
			cell.labelName.text = localTrimmed
			cell.imageBodyPart.image = UIImage(named: plicheArrayThumb[indexPath.item])
			cell.labelValue.text = ""
		}
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var cellPerRow : CGFloat = 3
		switch graphSelection {
		case .Girths: cellPerRow = 3
		case .SkinFolds: cellPerRow = 2
		case .GirthsOverSkinFolds: cellPerRow = 2
		}
		let yourWidth = (collectionView.bounds.width/cellPerRow)
		
		let yourHeight = yourWidth
		return CGSize(width: yourWidth, height: yourHeight)
		
		
		
	}
	
	
	
}

extension InsightReusableController {
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		print("PREPARE -)")
		if segue.identifier == "ToChart"{
			print("ToChart -)")
			let cell = sender as! InsightCustomCell
			if let indexPath = myCollectionView.indexPath(for: cell) {
				print("indexPath -)")
				let controller = segue.destination as! ChartViewController
				switch graphSelection {
				case .Girths:
					if  DataManager.shared.purchasedGirthsAndSkinfilds() {
						print("index path - \(indexPath.row)")
						switch indexPath.row {
						case 0 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "weight").value; controller.titleGraph = loc("LOCALWeight");controller.weightButtonisHidden = true
						case 1 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "neck").value; controller.titleGraph = loc("LOCALNeck")
						case 2 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "bicep_R").value; controller.titleGraph = loc("LOCALBicep_R")
						case 3 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "bicep_L").value; controller.titleGraph = loc("LOCALBicep_L")
						case 4 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "bicep_R_Relax").value; controller.titleGraph = loc("LOCALBicep_R_Relax")
						case 5 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "bicep_L_Relax").value; controller.titleGraph = loc("LOCALBicep_L_Relax")
						case 6 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "forearm_R").value; controller.titleGraph = loc("LOCALForearm_R")
						case 7 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "forearm_L").value; controller.titleGraph = loc("LOCALForearm_L")
						case 8 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "wrist").value; controller.titleGraph = loc("LOCALWrist")
						case 9 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "chest").value; controller.titleGraph = loc("LOCALChest")
						case 10 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "waist").value; controller.titleGraph = loc("LOCALWaist")
						case 11 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "hips").value; controller.titleGraph = loc("LOCALHips")
						case 12 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "thigh_R").value; controller.titleGraph = loc("LOCALThigh_R")
						case 13 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "thigh_L").value; controller.titleGraph = loc("LOCALThigh_L")
						case 14 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "calf_R").value; controller.titleGraph = loc("LOCALCalf_R")
						case 15 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "calf_L").value; controller.titleGraph = loc("LOCALCalf_L")
						default : break
						}
						print("something purchased") } else {
						switch indexPath.row {
						case 0 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "weight").value; controller.titleGraph = loc("LOCALWeight");controller.weightButtonisHidden = true
						case 1 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "neck").value; controller.titleGraph = loc("LOCALNeck")
						case 2 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "bicep_L").value; controller.titleGraph = loc("LOCALBicep_L")
						case 3 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "bicep_R_Relax").value; controller.titleGraph = loc("LOCALBicep_R_Relax")
						case 4 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "forearm_L").value; controller.titleGraph = loc("LOCALForearm_L")
						case 5 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "wrist").value; controller.titleGraph = loc("LOCALWrist")
						case 6 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "waist").value; controller.titleGraph = loc("LOCALWaist")
						case 7 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "hips").value; controller.titleGraph = loc("LOCALHips")
						case 8 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "thigh_L").value; controller.titleGraph = loc("LOCALThigh_L")
						case 9 : controller.userMeasurement = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "calf_R").value; controller.titleGraph = loc("LOCALCalf_R")
							
						default : break
						}
						
						
						
					}
					
					controller.dateArray = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "calf_L").date
					controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "weight").value
					controller.dateArrayOverlay = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "weight").date
					
				case .SkinFolds:
					if  DataManager.shared.purchasedGirthsAndSkinfilds() {
						
						print("something purchased") } else {
						
						
					}
					switch indexPath.row {
					case 0 : controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "sum").value; controller.titleGraph = loc("LOCALPlicheSum")
					case 1 : controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "bodyDensity").value; controller.titleGraph = loc("LOCALBodyDensity")
					case 2 : controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "bodyFatPerc").value;  controller.titleGraph = loc("LOCALbodyFat%")
					case 3 : controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "leanMass").value; controller.titleGraph = loc("Massa Magra")
					default : break
					}
					controller.overlayGraph = DataManager.shared.plicheFetchAllDateAndSort(with: "weight").value
					controller.dateArray = DataManager.shared.plicheFetchAllDateAndSort(with: "sum").date
					
					
					controller.dateArrayOverlay = DataManager.shared.plicheFetchAllDateAndSort(with: "sum").date
					
				case .GirthsOverSkinFolds:
					
					if  DataManager.shared.purchasedGirthsAndSkinfilds() {
						print("something purchased") } else {
						
						
					}
					switch indexPath.row {
					case 0 :
						controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "triceps").value
						controller.titleGraph = loc("LOCALTricepsfold")
						controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "bicep_L").value
						controller.weightButtonTitle = loc("LOCALOverlayBicepgirth")
					case 1 :
						controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "biceps").value
						controller.titleGraph = loc("LOCALBicepsfold")
						controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "bicep_L").value
						controller.weightButtonTitle = loc("LOCALOverlayBicepgirth")
					case 2 :
						controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "subscapular").value
						controller.titleGraph = loc("LOCALSubscapularfold")
						controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "chest").value
						controller.weightButtonTitle = loc("LOCALOverlayChestgirth")
					case 3 :
						controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "suprailiac").value
						controller.titleGraph = loc("LOCALSuprailiacfold")
						controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "waist").value
						controller.weightButtonTitle = loc("LOCALOverlayWaistgirth")
					case 4 :
						controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "midaxillary").value
						controller.titleGraph = loc("LOCALMidaxillaryfold")
						controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "chest").value
						controller.weightButtonTitle = loc("LOCALOverlayChestgirth")
					case 5 :
						controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "abdominal").value
						controller.titleGraph = loc("LOCALAbdominalfold")
						controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "waist").value
						controller.weightButtonTitle = loc("LOCALOverlayWaistgirth")
					case 6 : controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "chest").value
					controller.titleGraph = loc("LOCALChestfold")
					controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "chest").value
					controller.weightButtonTitle = loc("LOCALOverlayChestgirth")
					case 7 :
						controller.userMeasurement = DataManager.shared.plicheFetchAllDateAndSort(with: "thigh").value
						controller.titleGraph = loc("LOCALThighfold")
						controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "thigh_L").value
						controller.weightButtonTitle = loc("LOCALOverlayThighgirth")
					default : break
						
					}
					controller.dateArray = DataManager.shared.plicheFetchAllDateAndSort(with: "sum").date
					controller.dateArrayOverlay = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "weight").date
					
				}
			}
		}
	}
}


