//
//  PlicheMoethod.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 27/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import CoreData
import GoogleMobileAds

private struct ItemDef {
    let title: String
    var value: String
    let unit: String
    let image :String
}


class PlicheMoethodController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate,GADInterstitialDelegate {
    
    private var itemDef : [ItemDef]!
    @IBOutlet weak var measureCollctionView: UICollectionView!
    var bodyPlichePoint = BodyPlichePoints.tricipite
    var plicheMethod = PlicheMethods.jackson_3_Man//
    var nameArray : [String]! = []
    var plicheMeasureSelected: PlicheMeasure!
    var indexPathSelected : IndexPath!
    var isAddedPliche : Bool = false
    var blockOperations: [BlockOperation] = []
    var shouldReloadCollectionView : Bool! = true
    var abdominal: Double!
    var biceps: Double!
    var chest: Double!
    var method: String!
    var midaxillary: Double!
    var subscapular: Double!
    var suprailiac: Double!
    var thigh: Double!
    var triceps: Double!
    var sum: Double!
    var bodyDensity: Double!
    var bodyFatPerc: Double!
    var leanMass: Double!
    var Method: String!
    var arrayofPlicheToPass : [Double] = []
    var dictPlicheValue : [String:Double] = [:]
    var interstitial: GADInterstitial!
    var showInterstitial : Bool = false
    @IBOutlet var weightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.measureCollctionView.delegate = self
        self.measureCollctionView.dataSource = self
        
        switch plicheMethod {
        case .jackson_7 : nameArray = ["Triceps","Suprailiac","Thigh","Abdominal","Chest","Subscapular","Midaxillary"]
            
        case .jackson_3_Man : nameArray = ["Chest","Abdominal","Thigh"]
            
        case .jackson_3_Woman : nameArray = ["Triceps","Suprailiac","Thigh"]
            
        case .sloanMen : nameArray = ["Subscapular","Thigh"]
            
        case .DurninMan : nameArray = ["Triceps","Biceps","Subscapular","Suprailiac"]
            
        case .sloanWoman : nameArray = ["Suprailiac","Triceps"]
            
        }
        
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        interstitial = createAndLoadInterstitial()
        showInterstitial = true
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
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if plicheMethod == .jackson_3_Man || plicheMethod == .jackson_7 {
            if  DataManager.shared.purchasedGirthsAndSkinfilds() { print("something purchased") } else {
                if interstitial.isReady {
                    interstitial.present(fromRootViewController: self)
                } else {
                    print("Ad wasn't ready")
                }
                
            }
           
        }
        isAddedPliche = DataManager.shared.plicheForTodayIsVavailable()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        dictPlicheValue.removeAll() 
        subscapular=nil 
        readItemDef() 
        measureCollctionView.reloadData()
        bodyWeightWarning()
    } 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func bodyWeightWarning(){
        if let weightAvailable = DataManager.shared.getLastMeasureAvailable() {
            if weightAvailable.weight < 30 {
                weightLabel.text = loc("No body weight availabe")
                let text1 = loc("Noitce")
                let text2 = loc("You want use ")
                let text3 = loc(" Kg for calcultate body data?")
                DataManager.shared.allertWithParameter(title: "\(text1)", message:"\(text2)\(weightAvailable.weight)\(text3)" , viecontroller: self)
            } else {
                weightLabel.text = loc("Body Weight ") + String(weightAvailable.weight) + " Kg"
            }
        } else {
            weightLabel.text = loc("No body weight availabe")
            DataManager.shared.allertWithParameter(title: loc("Noitce"), message: loc("Body weight not available lean mass will be not calculated"), viecontroller: self)
        }
    }
    func plicheGraph(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let customAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertPieChartPreviewID") as! AllertViewSkinFoldInsertWithGraph
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve 
        customAlert.delegatePieChart = self
        customAlert.plichePoint.removeAll() 
        customAlert.plichePoint.append(contentsOf: nameArray)
        let (_, bodyDensity,bodyFatPerc,leanMass,fatMass, lastWeight) = DataManager.shared.plicheAddedByUser(abdominal: abdominal, biceps: biceps, chest: chest,  midaxillary: midaxillary, subscapular: subscapular, suprailiac: suprailiac, thigh: thigh, triceps: triceps, viewVontroller: self, plicheMethod: plicheMethod.rawValue)
        customAlert.weightArray.append(leanMass)
        customAlert.weightArray.append(fatMass)
        customAlert.bodyWeight = lastWeight
        customAlert.bodyDensity = bodyDensity
        customAlert.bodyFatPerc = bodyFatPerc
        customAlert.dictPlicheValue = dictPlicheValue
        customAlert.method = plicheMethod.rawValue
        customAlert.plicheMethod = plicheMethod
        self.present(customAlert, animated: true, completion: nil)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
        let yourWidth = (collectionView.bounds.width/2.0)-10
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
        }
        let yourWidth = (collectionView.bounds.width/1.0)-10
        let yourHeight = yourWidth
        return CGSize(width: yourWidth, height: yourHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemDef.count
        
    }
    
    func readItemDef(){
        plicheMeasureSelected = DataManager.shared.getLastPlicheAvailable()
        let m = plicheMeasureSelected
        switch plicheMethod {
        case .jackson_7:
            itemDef=[
                ItemDef(title: loc("LOCALAbdominal"), value: returnString(d: m?.abdominal ?? 0) , unit: "mm", image: "Abdominal"),
                ItemDef(title: loc("LOCALTriceps"), value: returnString(d: m?.triceps ?? 0) , unit: "mm", image: "Triceps"),
                ItemDef(title: loc("LOCALChest"), value: returnString(d: m?.chest ?? 0) , unit: "mm", image: "Chest"),
                ItemDef(title: loc("LOCALMidaxillary"), value: returnString(d: m?.midaxillary ?? 0) , unit: "mm", image: "Midaxillary"),
                ItemDef(title: loc("LOCALSubscapular"), value: returnString(d: m?.subscapular ?? 0) , unit: "mm", image: "Subscapular"),
                ItemDef(title: loc("LOCALSuprailiac"), value: returnString(d: m?.suprailiac ?? 0) , unit: "mm", image: "Suprailiac"),
                ItemDef(title: loc("LOCALThigh"), value: returnString(d: m?.thigh ?? 0) , unit: "mm", image: "Thigh")
            ]
        case .jackson_3_Man:
            itemDef=[
                ItemDef(title: loc("LOCALChest"), value: returnString(d: m?.chest ?? 0) , unit: "mm", image: "Chest"),
                ItemDef(title: loc("LOCALAbdominal"), value: returnString(d: m?.abdominal ?? 0) , unit: "mm", image: "Abdominal"),
                ItemDef(title: loc("LOCALThigh"), value: returnString(d: m?.thigh ?? 0) , unit: "mm", image: "Thigh")
            ]
        case .jackson_3_Woman:
            itemDef=[
                ItemDef(title: loc("LOCALTriceps"), value: returnString(d: m?.triceps ?? 0) , unit: "mm", image: "Triceps"),
                ItemDef(title: loc("LOCALSuprailiac"), value: returnString(d: m?.suprailiac ?? 0) , unit: "mm", image: "Suprailiac"),
                ItemDef(title: loc("LOCALThigh"), value: returnString(d: m?.thigh ?? 0) , unit: "mm", image: "Thigh")
            ]
        case .sloanMen:
            itemDef=[
                ItemDef(title: loc("LOCALSubscapular"), value: returnString(d: m?.subscapular ?? 0) , unit: "mm", image: "Subscapular"),
                ItemDef(title: loc("LOCALThigh"), value: returnString(d: m?.thigh ?? 0) , unit: "mm", image: "Thigh")
            ]
        case .sloanWoman:
        itemDef=[
            ItemDef(title: loc("LOCALTriceps"), value: returnString(d: m?.triceps ?? 0) , unit: "mm", image: "Triceps"),
            ItemDef(title: loc("LOCALSuprailiac"), value: returnString(d: m?.suprailiac ?? 0) , unit: "mm", image: "Suprailiac")
            ]
        case .DurninMan:
            itemDef=[
                ItemDef(title: loc("LOCALBiceps"), value: returnString(d: m?.biceps ?? 0) , unit: "mm", image: "Biceps"),
                ItemDef(title: loc("LOCALTriceps"), value: returnString(d: m?.triceps ?? 0) , unit: "mm", image: "Triceps"),
                ItemDef(title: loc("LOCALSubscapular"), value: returnString(d: m?.subscapular ?? 0) , unit: "mm", image: "Subscapular"),
                ItemDef(title: loc("LOCALSuprailiac"), value: returnString(d: m?.suprailiac ?? 0) , unit: "mm", image: "Suprailiac")
            ]
        }
        
    }
    func returnString(d:Double)->String{
        return String(format: "%.1f", d)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = measureCollctionView.dequeueReusableCell(withReuseIdentifier: "PlicheCell", for: indexPath) as! PlicheMetCollectionViewCell
        //        cell.imageContent.image = UIImage(named: imageArray[indexPath.row])
        //        cell.nameLabel.text = nameArray[indexPath.row].capitalized
        
        
        
        let def = self.itemDef[indexPath.row]
        
        let imageName = def.image+"_P"
        cell.imageContent.image = UIImage(named: imageName)
        cell.nameLabel.text = def.title
        if isAddedPliche {
            cell.measureLabel.text = StaticClass.removeZero(label: cell.measureLabel, value: def.value, constr: cell.nameLabelCenterPosition, unit: def.unit)
             cell.measureLabel.isHidden = false
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
    
    var selectedIndexPath : IndexPath?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PlicheMetCollectionViewCell {
            indexPathSelected = indexPath
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let customAlert = storyboard.instantiateViewController(withIdentifier: "CustomAlertIDPlico") as! AllertViewSkinFoldInsert
            setTabBarHidden(true)
            if UIDevice.current.userInterfaceIdiom == .pad {
                customAlert.modalPresentationStyle = .popover
                customAlert.preferredContentSize = CGSize(width: 240, height: 326)
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
            let def = self.itemDef[indexPath.row]
            let point = (def.image)
            bodyPlichePoint = BodyPlichePoints(rawValue: point)!
            
            switch bodyPlichePoint {
            case .tricipite : customAlert.messageLabel.text = loc("tricipite_Descr"); customAlert.showPurchaseInfo = true; customAlert.plicheMethod = plicheMethod
            case .sottoscapola : customAlert.messageLabel.text = loc("sottoscapola_Descr"); customAlert.showPurchaseInfo = true; customAlert.plicheMethod = plicheMethod
            case .coscia : customAlert.messageLabel.text = loc("coscia_Descr"); customAlert.showPurchaseInfo = true; customAlert.plicheMethod = plicheMethod
            case .addome : customAlert.messageLabel.text = loc("addome_Descr"); customAlert.showPurchaseInfo = true; customAlert.plicheMethod = plicheMethod
            case .petto : customAlert.messageLabel.text = loc("petto_Descr"); customAlert.showPurchaseInfo = true; customAlert.plicheMethod = plicheMethod
            case .soprailliaca : customAlert.messageLabel.text = loc("soprailliaca_Descr"); customAlert.showPurchaseInfo = true; customAlert.plicheMethod = plicheMethod
            case .bicipite : customAlert.messageLabel.text = loc("bicipite_Descr"); customAlert.showPurchaseInfo = true; customAlert.plicheMethod = plicheMethod
            case .ascella : customAlert.messageLabel.text = loc("ascella_Descr"); customAlert.showPurchaseInfo = true; customAlert.plicheMethod = plicheMethod
                
            }
            
            
        }
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        setTabBarHidden(false)
    }
    
    
}


extension PlicheMoethodController : AllertViewSkinFoldInsertDelegate {
    
    
    func cancelButtonTapped() {
        setTabBarHidden(false)
        
    }
    
    func passToCoreData(value:Double) {
        
        var def = self.itemDef[indexPathSelected.row]
            if def.image == "Abdominal" { abdominal = value ; def.value = returnString(d: value);dictPlicheValue[loc("LOCALAbdominal")] = value}
            if def.image == "Biceps" { biceps = value ; def.value = returnString(d: value);dictPlicheValue[loc("LOCALBiceps")] = value}
            if def.image == "Triceps" { triceps = value ; def.value = returnString(d: value);dictPlicheValue[loc("LOCALTriceps")] = value}
            if def.image == "Chest" { chest = value ; def.value = returnString(d: value);dictPlicheValue[loc("LOCALChest")] = value}
            if def.image == "Midaxillary" { midaxillary = value; def.value = returnString(d: value);dictPlicheValue[loc("LOCALMidaxillary")] = value}
            if def.image == "Subscapular" { subscapular = value; def.value = returnString(d: value);dictPlicheValue[loc("LOCALSubscapular")] = value}
            if def.image == "Suprailiac" { suprailiac = value ; def.value = returnString(d: value);dictPlicheValue[loc("LOCALSuprailiac")] = value}
            if def.image == "Thigh" { thigh = value; def.value = returnString(d: value);dictPlicheValue[loc("LOCALThigh")] = value}
        
            readItemDef()
        
        
        switch plicheMethod {
            
        case .jackson_7 :
            if triceps != nil && suprailiac != nil && thigh != nil && abdominal != nil && chest != nil && subscapular != nil && midaxillary != nil {
                plicheGraph()
            }
        case .jackson_3_Man :
            if chest != nil && abdominal != nil && thigh != nil {
                plicheGraph()
            }
        case .jackson_3_Woman :
            if triceps != nil && suprailiac != nil && thigh != nil {
                plicheGraph()
            }
        case .sloanMen :
            if subscapular != nil && thigh != nil {
                plicheGraph()
            }
        case .DurninMan :
            if triceps != nil && biceps != nil && subscapular != nil && suprailiac != nil {
                plicheGraph()
            }
            
        case .sloanWoman :
            if suprailiac != nil && triceps != nil {
                plicheGraph()
            }
        }
    } 
    func okButtonTapped(selectedOption: String, textFieldValue_1:
        String, textFieldValue_2: String, textFieldValue_3: String) {
        setTabBarHidden(false)
        if let cell = measureCollctionView.cellForItem(at: indexPathSelected) as? PlicheMetCollectionViewCell {
            var inputCount : [Double] = []
            if textFieldValue_1.isEmpty == false || textFieldValue_2.isEmpty == false ||  textFieldValue_3.isEmpty == false {
                
                let text_1 = textFieldValue_1.doubleValue
                let text_2 = textFieldValue_2.doubleValue
                let text_3 = textFieldValue_3.doubleValue 
                if text_1 > 0 {
                    inputCount.append(1.0) }
                if text_2 > 0 {
                    inputCount.append(1.0)
                }
                if text_3 > 0 {
                    inputCount.append(1.0)
                }
                let average = (text_1 + text_2 + text_3) / Double(inputCount.count)
                let averageRounded = (average * 10).rounded() / 10
                var text = String(format: "%.1f", averageRounded)
                passToCoreData(value: averageRounded)
                inputCount.removeAll()
                
                text += " mm"
                cell.measureLabel.text = text
                UIView.animate(withDuration: 0.5) {
                    cell.nameLabelCenterPosition.constant = -30
                    
                    if cell.measureLabel.isHidden == true{
                        //cell.nameLabel.transform = cell.nameLabel.transform.scaledBy(x:0.7,y:0.7)
                    }
                    cell.measureLabel.isHidden = false
                    
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}
extension PlicheMoethodController : AllertViewSkinFoldInsertWithGraphDelegate {
    func okAcceptMesure() {
        triceps = nil
        suprailiac = nil
        thigh = nil
        abdominal = nil
        chest = nil
        subscapular = nil
        midaxillary = nil
        biceps = nil
        
        if !UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds") { 
        switch plicheMethod {
        case .sloanMen :
            DataManager.shared.save()
            Items.sharedInstance.updatePliche()
            
        case .DurninMan :
            DataManager.shared.save()
            Items.sharedInstance.updatePliche()
            
        case .sloanWoman :
            DataManager.shared.save()
            Items.sharedInstance.updatePliche()
            
        case .jackson_3_Man :
            Items.sharedInstance.updatePliche()
            
        case .jackson_7 :
            Items.sharedInstance.updatePliche()
            
        default: break
            
        }
            
        } else {
            DataManager.shared.save()
            Items.sharedInstance.updatePliche()
        }
        
    } 
}
