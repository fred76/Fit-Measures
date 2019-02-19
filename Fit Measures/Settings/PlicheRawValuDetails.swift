//
//  PlicheRawValuDetails.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 25/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit
private struct ItemDefPliche {
    let title: String
    var value: String
    let unit: String
}

class PlicheRawValuDetails: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    fileprivate let rawDataId = "RawDataIdDetails"
    private var itemDef : [ItemDefPliche]!
    var show:Bool! = false
    var measure:PlicheMeasure!
    
    @IBOutlet var plicheTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plicheTableView.delegate = self
        plicheTableView.dataSource = self
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
        Items.sharedInstance.updatePliche()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func keyboardDidShow(with notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        var contentInset = self.plicheTableView.contentInset
        contentInset.bottom += keyboardFrame.height+44
        
        plicheTableView.contentInset = contentInset
        plicheTableView.scrollIndicatorInsets = contentInset
    }
    
    @objc func keyboardWillHide(with notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        
        var contentInset = self.plicheTableView.contentInset
        contentInset.bottom -= keyboardFrame.height-44
        
        plicheTableView.contentInset = contentInset
        plicheTableView.scrollIndicatorInsets = contentInset
    }
    
    func readItemDef(){
        if let m = measure {
            self.title = StaticClass.dateFormat(d: m.dateOfEntry!)
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
            itemDef=[
                ItemDefPliche(title: "Weight", value: returnString(d: m.weight), unit: UserDefaultsSettings.weightUnitSet),
                ItemDefPliche(title: "Age", value: returnString(d: m.age), unit: ""),
                ItemDefPliche(title: "Abdominal", value: returnString(d: m.abdominal), unit: "mm"),
                ItemDefPliche(title: "Biceps", value: returnString(d: m.biceps), unit: "mm"),
                ItemDefPliche(title: "Triceps", value: returnString(d: m.triceps), unit: "mm"),
                ItemDefPliche(title: "Chest", value: returnString(d: m.chest), unit: "mm"),
                ItemDefPliche(title: "Midaxillary", value: returnString(d: m.midaxillary), unit: "mm"),
                ItemDefPliche(title: "Subscapular", value: returnString(d: m.subscapular), unit: "mm"),
                ItemDefPliche(title: "Suprailiac", value: returnString(d: m.suprailiac), unit: "mm"),
                ItemDefPliche(title: "Thigh", value: returnString(d: m.thigh), unit: "mm"),
                ItemDefPliche(title: "Method", value: m.method!, unit: ""),
                ItemDefPliche(title: "Sum", value: returnString(d: m.sum), unit: "mm"),
                ItemDefPliche(title: "BodyDensity", value: returnString(d: m.bodyDensity), unit: "g/cc"),
                ItemDefPliche(title: "BodyFatPerc", value: returnString(d: m.bodyFatPerc), unit: "%"),
                ItemDefPliche(title: "LeanMass", value: returnString(d: m.leanMass), unit: UserDefaultsSettings.weightUnitSet)
            ]
            self.plicheTableView.rowHeight = 50
            
            
        }
    }
    func returnString(d:Double)->String{
        return String(format: "%.1f", d)
    }
    @objc func addTapped (){
        show = !show
        if show {
            self.navigationItem.rightBarButtonItem?.title = "Done"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        
        plicheTableView.reloadData()
    }
    
    
    
    
    
    func edit(index : IndexPath,str : String) {
        var def = self.itemDef![index.row]
        if let m = measure {
            
            if def.title == "Weight" { m.weight = str.doubleValue; def.value = str }
            if def.title == "Age" { m.weight = str.doubleValue; def.value = str }
            if def.title == "Abdominal" { m.abdominal = str.doubleValue ; def.value = str }
            if def.title == "Biceps" { m.biceps = str.doubleValue ; def.value = str }
            if def.title == "Triceps" { m.triceps = str.doubleValue ; def.value = str }
            if def.title == "Chest" { m.chest = str.doubleValue ; def.value = str }
            if def.title == "Midaxillary" { m.midaxillary = str.doubleValue; def.value = str }
            if def.title == "Subscapular" { m.subscapular = str.doubleValue; def.value = str }
            if def.title == "Suprailiac" { m.suprailiac = str.doubleValue ; def.value = str }
            if def.title == "Thigh" { m.thigh = str.doubleValue; def.value = str }
            if def.title == "Method" { m.method = str ; def.value = str }
            if def.title == "Sum" { m.sum = str.doubleValue ; def.value = str }
            if def.title == "BodyDensity" { m.bodyDensity = str.doubleValue ; def.value = str }
            if def.title == "BodyFatPerc" { m.bodyFatPerc = str.doubleValue ; def.value = str }
            if def.title == "LeanMass" { m.leanMass = str.doubleValue ; def.value = str }
            DataManager.shared.save()
            readItemDef()
            plicheTableView.reloadData()
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let pointInTable = textField.convert(textField.bounds.origin, to: self.plicheTableView)
        let textFieldIndexPath = self.plicheTableView.indexPathForRow(at: pointInTable)
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
        guard let cell = cell as? PlicheRawValuDetailsCell else {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: rawDataId, for: indexPath) as! PlicheRawValuDetailsCell
        
        configure(cell: cell, for: indexPath)
        
        return cell
    }
    
    
    
    
    
}




import UIKit

class PlicheRawValuDetailsCell: UITableViewCell{
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var unit: UILabel!
    
    
}
