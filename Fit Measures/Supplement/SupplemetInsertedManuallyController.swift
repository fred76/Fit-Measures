//
//  SupplemetInsertedManuallyController.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 15/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit
import UserNotifications
class SupplemetInsertedManuallyController: UITableViewController {
    @IBOutlet var nameText: UITextField!
    @IBOutlet var brandText: UITextField!
    @IBOutlet var carbsText: UITextField!
    @IBOutlet var fatText: UITextField!
    @IBOutlet var proText: UITextField!
    @IBOutlet var pckgQty: UITextField!
    @IBOutlet var dailyText: UITextField!
    @IBOutlet var weekText: UITextField!
    @IBOutlet var headerView: UIView!
    @IBOutlet var footherView: UIView!
    @IBOutlet var completedPckg: UILabel!
    @IBOutlet var supplementImage: UIImageView!
    @IBOutlet var reminder: UISwitch!
    
    let dailyQuantityPicker = UIPickerView()
    var unitArray : [String] = ["gr", "kg", "oz", "lbs"]
    var unitString : String = "gr"
    
    var packQunatityDoubel : Double!
    var dailyQunatityDoubel : Double!
    var weekQunatityDoubel : Double!
    
    var dailyQ = ""
    var pckgQ = ""
    var weeklyQty = ""
    var dailyDose : String = ""
    
    var dateWhenSupplementWillEnd : Date = Date()
    var dateWhenRemindToBuyNewSupplement : Date?
    
    var dataImage : Data?

    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.roundTop()
        footherView.roundBottom()
        nameText.attributedPlaceholder = NSAttributedString(string: "Supplement Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        brandText.attributedPlaceholder = NSAttributedString(string: "Supplement Brand", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        carbsText.attributedPlaceholder = NSAttributedString(string: "Carbs", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        fatText.attributedPlaceholder = NSAttributedString(string: "Fat", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        proText.attributedPlaceholder = NSAttributedString(string: "Pro", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        pckgQty.attributedPlaceholder = NSAttributedString(string: "Insert", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        dailyText.attributedPlaceholder = NSAttributedString(string: "Insert", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        weekText.attributedPlaceholder = NSAttributedString(string: "Insert", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        nameText.delegate = self
        brandText.delegate = self
        carbsText.delegate = self
        fatText.delegate = self
        proText.delegate = self
        pckgQty.delegate = self
        dailyText.delegate = self
        weekText.delegate = self
        dailyQuantityPicker.delegate = self
        pckgQty.inputView = dailyQuantityPicker
        dailyText.inputView = dailyQuantityPicker
        weekText.inputView = dailyQuantityPicker
        
    }
    
    @IBAction func reminder(_ sender: UISwitch) {
        if sender.isOn {
            allertWithParameter(title: loc("Remember me to buy: "), message:  loc("This Product"), viecontroller: self)
        }
    }
    
    func allertWithParameter(title: String,message: String, viecontroller : UIViewController){
        let allertWeight = UIAlertController(title: title,
                                             message: message,
                                             preferredStyle: .alert)
        allertWeight.addAction(UIAlertAction(title: loc("1 day before"), style: .default, handler: oneDay(alert:)))
        allertWeight.addAction(UIAlertAction(title: loc("2 day before"), style: .default, handler: twoDay(alert:)))
        allertWeight.addAction(UIAlertAction(title: loc("3 day before"), style: .default, handler: threeDay(alert:)))
        allertWeight.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        viecontroller.present(allertWeight, animated: true, completion: nil)
    }
    
    func oneDay (alert: UIAlertAction){
        dateWhenRemindToBuyNewSupplement = dateWhenSupplementWillEnd.addingTimeInterval(-86400)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            // do nothing
        }
    }
    func twoDay (alert: UIAlertAction){
        dateWhenRemindToBuyNewSupplement = dateWhenSupplementWillEnd.addingTimeInterval(-86400*2)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            // do nothing
        }
    }
    func threeDay (alert: UIAlertAction){
        dateWhenRemindToBuyNewSupplement = dateWhenSupplementWillEnd.addingTimeInterval(-86400*3)
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) {
            granted, error in
            // do nothing
        }
    }
    
    @IBAction func addSupplement(_ sender: Any) {
        
        let now = Date()
        let uniqueIdentifier = DataManager.shared.uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
        let date = StaticClass.dateFromString(completedPckg.text!)
        if DataManager.shared.supplementCount(maxCount : 1,message: "buy", viecontroller: self) {
            return
        }
        
        let supplement = DataManager.shared.addSupplement(
            productName: nameText.text,
            brand: brandText.text,
            quantity: pckgQty.text,
            ingredientList: "",
            carbohydrates: carbsText.text,
            fatValue: fatText.text,
            dailyDose: dailyText.text,
            proteinsValue: proText.text,
            image: dataImage,
            labels: [],
            shouldRemind: reminder.isOn,
            uniqueIdentifier: uniqueIdentifier,
            dateWhenSupplementWillEnd: date,
            quantityAddedByUser: pckgQty.text,
            daysAnWeek: weekText.text)
        if let date = dateWhenRemindToBuyNewSupplement { 
            supplement.scheduleNotification(dueDate: date) 
        }
        
        DataManager.shared.save()
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: UserSupplementListAndScan.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    

    @IBAction func addPhoto(_ sender: UITapGestureRecognizer) {
        nameText.resignFirstResponder()
        brandText.resignFirstResponder()
        pckgQty.resignFirstResponder()
        dailyText.resignFirstResponder()
        weekText.resignFirstResponder()
        
        let myActionSheet = UIAlertController(title: loc("ACTION_IMAGE_TITLE"),
                                              message: loc("ACTION_IMAGE_TEXT"),
                                              preferredStyle: .actionSheet)
        
        let bLib = UIAlertAction(title: loc("BUTTON_LIBRARY"), style: .default) { (action) in
            CameraManager.shared.newImageLibrary(controller: self, sourceIfPad: nil, editing: false) { image in
                self.supplementImage.image = image
                self.dataImage = DataManager.shared.convertImagetoData(image: image)
            }
        }
        
        myActionSheet.addAction(bLib)
        let bNew = UIAlertAction(title: loc("BUTTON_SHOOT"), style: .destructive) { action in
            let circle = UIImageView(frame: UIScreen.main.bounds)
            circle.image = UIImage(named: "overlay")
            CameraManager.shared.newImageShoot(controller: self, sourceIfPad: nil,
                                               editing: false, overlay: circle) { (image) in
                                                self.supplementImage.image = image
                                                self.dataImage = DataManager.shared.convertImagetoData(image: image)
            }
        }
        
        myActionSheet.addAction(bNew)
        myActionSheet.addAction( UIAlertAction(title: loc("BUTTON_CANCEL"), style: .cancel, handler: nil) )
        present(myActionSheet, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0 : return 40
        case 1 : return 44
        case 2 : return 63
        default:  break
        }
        return 44
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                nameText.becomeFirstResponder()
            }
            if indexPath.row == 1 {
                brandText.becomeFirstResponder()
            }
            if indexPath.row == 3 {
                pckgQty.becomeFirstResponder()
            }
            if indexPath.row == 4 {
                dailyText.becomeFirstResponder()
            }
            if indexPath.row == 4 {
                weekText.becomeFirstResponder()
            }
        }
    }
}

extension SupplemetInsertedManuallyController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        if pckgQty.isFirstResponder {
            return 2
        } else if dailyText.isFirstResponder{
            return 1
        } else {
            return 1
        }
        
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pckgQty.isFirstResponder {
            if component == 0 {
                return 10000
            } else {
                return unitArray.count
            }
        } else if dailyText.isFirstResponder {
            return 1000
        } else {
            return 7
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pckgQty.isFirstResponder {
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
        } else if dailyText.isFirstResponder {
            return String(row+1)
        } else {
            return String(row+1) + " " + loc("Days")
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pckgQty.isFirstResponder {
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
        } else if dailyText.isFirstResponder {
            dailyQunatityDoubel = Double(row+1)
            dailyQ = String(row+1)
            setUnitCorrectFromPckg()
        } else {
            weekQunatityDoubel = Double(row+1)
            weekText.text = String(row+1) + " " + loc("Days")
            weeklyQty = String(row+1) + " " + loc("Days")
        }
        if !dailyDose.isEmpty && !pckgQ.isEmpty && !weeklyQty.isEmpty {
            completedPckg.text = endDate()
        } else {
            completedPckg.text = "Insert all data"
        }
    }
    
    func setUnitCorrectFromPckg() {
        pckgQty.text = pckgQ + " " + unitString
        if unitString == "kg" {
            dailyText.text = dailyQ + " " + "gr"
            dailyDose = dailyQ + " " + "gr"
        } else if unitString == "lbs" {
            dailyText.text = dailyQ + " " + "oz"
            dailyDose = dailyQ + " " + "oz"
        } else {
            dailyText.text = dailyQ + " " + unitString
            dailyDose = dailyQ + " " + unitString
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
      
        return StaticClass.dateFormat(d: dateWhenSupplementWillEnd as NSDate)
    }
    
}

extension SupplemetInsertedManuallyController: UITextFieldDelegate {
    
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
