//
//  measureRowValueDetails.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 23/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
private struct ItemDef {
    let title: String
    var value: String
    let unit: String
}

class GirthsRowValueDetails: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    fileprivate let rawDataId = "RawDataIdDetails"
    private var itemDef : [ItemDef]!
    var show:Bool! = false
    var measure:BodyMeasure!
    @IBOutlet weak var measureTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        measureTableView.delegate = self
        measureTableView.dataSource = self
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(addTapped))
        
        readItemDef()
   
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(with:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(with:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        Items.sharedInstance.updateMaesure()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardDidShow(with notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        var contentInset = self.measureTableView.contentInset
        contentInset.bottom += keyboardFrame.height+44
        
        measureTableView.contentInset = contentInset
        measureTableView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(with notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        var contentInset = self.measureTableView.contentInset
        contentInset.bottom -= keyboardFrame.height-44
        
        measureTableView.contentInset = contentInset
        measureTableView.scrollIndicatorInsets = contentInset
    }
    
    func readItemDef(){
        if let m = measure {
            self.title = StaticClass.dateFormat(d: m.dateOfEntry!)
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            itemDef=[
                ItemDef(title: "Weight", value: returnString(d: m.weight), unit: UserDefaultsSettings.weightUnitSet),
                ItemDef(title: "Neck", value: returnString(d: m.neck), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Chest", value: returnString(d: m.chest), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Bicep_R", value: returnString(d: m.bicep_R), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Bicep_L", value: returnString(d: m.bicep_L), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Bicep_R_Relax", value: returnString(d: m.bicep_R_Relax), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Bicep_L_Relax", value: returnString(d: m.bicep_L_Relax), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Forearm_R", value: returnString(d: m.forearm_R), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Forearm_L", value: returnString(d: m.forearm_L), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Wrist", value: returnString(d: m.wrist), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Waist", value: returnString(d: m.waist), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Hips", value: returnString(d: m.hips), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Thigh_R", value: returnString(d: m.thigh_R), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Thigh_L", value: returnString(d: m.thigh_L), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Calf_R", value: returnString(d: m.calf_R), unit: UserDefaultsSettings.lenghtUnitSet),
                ItemDef(title: "Calf_L", value: returnString(d: m.calf_L), unit: UserDefaultsSettings.lenghtUnitSet)
            ]
            self.measureTableView.rowHeight = 50 
            
        }
    }
    @objc func addTapped (){
        show = !show
        if show {
            self.navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        
        measureTableView.reloadData()
    }
    
    func returnString(d:Double)->String{
        return String(format: "%.1f", d)
    }
    
  

    func edit(index : IndexPath,str : String) {
        var def = self.itemDef![index.row]
        if let m = measure {
            if def.title == "Weight" { m.weight = str.doubleValue; def.value = str }
            if def.title == "Neck" { m.neck = str.doubleValue ; def.value = str }
            if def.title == "Chest" { m.chest = str.doubleValue ; def.value = str }
            if def.title == "Bicep_R" { m.bicep_R = str.doubleValue ; def.value = str }
            if def.title == "Bicep_L" { m.bicep_L = str.doubleValue ; def.value = str }
            if def.title == "Bicep_R_Relax" { m.bicep_R_Relax = str.doubleValue ; def.value = str }
            if def.title == "Bicep_L_Relax" { m.bicep_L_Relax = str.doubleValue ; def.value = str }
            if def.title == "Forearm_R" { m.forearm_R = str.doubleValue; def.value = str }
            if def.title == "Forearm_L" { m.forearm_L = str.doubleValue; def.value = str }
            if def.title == "Wrist" { m.wrist = str.doubleValue ; def.value = str }
            if def.title == "Waist" { m.waist = str.doubleValue; def.value = str }
            if def.title == "Hips" { m.hips = str.doubleValue ; def.value = str }
            if def.title == "Thigh_R" { m.thigh_R = str.doubleValue ; def.value = str }
            if def.title == "Thigh_L" { m.thigh_L = str.doubleValue ; def.value = str }
            if def.title == "Calf_R" { m.calf_R = str.doubleValue ; def.value = str }
            DataManager.shared.save()
            readItemDef()
            measureTableView.reloadData()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let pointInTable = textField.convert(textField.bounds.origin, to: self.measureTableView)
        let textFieldIndexPath = self.measureTableView.indexPathForRow(at: pointInTable)
        let str = textField.text
        edit(index: (textFieldIndexPath)!, str: str!)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                                      width: 300,
                                                      height: 44))
        keyboardToolbar.barStyle = UIBarStyle.blackTranslucent
        keyboardToolbar.backgroundColor =  StaticClass.alertViewHeaderColor
        keyboardToolbar.tintColor = UIColor.white
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let saveAge = UIBarButtonItem(title: "Done",
                                      style: .done,
                                      target: textField,
                                      action: #selector(resignFirstResponder))
        keyboardToolbar.setItems([flex, saveAge], animated: false)
        textField.inputAccessoryView = keyboardToolbar
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.itemDef.count }
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        let def = self.itemDef[indexPath.row]
        guard let cell = cell as? measureRowValueDetailsCell else {
            return
        }
        cell.value.borderStyle = UITextField.BorderStyle.none
        cell.value.isEnabled = false
        cell.value.clearButtonMode = .never
        if show {
            cell.value.clearButtonMode = .always
            cell.value.borderStyle = UITextField.BorderStyle.roundedRect
            cell.value.isEnabled = true
            cell.value.delegate = self
        }
        //  cell.delegate = self
        cell.title.text = def.title
        cell.value.text = def.value
        cell.unit.text = def.unit
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rawDataId, for: indexPath) as! measureRowValueDetailsCell
        
        configure(cell: cell, for: indexPath)
        
        return cell
    }
    
    
    
    
    
}




import UIKit

class measureRowValueDetailsCell: UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var unit: UILabel!
    
   
}
