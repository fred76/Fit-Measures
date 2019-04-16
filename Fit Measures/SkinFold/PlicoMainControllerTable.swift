//
//  PlicoMainControllerTable.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 27/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit

import GoogleMobileAds

class PlicoMainControllerTable: UITableViewController,GADInterstitialDelegate {
    var interstitial: GADInterstitial!
    var showInterstitial : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad() 
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        interstitial = createAndLoadInterstitial()
        showInterstitial = true
    }
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        showInterstitial = true
        interstitial = createAndLoadInterstitial()
    }
    @IBOutlet var jackso7: CustomViewDoubleColor!
    @IBOutlet var jackson3: CustomViewDoubleColor!
    // @IBOutlet var jackson4: CustomViewDoubleColor!
    @IBOutlet var sloan: CustomViewDoubleColor!
    @IBOutlet var durnin: CustomViewDoubleColor!
    var check = UIImageView()
    var layerTriangle = CAShapeLayer()
    var identitifier3site : String = ""
    var identitifier7site : String = ""
    
    override func viewWillAppear(_ animated: Bool) { 
        tableView.reloadData()
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if showInterstitial {
            return true
        } else {
            return false
        }
    }
    override func viewDidLayoutSubviews() {
        if DataManager.shared.plicheMeasurementExist() {
            
            let m = DataManager.shared.plicheFetchAllDateAndSort(with: "sum").method.last
            
            layerTriangle.removeFromSuperlayer()
            check.removeFromSuperview()
            
            if m == "jackson & Polloc 7 point" {
                if UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds") {
                    AddChecker(v: jackso7)
                }
                
            }
            
            if m == "jackson & Polloc 3 point Man" || m == "jackson & Polloc 3 point Woman"{
                if UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds") {
                    AddChecker(v: jackson3)
                }
            }
            if m == "Sloan - Men 2 point" || m == "Sloan - Woman 2 point"{
                AddChecker(v: sloan)
            }
            if m == "Durnin & Womersley Man 4 Pliche" {
                AddChecker(v: durnin)
            }
            
        }
    }
    
   
    func AddChecker(v:CustomViewDoubleColor) {
        let rectanglePath = UIBezierPath()
        let height : CGFloat = v.bounds.height
        let width : CGFloat = v.bounds.width
        let trimmer : CGFloat = (v.bounds.height-16)/1.5
        rectanglePath.move(to: CGPoint(x: width-trimmer, y: height))
        rectanglePath.addLine(to: CGPoint(x: width, y: height))
        rectanglePath.addLine(to: CGPoint(x: width, y: height-trimmer))
        layerTriangle.path = rectanglePath.cgPath
        layerTriangle.fillColor = StaticClass.alertViewHeaderColor.cgColor
        v.layer.insertSublayer(layerTriangle, at: 1)
        check.bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        check.frame.origin = CGPoint(x: rectanglePath.bounds.midX, y: rectanglePath.bounds.midY)
        check.image = UIImage(named: "Check")
        check.contentMode = .scaleAspectFit
        v.addSubview(check)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    
    @IBOutlet weak var labelOneJP: UILabel!
    @IBOutlet weak var labelTwoJP: UILabel!
    @IBOutlet weak var labelThreeJP: UILabel!
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 2 {
            if UserDefaultsSettings.biologicalSexSet == "Male" {
                labelOne.text = loc("LOCALThigh")
                labelTwo.text = loc("LOCALSubscapular")
            } else {
                labelOne.text = loc("LOCALSuprailiac")
                labelTwo.text = loc("LOCALTriceps")
            }
        }
        if indexPath.row == 1 {
            if UserDefaultsSettings.biologicalSexSet == "Male" { 
                labelOneJP.text = loc("LOCALChest")
                labelTwoJP.text = loc("LOCALAbdominal")
                labelThreeJP.text = loc("LOCALThigh")
            } else { 
                labelOneJP.text = loc("LOCALTriceps")
                labelTwoJP.text = loc("LOCALSuprailiac")
                labelThreeJP.text = loc("LOCALThigh")
            }
        }
    }
    
    
    
    
    // MARK: - Navigation jackson_7 durnin Sloan
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { 
        if segue.identifier == "jackson_3" {
            if  DataManager.shared.purchasedGirthsAndSkinfilds() { print("something purchased") } else {
                if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
            }

            }
            let plicoMethodSelected = segue.destination as! PlicheMoethodController
            if UserDefaultsSettings.biologicalSexSet == "Male" {
                plicoMethodSelected.plicheMethod = .jackson_3_Man
            } else {
                plicoMethodSelected.plicheMethod = .jackson_3_Woman
            }
        }
        
        if segue.identifier == "jackson_7" {
            if  DataManager.shared.purchasedGirthsAndSkinfilds() { print("something purchased") } else {
                if interstitial.isReady {
                    interstitial.present(fromRootViewController: self)
                } else {
                    print("Ad wasn't ready")
                }
                
            }
            let plicoMethodSelected = segue.destination as! PlicheMoethodController
            plicoMethodSelected.plicheMethod = .jackson_7
        }
        
        if segue.identifier == "Sloan" {
            let plicoMethodSelected = segue.destination as! PlicheMoethodController
            if UserDefaultsSettings.biologicalSexSet == "Male" {
                plicoMethodSelected.plicheMethod = .sloanMen
            } else {
                plicoMethodSelected.plicheMethod = .sloanWoman
            }
        }
        
        if segue.identifier == "durnin" {
            let plicoMethodSelected = segue.destination as! PlicheMoethodController
            plicoMethodSelected.plicheMethod = .DurninMan
        }
        
    }
    
}
