//
//  HealthController.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 19/05/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class HealthController: UIViewController {
    @IBOutlet weak var alertView: CustomViewDoubleColor!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var textViewBackGround: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var image: UIImageView!
    
    var pageMenu : PageMenuIntro!
    
    var selectedOption = "First"
    
    let alertViewGrayColor = StaticClass.alertViewHeaderColor
    
    var isCheck : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = randomFactImage()
        label.text = loc("HELTHTXT")
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
        if ConsentManager.shared.consentState(for: ConsentManager.shared.appHealthDisclamer) == .notProvided || ConsentManager.shared.consentState(for: ConsentManager.shared.appHealthDisclamer) == .unknown {
            cancelButton.titleLabel?.text = loc("Next")
            ConsentManager.shared.authorizeHealthKit()
            
        } else {
            ConsentManager.shared.launcTabBar(viewcontroller: self)
            
        }
    }
}


