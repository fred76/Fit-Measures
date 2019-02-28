//
//  MeasureMainController.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 25/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import CoreData
import HealthKit
protocol AlertViewDelegate {
    func alertSending(sender: UIAlertController)
}
private struct ItemDef {
    let title: String
    var value: String
    let unit: String
    let image :String
}

class MeasureMainController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    private var itemDef : [ItemDef]!
    
    private let userHealthProfile = UserHealthProfile()
    @IBOutlet weak var measureCollctionView: UICollectionView!
    var bodyMeasurementPoint = BodyMeasurementPoints.weight 
    var indexPathSelected : IndexPath!
    var unitMeasurLenght:String!
    var unitMeasurWeight:String!
    var bodyMeasureSelected: BodyMeasure!
    var plicheMeasure: PlicheMeasure?
    var isAdded : Bool! = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyMeasureSelected = DataManager.shared.getLastMeasureAvailable()
        self.measureCollctionView.delegate = self
        self.measureCollctionView.dataSource = self 
        unitMeasurLenght = " " + UserDefaultsSettings.lenghtUnitSet
        unitMeasurWeight = " " + UserDefaultsSettings.weightUnitSet
        DataManager.shared.assignUniqueIdentifierToMeasure()
        DataManager.shared.assignUniqueIdentifierToPliche()
        DataManager.shared.assignUniqueIdentifierToPicFullRes()
        DataManager.shared.assignUniqueIdentifierToThumb()
        updateHealthInfo {
            
        }
        readItemDeaf () 
    } 
    override func viewWillDisappear(_ animated: Bool) {
        Items.sharedInstance.updateMaesure()
        Items.sharedInstance.updatePliche()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        #warning("stampa la cartella")
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
        measureCollctionView.reloadData()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        isAdded = DataManager.shared.bodyMeasurementForTodayIsAvailable()
        readItemDeaf ()

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    
    func readItemDeaf (){
        bodyMeasureSelected = DataManager.shared.getLastMeasureAvailable()
            let m = bodyMeasureSelected
            itemDef=[  
                ItemDef(title: loc("LOCALWeight"), value: returnString(d: m?.weight ?? 0) , unit: UserDefaultsSettings.weightUnitSet, image: "Weight"),
                ItemDef(title: loc("LOCALNeck"), value: returnString(d: m?.neck ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Neck"),
                ItemDef(title: loc("LOCALBicep_R"), value: returnString(d: m?.bicep_R ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Bicep_R"),
                ItemDef(title: loc("LOCALBicep_L"), value: returnString(d: m?.bicep_L ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Bicep_L"),
                ItemDef(title: loc("LOCALBicep_R_Relax"), value: returnString(d: m?.bicep_R_Relax ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "bicep_R_Relax"),
                ItemDef(title: loc("LOCALBicep_L_Relax"), value: returnString(d: m?.bicep_L_Relax ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "bicep_L_Relax"),
                ItemDef(title: loc("LOCALForearm_R"), value: returnString(d: m?.forearm_R ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Forearm_R"),
                ItemDef(title: loc("LOCALForearm_L"), value: returnString(d: m?.forearm_L ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Forearm_L"),
                ItemDef(title: loc("LOCALChest"), value: returnString(d: m?.chest ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Chest"),
                ItemDef(title: loc("LOCALWrist"), value: returnString(d: m?.wrist ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Wrist"),
                ItemDef(title: loc("LOCALWaist"), value: returnString(d: m?.waist ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Waist"),
                ItemDef(title: loc("LOCALHips"), value: returnString(d: m?.hips ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Hips"),
                ItemDef(title: loc("LOCALThigh_R"), value: returnString(d: m?.thigh_R ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Thigh_R"),
                ItemDef(title: loc("LOCALThigh_L"), value: returnString(d: m?.thigh_L ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Thigh_L"),
                ItemDef(title: loc("LOCALCalf_R"), value: returnString(d: m?.calf_R ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Calf_R"),
                ItemDef(title: loc("LOCALCalf_L"), value: returnString(d: m?.calf_L ?? 0), unit: UserDefaultsSettings.lenghtUnitSet, image: "Calf_L")
            ]
            
        }
        func returnString(d:Double)->String{
            return String(format: "%.1f", d)
        }
        
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let yourWidth = (collectionView.bounds.width/3.0)-10
            let yourHeight = yourWidth
            return CGSize(width: yourWidth, height: yourHeight)
        }
        let yourWidth = (collectionView.bounds.width/2.0)-10
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDef.count
        
    }
    
    var selectedIndexes = [NSIndexPath]() {
        didSet {
            measureCollctionView.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = measureCollctionView.dequeueReusableCell(withReuseIdentifier: "MeasureCell", for: indexPath) as! MeasureCollectionViewCell
        let def = self.itemDef[indexPath.row]
        cell.imageContent.image = UIImage(named: def.image)
        cell.nameLabel.text = def.title
        if isAdded {
            cell.measureLabel.text = StaticClass.removeZero(label: cell.measureLabel, value: def.value, constr: cell.nameLabelCenterPosition, unit: def.unit) 
           
            cell.measureLabel.isHidden = false
            if cell.measureLabel.isTruncatedu {
                cell.nameLabel.font = UIFont.systemFont(ofSize: 13)
                cell.nameLabel.adjustsFontSizeToFitWidth = true
                 cell.measureLabel.adjustsFontSizeToFitWidth = true
            }
            return cell
        }
        cell.measureLabel.isHidden = true
        return cell
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? MeasureCollectionViewCell {
            indexPathSelected = indexPath
            let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertID") as! AllertViewDataInsert
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                customAlert.modalPresentationStyle = .popover
                customAlert.preferredContentSize = CGSize(width: 240, height: 250)
                if let popover = customAlert.popoverPresentationController {
                    popover.permittedArrowDirections = .any
                    popover.delegate = self
                    popover.sourceView = cell
                    popover.sourceRect = CGRect(x: cell.bounds.minX + cell.bounds.width / 5, y: cell.bounds.minY, width: 50, height: 50 )
                    
                    popover.backgroundColor = .clear
                }
                present(customAlert, animated: true, completion: nil)
                
            } else {
                customAlert.providesPresentationContextTransitionStyle = true
                customAlert.definesPresentationContext = true
                customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                self.present(customAlert, animated: true, completion: nil)
            }
            customAlert.delegate = self
            setTabBarHidden(true)
            
            let def = self.itemDef[indexPath.row]
            
            bodyMeasurementPoint = BodyMeasurementPoints(rawValue: def.image)!
            print("bodyMeasurementPoint \(bodyMeasurementPoint)")
            switch bodyMeasurementPoint {
            case .weight : customAlert.messageLabel.text = loc("weight_Descr")
            case .neck : customAlert.messageLabel.text = loc("neck_Descr")
            case .bicep_R : customAlert.messageLabel.text = loc("bicep_R_Descr")
            case .bicep_L : customAlert.messageLabel.text = loc("bicep_L_Descr")
            case .bicep_R_Relax : customAlert.messageLabel.text = loc("bicep_R_Down_Descr")
            case .bicep_L_Relax : customAlert.messageLabel.text = loc("bicep_L_Down_Descr")
            case .Forearm_R : customAlert.messageLabel.text = loc("Forearm_R_Descr")
            case .forearm_L : customAlert.messageLabel.text = loc("forearm_L_Descr")
            case .wrist : customAlert.messageLabel.text = loc("wrist_Descr")
            case .chest : customAlert.messageLabel.text = loc("chest_Descr")
            case .waist : customAlert.messageLabel.text = loc("waist_Descr")
            case .hips : customAlert.messageLabel.text = loc("hips_Descr")
            case .Thigh_R : customAlert.messageLabel.text = loc("Thigh_R_Descr")
            case .thigh_L : customAlert.messageLabel.text = loc("thigh_L_Descr")
            case .Calf_R : customAlert.messageLabel.text = loc("Calf_R_Descr")
            case .calf_L : customAlert.messageLabel.text = loc("calf_L_Descr")
                
            }
        }
        
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        setTabBarHidden(false)
    }
    
}

extension MeasureMainController : CustomAlertViewDelegate {
    func okButtonTapped(selectedOption: String, textFieldValue: String) {
        
        if let cell = measureCollctionView.cellForItem(at: indexPathSelected) as? MeasureCollectionViewCell {
            setTabBarHidden(false)
            if textFieldValue.isEmpty == false {
                var text = textFieldValue
                if bodyMeasurementPoint == .weight {
                    text += " Kg"
                } else {
                    text += " cm"
                }
                
                var def = self.itemDef[indexPathSelected.row]
                if !isAdded {
                    DataManager.shared.bodyMeasureAddForCurrentDate(dateofEntry: StaticClass.getDate())
                    bodyMeasureSelected = DataManager.shared.getLastMeasureAvailable()
                    isAdded = true
                }
                
                cell.measureLabel.isHidden = false
                let key = def.image.firstLowercased
                bodyMeasureSelected.setValue(textFieldValue.doubleValue, forKey: key)
                DataManager.shared.save()
                def.value = textFieldValue
                cell.measureLabel.text = text
               // cell.measureLabel.adjustsFontSizeToFitWidth = true
                readItemDeaf()
                
                if indexPathSelected.row == 8 {
                    HealthManager.addToHealthKit(DataToSave: .waistCircumference, unitMeasure: HKQuantity(unit: HKUnit.meter(), doubleValue: textFieldValue.doubleValue/100), date: StaticClass.getDate()) {
                        
                    }
                }
                
                if indexPathSelected.row == 0 {
                    HealthManager.addToHealthKit(DataToSave: .bodyMass, unitMeasure: HKQuantity(unit: HKUnit.gram(), doubleValue: textFieldValue.doubleValue*1000), date: StaticClass.getDate()) {
                    }
                }
               // measureCollctionView.reloadItems(at: [indexPathSelected])
                
                if cell.measureLabel.isTruncatedu {
                    cell.nameLabel.font = UIFont.systemFont(ofSize: 13)
                    cell.nameLabel.adjustsFontSizeToFitWidth = true
                    cell.measureLabel.adjustsFontSizeToFitWidth = true
                }
                
                
                UIView.animate(withDuration: 0.5) {
                    cell.nameLabelCenterPosition.constant = -20
                    cell.measureLabel.isHidden = false
                    self.view.layoutIfNeeded()
                    
                }
            }
        }
    }
    
    func cancelButtonTapped() {
        setTabBarHidden(false)
    }
    
}


extension MeasureMainController {
    
    
    
    
    
    
    private func updateHealthInfo(closure: @escaping ()->()) {
        loadAndDisplayAgeSexAndBloodType()
        loadAndDisplayMostRecentHeight()
        closure()
    }
    
    private func loadAndDisplayMostRecentHeight() {
        guard let heightSampleType = HKSampleType.quantityType(forIdentifier: .height) else {
            print("Height Sample Type is no longer available in HealthKit")
            return
        }
        ProfileDataStore.getMostRecentSample(for: heightSampleType) { (sample, error) in
            guard let sample = sample else {
                if let error = error {
                    print(error)
                }
                return
            }
            let heightInMeters = sample.quantity.doubleValue(for: HKUnit.meter())
            self.userHealthProfile.heightInMeters = heightInMeters
            if let height = self.userHealthProfile.heightInMeters {
                
                UserDefaultsSettings.heightSet = height*100
                
            }
        }
    }
    
    
    private func loadAndDisplayAgeSexAndBloodType() {
        do {
            let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
            userHealthProfile.age = userAgeSexAndBloodType.age
            userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
            
            if let age = userHealthProfile.age {
                UserDefaultsSettings.ageSet = Double(age)
            }
            if let biologicalSex = userHealthProfile.biologicalSex {
                if biologicalSex == .notSet || biologicalSex == .other
                {
                    
                } else {
                    UserDefaultsSettings.biologicalSexSet = biologicalSex.stringRepresentation
                }
                
            }
            
        } catch let error {
            print(error)
            
            //self.displayAlert(for: error)
        }
    }
    
    
    
    private func displayAlert(for error: Error) {
        
        let alert = UIAlertController(title: nil,
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "O.K.",
                                      style: .default,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
extension StringProtocol {
    var firstLowercased: String {
        guard let first = first else { return "" }
        return String(first).lowercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
}
