//
//  ConsentManager.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 22/05/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
public enum ConsentState: Int {
    case unknown = -2
    case notProvided = -1
    case provided = 1
}

class ConsentManager: NSObject {
    
    static let shared = ConsentManager()
    private var window: UIWindow?
    
    let appDoctorDisclamer: ConsentManager.Consent = "firstLunch"
    let appAnalyticsDisclamer: ConsentManager.Consent = "GDPRStatus"
    let appHealthDisclamer: ConsentManager.Consent = "healthKitStatus" 
    let appCloudSynchDisclamer: ConsentManager.Consent = "cloudSynch"
    
    func set(state: ConsentState, for consent: Consent) {
        switch state {
        case .unknown:
            UserDefaults.standard.removeObject(forKey: consent)
        case .provided:
            UserDefaults.standard.set(true, forKey: consent)
        case .notProvided:
            UserDefaults.standard.set(false, forKey: consent)
        }
        UserDefaults.standard.synchronize()
    }
    
    @discardableResult func consentState(for consent: Consent) -> ConsentState {
        guard let value = UserDefaults.standard.object(forKey: consent) as? Bool else {
            return .unknown
        }
        return value ? .provided: .notProvided
    }
    
    func launcTabBar(viewcontroller : UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultController = storyboard.instantiateViewController(withIdentifier: "MyTabbarControllerID") as? MyTabbarController {
            resultController.tabBar.tintColor = StaticClass.blueButton
            resultController.tabBar.barTintColor = UIColor.black
            resultController.tabBar.isTranslucent = true
            if !UserDefaultsSettings.serchForKey(kUsernameKey: "age"){
                resultController.selectedIndex = 4
            }
            viewcontroller.present(resultController, animated: true, completion: nil)
        }
    }
    
    func showIntro(){
       
        let consent = ConsentManager.shared
         print("consent.consentState(for: consent.appAnalyticsDisclamer) - \(consent.consentState(for: consent.appAnalyticsDisclamer))")
        print("consent.consentState(for: appDoctorDisclamer) - \(consent.consentState(for: consent.appDoctorDisclamer))")
        window = UIWindow()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "IntroMenu") as! PageMenuIntro
        var showMenu = false
        if consentState(for: consent.appDoctorDisclamer) == .unknown || consent.consentState(for: consent.appDoctorDisclamer) == .notProvided {
            showMenu = true
            viewController.introController = AllertViewIntro()
        }
        
        if consent.consentState(for: consent.appAnalyticsDisclamer) == .unknown {
            showMenu = true
            viewController.gDPRController = GDPRController()
        } else {
            FirebaseManager.shared.startFirebase() 
        }
        
        if consent.consentState(for: consent.appHealthDisclamer) == .unknown {
            showMenu = true
            viewController.healthController = HealthController()
        } else if consent.consentState(for: consent.appHealthDisclamer) == .provided { 
            authorizeHealthKit()
        }
        
        if showMenu {
            window?.windowLevel += 1
            window?.rootViewController = viewController
            window?.makeKeyAndVisible()
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MyTabbarControllerID") as! MyTabbarController
            viewController.tabBar.tintColor = StaticClass.blueButton
            viewController.tabBar.barTintColor = UIColor.black
            viewController.tabBar.isTranslucent = true
            if !UserDefaultsSettings.serchForKey(kUsernameKey: "age"){ viewController.selectedIndex = 4 }
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            
            
        }
    }
    
}
extension ConsentManager {
    public typealias Consent = String
}

extension ConsentManager {
    func authorizeHealthKit() {
        HealthManager.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                self.set(state: .notProvided, for: self.appHealthDisclamer)
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            self.set(state: .provided, for: self.appHealthDisclamer)
            print("HealthKit Successfully Authorized.")
            
        }
    }
}
