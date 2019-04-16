//
//  AllertViewDataInsert.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 27/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//
protocol AllertViewGirthInsertDelegate : class {
    func okButtonTapped(selectedOption: String, textFieldValue: String)
    func cancelButtonTapped()
}
import UIKit

class AllertViewGirthInsert: UIViewController {
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var alertTextField: UITextField!
    @IBOutlet weak var alertView: CustomViewDoubleColor!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet var yConstraint: NSLayoutConstraint!
    
    var showPurchaseInfo : Bool!
    var delegate: AllertViewGirthInsertDelegate?
    var selectedOption = "First"
    // BackGround Color
    let alertViewGrayColor = StaticClass.alertViewHeaderColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTextField.becomeFirstResponder()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            yConstraint.constant = 0
        }
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        cancelButton.addBorder(color: alertViewGrayColor, width: 1)
        okButton.addBorder(color: alertViewGrayColor, width: 1)
        if !UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths") && showPurchaseInfo {
            messageLabel.text = loc("LOCGIRTHSHOP")
            alertTextField.isHidden = true
        } 
        
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        alertTextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        alertTextField.resignFirstResponder()
        delegate?.okButtonTapped(selectedOption: selectedOption, textFieldValue: alertTextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}






