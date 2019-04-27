//
//  SupplementDetails.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 08/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit
import UserNotifications
class SupplementDetailsController: UITableViewController {
    @IBOutlet var contView1: UIView!
    @IBOutlet var circleView: CirclePieView!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var nameProductLabel: UILabel!
    @IBOutlet var brandProductLabel: UILabel!
    @IBOutlet var quantityProductLabel: UILabel!
    @IBOutlet var carbsValueLabel: UILabel!
    @IBOutlet var fatValueLabel: UILabel!
    @IBOutlet var ProteinValueLabel: UILabel!
    @IBOutlet var ingredientsValueLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
    
    @IBOutlet var dailyQuantityTextfield: UITextField!
    @IBOutlet var packageQuantityTextfield: UITextField!
    @IBOutlet var timesWeekTextfield: UITextField!
    
    @IBOutlet var rememberMeSwitch: UISwitch!
    
    @IBOutlet var labelStackView: UIStackView!
    
    @IBOutlet var productImage: UIImageView!
    
    let dailyQuantityPicker = UIPickerView()
    var productImagePassed  : UIImage?
    var productImagePassedAsData : Data!
    
    var productSearched : ProductSearched?
    var productAllreadySearched : Supplement?
    
    
    var requestImage : Request?
    
    var unitArray : [String] = ["gr", "kg", "oz", "lbs"]
    // To ProductSearched
    var dailyQ = ""
    var pckgQ = ""
    var weeklyQty = ""
    var unitString : String = "gr"
    var dailyDose : String = ""
    var packQunatityDoubel : Double!
    var dailyQunatityDoubel : Double!
    var weekQunatityDoubel : Double!
    
    // To productAllreadySearched
    var dateWhenSupplementWillEnd : Date = Date()
    var dateWhenRemindToBuyNewSupplement : Date?
    var labelsToCheck : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.roundTop()
        footerView.roundBottom()
        labelsToCheck = ["vegetarian","gluten free","no gmos","no artificial preservatives","no added sugar","no lactose","organic","EU Organic","vegan"]
        dailyQuantityTextfield.attributedPlaceholder = NSAttributedString(string: "Insert", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        packageQuantityTextfield.attributedPlaceholder = NSAttributedString(string: "Insert", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        timesWeekTextfield.attributedPlaceholder = NSAttributedString(string: "Insert", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        dailyQuantityTextfield.delegate = self
        packageQuantityTextfield.delegate = self
        timesWeekTextfield.delegate = self
        dailyQuantityPicker.delegate = self
        dailyQuantityTextfield.inputView = dailyQuantityPicker
        packageQuantityTextfield.inputView = dailyQuantityPicker
        timesWeekTextfield.inputView = dailyQuantityPicker
        setupView()
        tableView.rowHeight = UITableView.automaticDimension
        
        
       
    }
    
    
    @IBAction func doneButton(_ sender: Any) {
        
       save()
    }
    
    @IBAction func rememberMeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            allertWithParameter(title: loc("Remember me to buy: "), message: ("\(productSearched?.productName ?? loc("This Product"))"), viecontroller: self)
        }
    }
    
    func allertWithParameter(title: String,message: String, viecontroller : UIViewController){
        let allertWeight = UIAlertController(title: title,
                                             message: message,
                                             preferredStyle: .alert)
        allertWeight.addAction(UIAlertAction(title: loc("1 day before"), style: .default, handler: oneDay(alert:)))
        allertWeight.addAction(UIAlertAction(title: loc("2 day before"), style: .default, handler: twoDay(alert:)))
        allertWeight.addAction(UIAlertAction(title: loc("3 day before"), style: .default, handler: threeDay(alert:)))
        allertWeight.addAction(UIAlertAction(title: loc("BUTTON_CANCEL"), style: .default, handler: nil))
        viecontroller.present(allertWeight, animated: true, completion: nil)
    }
    
    func oneDay (alert: UIAlertAction){
        productSearched?.shouldRemind = true
        dateWhenRemindToBuyNewSupplement = dateWhenSupplementWillEnd.addingTimeInterval(-86400)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            // do nothing
        }
    }
    func twoDay (alert: UIAlertAction){
        productSearched?.shouldRemind = true
        dateWhenRemindToBuyNewSupplement = dateWhenSupplementWillEnd.addingTimeInterval(-86400*2)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            // do nothing
        }
    }
    func threeDay (alert: UIAlertAction){
        productSearched?.shouldRemind = true
        dateWhenRemindToBuyNewSupplement = dateWhenSupplementWillEnd.addingTimeInterval(-86400*3)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            // do nothing
        }
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0 : return 40
        case 1 : return 44
        case 2 : return 63
        case 3 : return UITableView.automaticDimension
        case 4 :
            if let p = productSearched {
            if p.labels.isEmpty {
                labelStackView.removeFromSuperview()
                return 0
            }  else {
                return 78 }

            }
        if let p = productAllreadySearched { 
            if let labels = p.labels {
            if labels.isEmpty {
                return 0
            }  else {
                return 78 }
             }
            }
        default:  break
        }
        return 44
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 5 {
                packageQuantityTextfield.becomeFirstResponder()
            }
            if indexPath.row == 6 {
                dailyQuantityTextfield.becomeFirstResponder()
            }
            if indexPath.row == 7 {
                timesWeekTextfield.becomeFirstResponder()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .black
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
}

extension SupplementDetailsController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if packageQuantityTextfield.isFirstResponder {
            return 2
        } else if dailyQuantityTextfield.isFirstResponder{
            return 1
        } else {
            return 1
        }
        
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if packageQuantityTextfield.isFirstResponder {
            if component == 0 {
                return 10000
            } else {
                return unitArray.count
            }
        } else if dailyQuantityTextfield.isFirstResponder {
            return 1000
        } else {
            return 7
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if packageQuantityTextfield.isFirstResponder {
            if component == 0 {
                var rowText = 0.0
                if unitString == "gr" {
                    rowText = Double(row)*1
                }
                if unitString == "kg" {
                    rowText = Double(row)*0.1
                }
                if unitString == "oz" {
                    rowText = Double(row)*1
                }
                if unitString == "lbs" {
                    rowText = Double(row)*0.1
                }
                return String(format: "%.1f", rowText)
            } else {
                return unitArray[row]
            }
        } else if dailyQuantityTextfield.isFirstResponder {
            return String(row+1)
        } else {
            return String(row+1) + " " + "Days"
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if packageQuantityTextfield.isFirstResponder {
            if component == 0 {
                var rowText = 0.0
                if unitString == "gr" {
                    rowText = Double(row)*1
                }
                if unitString == "kg" {
                    rowText = Double(row)*0.1
                }
                if unitString == "oz" {
                    rowText = Double(row)*1
                }
                if unitString == "lbs" {
                    rowText = Double(row)*0.1
                }
                packQunatityDoubel = rowText
                pckgQ =  String(format: "%.1f", rowText)
            } else {
                unitString = unitArray[row];dailyQuantityPicker.reloadComponent(0)
            }
            setUnitCorrectFromPckg()
        } else if dailyQuantityTextfield.isFirstResponder {
            dailyQunatityDoubel = Double(row+1)
            dailyQ = String(row+1)
            setUnitCorrectFromPckg()
        } else {
            weekQunatityDoubel = Double(row+1)
            timesWeekTextfield.text = String(row+1) + " " + "Days"
            weeklyQty = String(row+1) + " " + "Days"
            productSearched?.daysAnWeek = String(row+1) + " " + "Days"
        }
        if !dailyDose.isEmpty && !pckgQ.isEmpty && !weeklyQty.isEmpty {
            endDateLabel.text = endDate()
        } else {
            endDateLabel.text = "Insert all data"
        }
    }
    
    func setUnitCorrectFromPckg() {
        packageQuantityTextfield.text = pckgQ + " " + unitString
        productSearched?.quantityAddedByUser =  pckgQ + " " + unitString
        if unitString == "kg" {
            dailyQuantityTextfield.text = dailyQ + " " + "gr"
            dailyDose = dailyQ + " " + "gr"
            productSearched?.dailyDose = dailyQ + " " + "gr"
        } else if unitString == "lbs" {
            dailyQuantityTextfield.text = dailyQ + " " + "oz"
            dailyDose = dailyQ + " " + "oz"
            productSearched?.dailyDose = dailyQ + " " + "oz"
        } else {
            dailyQuantityTextfield.text = dailyQ + " " + unitString
            dailyDose = dailyQ + " " + unitString
            productSearched?.dailyDose = dailyQ + " " + unitString
        }
        
    }
    
    func remainDaysCalculation() -> Double{
        
        var transfomKgInGr = 0.0
        var transfomLbsInOz = 0.0
        var week = 0.0
        if unitString == "kg" {
            transfomKgInGr = packQunatityDoubel * 1000
            week = transfomKgInGr/(dailyQunatityDoubel*weekQunatityDoubel)
        } else if unitString == "lbs" {
            transfomLbsInOz = packQunatityDoubel * 16
            week = transfomLbsInOz/(dailyQunatityDoubel*weekQunatityDoubel)
        }
        let days = week * 7 
        return days
    }
    
    func endDate () -> String{
        let now = Date()
        dateWhenSupplementWillEnd = now.addingTimeInterval(remainDaysCalculation()*86400)
        if let p = productSearched {
           p.dateWhenSupplementWillEnd = dateWhenSupplementWillEnd
        }
        if let p = productAllreadySearched{
            p.dateWhenSupplementWillEnd = dateWhenSupplementWillEnd as NSDate
        }
        return StaticClass.dateFormat(d: dateWhenSupplementWillEnd as NSDate)
    }
    
}

extension SupplementDetailsController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                                      width: self.view.bounds.size.width,
                                                      height: 44))
        keyboardToolbar.barStyle = UIBarStyle.blackTranslucent
        keyboardToolbar.backgroundColor =  StaticClass.alertViewHeaderColor
        keyboardToolbar.tintColor = UIColor.white
        
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let saveAge = UIBarButtonItem(title: loc("Done"),
                                      style: .done,
                                      target: textField,
                                      action: #selector(resignFirstResponder))
        saveAge.accessibilityIdentifier = "DoneKeyboard"
        
        keyboardToolbar.setItems([flex, saveAge], animated: false)
        
        textField.inputAccessoryView = keyboardToolbar
        dailyQuantityPicker.reloadAllComponents()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
    }
}


extension SupplementDetailsController {
    func setupView() {
        if let p = productSearched {
            nameProductLabel.text = p.productName
            brandProductLabel.text = p.brand
            quantityProductLabel.text = p.quantity
            carbsValueLabel.text = p.carbohydrates
            fatValueLabel.text = p.fatValue
            ProteinValueLabel.text = p.proteinsValue
            ingredientsValueLabel.text = p.ingredientList
            requestImage = request(p.image, method: .get).responseData { rispostaServer in
                if rispostaServer.response != nil {
                    if rispostaServer.request?.url?.absoluteString ==
                        self.requestImage?.request?.url?.absoluteString {
                        if let icona = rispostaServer.data {
                            self.productImage.image = UIImage(data: icona)
                            self.productImagePassedAsData = icona
                        }
                    }
                } else {
                    self.productImage.image = self.productImagePassed
                    print("errore")
                }
            }
            
            for label in p.labels {
                let labelView = LabelProductUIView()
                if labelsToCheck.contains(label) {
                    labelView.labelImage.image = UIImage(named: label)
                    labelView.labelLabel.text = label
                    labelStackView.addArrangedSubview(labelView)
                }
            }
            if p.carbohydrates.isEmpty {
                p.carbohydrates = "0"
            }
            if p.fatValue.isEmpty {
                p.fatValue = "0"
            }
            if p.proteinsValue.isEmpty {
                p.proteinsValue = "0"
            }
            circleView.value = [p.carbohydrates.CGFloatValue(),p.fatValue.CGFloatValue(),p.proteinsValue.CGFloatValue()] as! [CGFloat]
        }
        if let p = productAllreadySearched {
            nameProductLabel.text = p.productName
            brandProductLabel.text = p.brand
            quantityProductLabel.text = p.quantity
            carbsValueLabel.text = p.carbohydrates
            fatValueLabel.text = p.fatValue
            ProteinValueLabel.text = p.proteinsValue
            ingredientsValueLabel.text = p.ingredientList
            rememberMeSwitch.isOn = p.shouldRemind
            dailyQuantityTextfield.text = p.dailyDose
            packageQuantityTextfield.text = p.quantityAddedByUser
            timesWeekTextfield.text = p.daysAnWeek
            endDateLabel.text = StaticClass.dateFormat(d: p.dateWhenSupplementWillEnd!)
            if let image = p.image {
                productImage.image = UIImage(data:image as Data)
            } else {
                productImage.image = UIImage(named: "cameraIcon")
            } 
            if let labels = p.labels {
              
                for label in labels {
                    let labelView = LabelProductUIView()
                    if labelsToCheck.contains(label) {
                        labelView.labelImage.image = UIImage(named: label)
                        labelView.labelLabel.text = label
                        labelStackView.addArrangedSubview(labelView)
                    }
                }
                tableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .fade)
            }
            if p.carbohydrates!.isEmpty {
                p.carbohydrates = "0"
            }
            if p.fatValue!.isEmpty {
                p.fatValue = "0"
            }
            if p.proteinsValue!.isEmpty {
                p.proteinsValue = "0"
            } 
            circleView.value = [p.carbohydrates!.CGFloatValue(),p.fatValue!.CGFloatValue(),p.proteinsValue!.CGFloatValue()] as! [CGFloat]
        }
        
        
    }
    
    func save(){
        if let productSearched = productSearched {
        let now = Date()
        productSearched.uniqueIdentifier = DataManager.shared.uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString 
            if DataManager.shared.supplementCount(maxCount : 1,message: "buy", viecontroller: self) {
                return
            }
            
        _ = DataManager.shared.addSupplement(
            productName: productSearched.productName,
            brand: productSearched.brand,
            quantity: productSearched.quantity,
            ingredientList: productSearched.ingredientList,
            carbohydrates: productSearched.carbohydrates,
            fatValue: productSearched.fatValue,
            dailyDose: productSearched.dailyDose,
            proteinsValue: productSearched.proteinsValue,
            image: productImagePassedAsData,
            labels: productSearched.labels,
            shouldRemind: productSearched.shouldRemind,
            uniqueIdentifier: productSearched.uniqueIdentifier,
            dateWhenSupplementWillEnd: dateWhenSupplementWillEnd,
            quantityAddedByUser: productSearched.quantityAddedByUser,
            daysAnWeek: productSearched.daysAnWeek)
        if let date = dateWhenRemindToBuyNewSupplement {
            productSearched.scheduleNotification(dueDate: date)
        }
         }
        if let productAllreadySearched = productAllreadySearched {
            productAllreadySearched.shouldRemind = rememberMeSwitch.isOn
            productAllreadySearched.dailyDose = dailyDose
            productAllreadySearched.daysAnWeek = weeklyQty
            productAllreadySearched.quantityAddedByUser = pckgQ
            productAllreadySearched.dateWhenSupplementWillEnd = dateWhenSupplementWillEnd as NSDate
            if let date = dateWhenRemindToBuyNewSupplement {
                productAllreadySearched.scheduleNotification(dueDate: date)
            }
        }
        
        DataManager.shared.save()
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: UserSupplementListAndScan.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
