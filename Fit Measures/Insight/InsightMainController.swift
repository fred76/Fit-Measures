//
//  InsightMainController.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 25/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import GoogleMobileAds
class InsightMainController: UIViewController, UITableViewDelegate, UITableViewDataSource,GADInterstitialDelegate {
    var interstitial: GADInterstitial!
    var showInterstitial : Bool = false
    @IBOutlet var noInsigth: UIView!
    @IBOutlet weak var lastMeasureTableView: UITableView!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var measureTitle : [String] = []
    var plicheTitle : [String] = []
    var imageArray : [String] = []
    var plicheMethod : String!
    var measureArray : [Double] = []
    var plicheArray : [Double] = []
    var bodyMeasureSelected: BodyMeasure!
    var plicheMeasure : PlicheMeasure!
    var unitMeasurWeight:String!
    var unitMeasurLenght:String!
    var bodyMeasurementIsAdded : Bool = false
    var plicheMeasureIsAdded : Bool = false
    
    @IBOutlet var plicheCollectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lastMeasureTableView.delegate = self
        lastMeasureTableView.dataSource = self
        plicheCollectionView.delegate = self
        plicheCollectionView.dataSource = self
        if !UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths") {
            measureTitle =  [loc("LOCALWeight"),loc("LOCALNeck"),loc("LOCALBicep_L"),loc("LOCALBicep_R_Relax"),loc("LOCALForearm_L"),loc("LOCALWrist"),loc("LOCALWaist"),loc("LOCALHips"),loc("LOCALThigh_L"),loc("LOCALCalf_R")]
            imageArray = ["Weight","Neck","Bicep_L","bicep_R_Relax","Forearm_L","Wrist","Waist","Hips","Thigh_L","Calf_R"]
        } else {
            measureTitle =  [loc("LOCALWeight"),loc("LOCALNeck"),loc("LOCALBicep_R"),loc("LOCALBicep_L"),loc("LOCALBicep_R_Relax"),loc("LOCALBicep_L_Relax"),loc("LOCALForearm_R"),loc("LOCALForearm_L"),loc("LOCALWrist"),loc("LOCALChest"),loc("LOCALWaist"),loc("LOCALHips"),loc("LOCALThigh_R"),loc("LOCALThigh_L"),loc("LOCALCalf_R"),loc("LOCALCalf_L")]
            imageArray = ["Weight","Neck","Bicep_L","Bicep_R","bicep_L_Relax","bicep_R_Relax","Forearm_L","Forearm_R","Wrist","Chest","Waist","Hips","Thigh_L","Thigh_R","Calf_L","Calf_R"]
            
        }
        
       
        plicheTitle = [loc("LOCALPlicheSum"),loc("LOCALBodyDensity"), loc("LOCALbodyFat%"),loc("LOCALLeanBodyMass")]
        
        plicheArrayThumb =  ["Triceps_P","Biceps_P","Subscapular_P","Suprailiac_P","Midaxillary_P","Abdominal_P","Chest_P","Thigh_P"]
        bodyMeasurementIsAdded = DataManager.shared.bodyMeasurementExist()
        plicheMeasureIsAdded = DataManager.shared.plicheMeasurementExist()
        if !bodyMeasurementIsAdded && !plicheMeasureIsAdded{
            lastMeasureTableView.backgroundView = noInsigth
            plicheCollectionView.isHidden = true
            bottomConstraint.constant = -108
          
        }
        unitMeasurLenght = " " + UserDefaultsSettings.lenghtUnitSet
        unitMeasurWeight = " " + UserDefaultsSettings.weightUnitSet
        
        
        
        AppStoreReviewManager.requestReviewIfAppropriate()
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        interstitial = createAndLoadInterstitial()
        showInterstitial = true
        //create a new button
        let button = UIButton(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "Gallery.png"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(fbButtonPressed), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        
        let barButton = UIBarButtonItem(customView: button)
        
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    //This method will call when you press button.
    @objc func fbButtonPressed() {
        
        print("Share to fb")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        measureArray = Items.sharedInstance.measureArray
        plicheArray = Items.sharedInstance.plicheArray
        plicheMethod = Items.sharedInstance.method
        bodyMeasurementIsAdded = DataManager.shared.bodyMeasurementExist()
        plicheMeasureIsAdded = DataManager.shared.plicheMeasurementExist()
        if !bodyMeasurementIsAdded && !plicheMeasureIsAdded{
          
            lastMeasureTableView.backgroundView = noInsigth
        } else {
            
            lastMeasureTableView.backgroundView = nil
        }
        
        if !bodyMeasurementIsAdded || !plicheMeasureIsAdded{
            plicheCollectionView.isHidden = true
            bottomConstraint.constant = -108
        } else if bodyMeasurementIsAdded && plicheMeasureIsAdded{
            plicheCollectionView.isHidden = false
            bottomConstraint.constant = 8
        }
        
        
        lastMeasureTableView.reloadData()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        showInterstitial = true
        interstitial = createAndLoadInterstitial()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if showInterstitial {
            return true
        } else {
            return false
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            if bodyMeasurementIsAdded {
                return measureTitle.count
            } else {
                return 0
            }
            
        }
        if plicheMeasureIsAdded{
            return plicheTitle.count
        } else {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        return 72
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = .black
        let label = UILabel()
        let labelDate = UILabel() 
        label.textColor = StaticClass.blueHeader
        labelDate.textColor = StaticClass.blueHeader
        labelDate.textAlignment = .right
        labelDate.textAlignment = .right
        if section == 0 && bodyMeasurementIsAdded{
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width/2, height: headerView.frame.height-10)
            label.text = "Last Girths"
            labelDate.frame = CGRect.init(x: headerView.frame.width/2, y: 5, width: headerView.frame.width/2, height: headerView.frame.height-10)
            labelDate.text = StaticClass.dateFormat(d: DataManager.shared.getLastMeasureAvailable()!.dateOfEntry!)
           
            headerView.addSubview(labelDate)
            headerView.addSubview(label)
            return headerView
        }
        if plicheMeasureIsAdded {
            
            
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width/2, height: headerView.frame.height-10)
            label.text = "Last Skin Folds Results"
            labelDate.frame = CGRect.init(x: headerView.frame.width/2, y: 5, width: headerView.frame.width/2, height: headerView.frame.height-10)
            if let p = DataManager.shared.getLastPlicheAvailable() {
                labelDate.text = StaticClass.dateFormat(d: p.dateOfEntry!)
            }
            headerView.addSubview(labelDate)
            headerView.addSubview(label)
            return headerView
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lastMeasureCell", for: indexPath) as! lastMeasureCell
        if indexPath.section == 0 {
            cell.nameLabel.text = measureTitle[indexPath.row]
            cell.imageCell.image = UIImage(named: imageArray[indexPath.row])
            cell.methodLabel.isHidden = true 
            cell.valueLabel.text = String(Items.sharedInstance.measureArray[indexPath.row])
        } else {
            cell.nameLabel.text = plicheTitle[indexPath.row]
            cell.imageCell.image = UIImage(named: "Caliper")
            cell.methodLabel.isHidden = false
            cell.methodLabel.text = plicheMethod
            if indexPath.row == 0 {
                cell.valueLabel.text = String(format: "%.1f", Items.sharedInstance.plicheArray[indexPath.row]) + " " + "mm"
            } else if indexPath.row == 1 {
                cell.valueLabel.text = String(format: "%.1f", Items.sharedInstance.plicheArray[indexPath.row]) + " g/cc"
            } else if indexPath.row == 2 {
                cell.valueLabel.text = String(format: "%.1f", Items.sharedInstance.plicheArray[indexPath.row]) + " %"
            } else if indexPath.row == 3 {
                cell.valueLabel.text = String(format: "%.1f", Items.sharedInstance.plicheArray[indexPath.row]) + " " + unitMeasurWeight
                
            }
            
            
            
            return cell
        }
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ToChartFromTable"{
            if let indexPath = lastMeasureTableView.indexPathForSelectedRow {
                let controller = segue.destination as! ChartViewController
                
                if indexPath.section == 0 {
                    if UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths") || UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds") {
                        
                        print("something purchased") } else {
                       if indexPath.row == StaticClass.randomIndexpath(upperLimit: 14) {
                        if interstitial.isReady { interstitial.present(fromRootViewController: self) }
                        else { print("Ad wasn't ready") }
                        } }
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
                    controller.dateArray = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "calf_L").date
                    controller.overlayGraph = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "weight").value
                    controller.dateArrayOverlay = DataManager.shared.bodyMeasurementFetchAllDateAndSort(with: "weight").date
                } else if indexPath.section == 1 {
                    
                    if UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths") || UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds") {
                        
                        print("something purchased") } else {
                    if indexPath.row == StaticClass.randomIndexpath(upperLimit: 3) {
                        if interstitial.isReady { interstitial.present(fromRootViewController: self) }
                        else { print("Ad wasn't ready") }
                    }}
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
                   
                }
            }
        }
        
        if segue.identifier == "ToChartFromCollection"{
            
            if let controller = segue.destination as? ChartViewController{
                let cell = sender as! plicheCollectionViewThumbCell
                let indexPath = plicheCollectionView.indexPath(for: cell)
                if UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths") || UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds") { 
                    print("something purchased") } else {
                    if indexPath!.row == StaticClass.randomIndexpath(upperLimit: 6) {
                    if interstitial.isReady { interstitial.present(fromRootViewController: self) }
                    else { print("Ad wasn't ready") }
                }}
                switch indexPath?.row {
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
    
    var plicheArrayThumb : [String] = []
}

class plicheCollectionViewThumbCell: UICollectionViewCell {
    
    @IBOutlet var thumbImage: UIImageView!
    @IBOutlet var thumbLabel: UILabel!
    
    //"PlicheThumb"
    
    
    
}

extension InsightMainController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.height)-8
        let yourHeight = yourWidth+8
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plicheArrayThumb.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = plicheCollectionView.dequeueReusableCell(withReuseIdentifier: "PlicheThumb", for: indexPath) as! plicheCollectionViewThumbCell
        cell.thumbImage.image = UIImage(named: plicheArrayThumb[indexPath.item])
        cell.thumbImage.layer.cornerRadius = 5
        cell.thumbImage.layer.borderColor = UIColor.white.cgColor
        cell.thumbImage.layer.borderWidth = 1
        cell.contentView.backgroundColor = StaticClass.alertViewBackgroundColor
        let toTrim = CharacterSet(charactersIn: "_P")
        
        
        let trimmed = plicheArrayThumb[indexPath.item].trimmingCharacters(in: toTrim)
        let localTrimmed = loc("LOCAL"+trimmed)
        cell.thumbLabel.text = localTrimmed
        return cell
    }

    
    
    
}
