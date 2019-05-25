//
//  AllertViewIntro.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 27/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

//protocol AllertViewIntroDelegate : class {
//    func okButtonTapped(isShow: Bool)
//    func cancelButtonTapped()
//}
import UIKit

class AllertViewIntro: UIViewController {
    @IBOutlet weak var alertView: CustomViewDoubleColor!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var image: UIImageView!
    
    var pageMenu : PageMenuIntro!
    
    var selectedOption = "First"
    // BackGround Color
    let alertViewGrayColor = StaticClass.alertViewHeaderColor
    var isCheck : Bool = false
    @IBOutlet var checkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = randomFactImage()
        
        textView.text = loc("INTROTXT")
        setupView()
        animateView()
        checkLabel.text = ""
        cancelButton.layer.cornerRadius = 6
        cancelButton.layer.borderColor = UIColor.white.cgColor
        cancelButton.layer.borderWidth = 1
        checkLabel.layer.borderColor = UIColor.white.cgColor
        checkLabel.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.white.cgColor
        textView.layer.cornerRadius = 6
        textView.layer.borderWidth = 1
    }
    
    let factsImagesArray = [
        "AAA1",
        "AAA2",
        "AAA3",
        "AAA4",
        "AAA5",
        "AAA6",
        "AAA7",
        "AAA8"
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //
        
    }
    
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
        if let t =  pageMenu.gDPRController {
            pageMenu.didMoveToPage(t, index: 1)
        } else if let y = pageMenu.healthController  {
            pageMenu.didMoveToPage(y, index: 1)
        } else {
            ConsentManager.shared.launcTabBar(viewcontroller: self) 
        } 
    }
    
    @IBAction func onTapOkButton(_ sender: Any) {
        
        isCheck = !isCheck
        if isCheck {
            checkLabel.text = "✓"
            
            ConsentManager.shared.set(state: .provided, for: ConsentManager.shared.appDoctorDisclamer)
        } else {
            checkLabel.text = ""
            
            ConsentManager.shared.set(state: .notProvided, for: ConsentManager.shared.appDoctorDisclamer)
        }
        
    }
    
}






