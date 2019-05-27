//
//  GDPRController.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 19/05/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class GDPRController: UIViewController {
    
    @IBOutlet weak var alertView: CustomViewDoubleColor!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textViewBackGround: UIView!
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    var pageMenu : PageMenuIntro!
    
    var selectedOption = "First"
    // BackGround Color
    let alertViewGrayColor = StaticClass.alertViewHeaderColor
    
    var isCheck : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = loc("GDPRPRETEXT")
        setupView()
        animateView()
        cancelButton.layer.cornerRadius = 6
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1
        textViewBackGround.layer.borderColor = UIColor.white.cgColor
        textViewBackGround.layer.cornerRadius = 6
        textViewBackGround.layer.borderWidth = 1
    }
    
    let factsImagesArray = [
        "1A",
        "2A",
        "3A",
        "4A",
        "5A"
    ]
    
    
    func randomFactImage() -> UIImage {
        let unsignedArrayCount = UInt32(factsImagesArray.count)
        let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        let randomNumber = Int(unsignedRandomNumber)
        return UIImage(named: factsImagesArray[randomNumber])!
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
        let indexController = pageMenu.controllerArray.firstIndex(of: self)
        let count = pageMenu.controllerArray.count
        if ConsentManager.shared.consentState(for: ConsentManager.shared.appAnalyticsDisclamer) == .unknown {
            allertWithParameter(title: loc("gdprAlertTXT"), message: loc("gdprAlertBody"), viecontroller: self)
            
            
        } else if count == 1 {
            ConsentManager.shared.launcTabBar(viewcontroller: self) 
        } else if count == 2 {
            switch indexController {
            case 0 :
                if let t =  pageMenu.healthController {
                    pageMenu.didMoveToPage(t, index: 1)
                }
            case 1 : ConsentManager.shared.launcTabBar(viewcontroller: self) 
            default : break
            }
        } else if  count == 3 {
            if let t =  pageMenu.healthController {
                pageMenu.didMoveToPage(t, index: 2)
                
            }
        }
    }
    
    func allertWithParameter(title: String,message: String, viecontroller : UIViewController){
        let allertWeight = UIAlertController(title: title,
                                             message: message,
                                             preferredStyle: .alert)
        allertWeight.addAction(UIAlertAction(title: loc("gdprOK"), style: .default, handler: permissionOK(alert:)))
        allertWeight.addAction(UIAlertAction(title: loc("gdprNotOK"), style: .default, handler: permissionNotOK(alert:)))
        viecontroller.present(allertWeight, animated: true, completion: nil)
    }
    
    func permissionOK (alert: UIAlertAction){ 
        ConsentManager.shared.set(state: .provided, for: ConsentManager.shared.appAnalyticsDisclamer)
        FirebaseManager.shared.startFirebase()
    }
    
    func permissionNotOK (alert: UIAlertAction){
        ConsentManager.shared.set(state: .notProvided, for: ConsentManager.shared.appAnalyticsDisclamer) 
    }
}
