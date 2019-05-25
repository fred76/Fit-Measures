//
//  FirebaseManager.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 16/05/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
class FirebaseManager: NSObject {
    
    static let shared = FirebaseManager()
    
    func startDefaultObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(settingChanged(notification:)), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @objc func settingChanged(notification: NSNotification) {
        if let defaults = notification.object as? UserDefaults {
            defaults.bool(forKey: "GDPRStatus")
        }
    }
    
    
    func startFirebase(){ 
        startDefaultObserver()
        FirebaseApp.configure()
        analyticsCollectionPermision(set: false)
        if ConsentManager.shared.consentState(for: ConsentManager.shared.appAnalyticsDisclamer) == .unknown {
             print("Firebase consent .unknown")
            print("UserDefaultsSettings.GDPRStatusSet - \(UserDefaultsSettings.GDPRStatusSet)")
            return
        } else if ConsentManager.shared.consentState(for: ConsentManager.shared.appAnalyticsDisclamer) == .notProvided {
            print("Firebase consent .notProvided")
            analyticsCollectionPermision(set: UserDefaultsSettings.GDPRStatusSet)
            print("UserDefaultsSettings.GDPRStatusSet - \(UserDefaultsSettings.GDPRStatusSet)")
            return
        } else if ConsentManager.shared.consentState(for: ConsentManager.shared.appAnalyticsDisclamer) == .provided {
            
            
            analyticsCollectionPermision(set: UserDefaultsSettings.GDPRStatusSet)
            print("Firebase consent .provided")
            print("UserDefaultsSettings.GDPRStatusSet - \(UserDefaultsSettings.GDPRStatusSet)")
        }
        
    }
    
    
    func analyticsCollectionPermision(set:Bool) {
        Analytics.setAnalyticsCollectionEnabled(set)
         
    }
    
    func trackUserEvent(value: String, name: String){
        Analytics.setUserProperty(value, forName: name)
        
    }
    
    func trackScreenClass(screenName:String, screenClass: String){
        Analytics.setScreenName(screenName, screenClass: screenClass)
       
    }
    
    func trackLogEvent(type:String, id: String){
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [AnalyticsParameterContentType:type, AnalyticsParameterItemID:id])
        
    }
}
