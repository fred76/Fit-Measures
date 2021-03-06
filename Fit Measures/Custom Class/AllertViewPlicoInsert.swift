//
//  AllertViewPlicoInsert.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 27/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

protocol CustomAlertViewDelegateThreeTextField: class {
    func okButtonTapped(selectedOption: String, textFieldValue_1: String, textFieldValue_2: String,textFieldValue_3: String)
    func cancelButtonTapped()
}
import UIKit

class AllertViewPlicoInsert: UIViewController {
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var alertTextField_1: UITextField!
    @IBOutlet weak var alertTextField_2: UITextField!
    @IBOutlet weak var alertTextField_3: UITextField!
    @IBOutlet weak var alertView: CustomViewDoubleColor!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet var yConstraint: NSLayoutConstraint!
    
    
    var delegate: CustomAlertViewDelegateThreeTextField?
    
    var selectedOption = "First"
    // BackGround Color
    let alertViewGrayColor = StaticClass.alertViewHeaderColor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertTextField_1.becomeFirstResponder()
        
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
        alertTextField_1.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        alertTextField_1.resignFirstResponder()
        delegate?.okButtonTapped(selectedOption: selectedOption, textFieldValue_1: alertTextField_1.text!, textFieldValue_2: alertTextField_2.text!, textFieldValue_3: alertTextField_3.text!)
        
    }
    
    
    
}
