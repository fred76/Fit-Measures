//
//  SettingsMainTableViewController.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 28/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import MessageUI
import HealthKit
class SettingsMainTableViewController: UITableViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet var heightTextField: UITextField!
    @IBOutlet weak var weightSwitch: UISegmentedControl!
    @IBOutlet weak var biologicalSexSwitch: UISegmentedControl!
    @IBOutlet weak var lenghtSwitch: UISegmentedControl!
    @IBOutlet var ageIcon: UIImageView!
    @IBOutlet var heightIcon: UIImageView!
    @IBOutlet var sexIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ageTextField.delegate = self
        heightTextField.delegate = self
       ageIcon.isHidden = true
       heightIcon.isHidden = true
       sexIcon.isHidden = true 

    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        updateHealthInfo {
            self.updateLabelIfHKnotAvailable()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated) 
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    
    @IBAction func weightSegment(_ sender: Any) {
        switch weightSwitch.selectedSegmentIndex {
        case 0:
            
            UserDefaultsSettings.weightUnitSet = "Kg"
        case 1:
            UserDefaultsSettings.weightUnitSet = "lbs"
            
        default:
            break
        }
    }
    
    @IBAction func lenghtSegment(_ sender: Any) {
        switch lenghtSwitch.selectedSegmentIndex {
        case 0:
            UserDefaultsSettings.lenghtUnitSet = "cm"
        case 1:
            UserDefaultsSettings.lenghtUnitSet = "in"
        default:
            break
        }
    }
    
    @IBAction func sexSegment(_ sender: Any) {
        
        switch biologicalSexSwitch.selectedSegmentIndex {
        case 0:
            UserDefaultsSettings.biologicalSexSet = "Male"
        case 1:
            UserDefaultsSettings.biologicalSexSet = "Female"
        default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                                      width: self.view.bounds.size.width,
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == ageTextField {
            UserDefaultsSettings.ageSet = textField.text?.doubleValue ?? 10.0
        }
        if textField == heightTextField{
            UserDefaultsSettings.heightSet = textField.text?.doubleValue ?? 10.0
        }
        
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["app.user.info@icloud.com"])
            mail.setSubject("About iFit:")
            mail.setMessageBody("<b>Ask question:</b>", isHTML: true)
            present(mail, animated: true, completion: nil)
        } else {
            print("Cannot send mail")
            // give feedback to the user
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        }
        if section == 1 {
            return 3
        }
        return 6
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                ageTextField.becomeFirstResponder()
            }
            if indexPath.row == 1 {
                heightTextField.becomeFirstResponder()
            }
            
        }
       
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                writeReview()
            }
            if indexPath.row == 1 {
                share()
            }
            if indexPath.row == 2 {
                sendEmail()
            }
            
        }
    }
    
    private let productURL = URL(string: "https://itunes.apple.com/app/id1447380258")! 
    private func writeReview() {
        // 1.
        var components = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        
        // 2.
        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        
        // 3.
        guard let writeReviewURL = components?.url else {
            return
        }
        
        // 4.
        UIApplication.shared.open(writeReviewURL)
    }
    
    private func share() {
        let activityViewController = UIActivityViewController(
            activityItems: [productURL],
            applicationActivities: nil)
        
        // 2.
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        let privacyController = segue.destination as? PrivacyController
        
        if segue.identifier == "method"{
            if let lang = Bundle.main.preferredLocalizations.first {
                if lang == "en" {
                    privacyController?.textString = "method" 
                }
                if lang == "it" {
                    privacyController?.textString = "methodIta"
                }
            }
            privacyController?.title = "Method"
            
        }
        if segue.identifier == "Privacy"{
            privacyController?.textString = "Privacy"
            privacyController?.title = "Privacy"
            
        }
        
        if segue.identifier == "Credits"  {
            privacyController?.textString = "Credit"
            privacyController?.title = "Credits"
        }
        
        
        
    }
    private let userHealthProfile = UserHealthProfile()
}

extension SettingsMainTableViewController {
    
    
    private func updateLabelIfHKnotAvailable() {
        
        heightTextField.text = String(UserDefaultsSettings.heightSet)
        ageTextField.text = String(UserDefaultsSettings.ageSet)
        
        if UserDefaultsSettings.weightUnitSet == "Kg" {
            weightSwitch.selectedSegmentIndex = 0
        } else if UserDefaultsSettings.weightUnitSet == "lbs"{
            weightSwitch.selectedSegmentIndex = 1
        }  else {
            weightSwitch.selectedSegmentIndex = -1
        }
        
        if UserDefaultsSettings.lenghtUnitSet == "cm" {
            lenghtSwitch.selectedSegmentIndex = 0
        } else if UserDefaultsSettings.lenghtUnitSet == "in" {
            lenghtSwitch.selectedSegmentIndex = 1
        } else {
            lenghtSwitch.selectedSegmentIndex = -1
        }
        
        if UserDefaultsSettings.biologicalSexSet == "Male" {
            biologicalSexSwitch.selectedSegmentIndex = 0
        } else if UserDefaultsSettings.biologicalSexSet == "Female" {
            biologicalSexSwitch.selectedSegmentIndex = 1
        } else {
            biologicalSexSwitch.selectedSegmentIndex = -1
        }
        
    }
    
    
    
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
                self.heightTextField.isEnabled = false
                UserDefaultsSettings.heightSet = height*100
                let heightFormatter = LengthFormatter()
                heightFormatter.isForPersonHeightUse = true 
                self.heightTextField.text = heightFormatter.string(fromMeters: height)
                self.heightIcon.isHidden = false
            } else {
               self.heightTextField.isEnabled = true
            }
        }
    }
    
    
    private func loadAndDisplayAgeSexAndBloodType() {
        do {
            let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
            userHealthProfile.age = userAgeSexAndBloodType.age
            userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
            
            if let age = userHealthProfile.age {
                ageTextField.isEnabled = false
                UserDefaultsSettings.ageSet = Double(age)
                ageTextField.text = String(age)
                ageIcon.isHidden = false
               
            } else {
                ageTextField.isEnabled = true
            }
            
            if let biologicalSex = userHealthProfile.biologicalSex {
                if biologicalSex == .notSet || biologicalSex == .other
                {
                    biologicalSexSwitch.isEnabled = true
                } else {
                UserDefaultsSettings.biologicalSexSet = biologicalSex.stringRepresentation
                biologicalSexSwitch.isEnabled = false
                
                sexIcon.isHidden = false
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
