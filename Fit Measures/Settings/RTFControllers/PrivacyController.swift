//
//  PrivacyController.swift
//  iDrug
//
//  Created by Alberto Lunardini on 09/09/17.
//  Copyright © 2017 Alberto Lunardini. All rights reserved.
//

import UIKit

class PrivacyController: UIViewController {
    @IBOutlet weak var Text: UITextView!
    
    var textString : String!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        if let rtfPath = Bundle.main.url(forResource: textString!, withExtension: "rtf") {
        
            do {
                let attributedStringWithRtf: NSAttributedString = try NSAttributedString(url: rtfPath, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                self.Text.attributedText = attributedStringWithRtf
            } catch let error {
                print("Got an error \(error)")
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Text.setContentOffset(CGPoint.zero, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
