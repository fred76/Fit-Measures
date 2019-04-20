//
//  AppDelegateExtension.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 16/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
extension AppDelegate {
    func navBarAppereance() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = true
    }
    
    func tabBarAppereance() {
    if let wTB = ( self.window?.rootViewController as? UITabBarController ) {
        wTB.tabBar.tintColor = StaticClass.blueButton
        wTB.tabBar.barTintColor = UIColor.black
        wTB.tabBar.isTranslucent = true
        if !UserDefaultsSettings.serchForKey(kUsernameKey: "age"){
            wTB.selectedIndex = 4
        }
    }
    }
    func alertAboutiCloud(){
        UserDefaultsSettings.isAlreadyAppearedSet = false
        if !UserDefaultsSettings.cloudSynchSet {
            CKContainer.default().accountStatus { (accountStatus, error) in
                switch accountStatus {
                case .available:
                    DispatchQueue.main.async {
                        DataManager.shared.showTopLevelAlert(title: loc("LOCiCLOUDTITLE"), body: loc("LOCiCLOUDBODY")
                            , alertActionDoIt: self.iClouYesSync())
                    }
                    print("iCloud Available")
                case .noAccount:
                    print("No iCloud account")
                case .restricted:
                    print("iCloud restricted")
                case .couldNotDetermine:
                    print("Unable to determine iCloud status")
                @unknown default: print("Error")
                }
            }
        } else {
            self.setupEnsemble(iCloudIsOn: UserDefaultsSettings.cloudSynchSet)
        }
    }
    func showInitialAlert(){
        if !UserDefaultsSettings.isAlreadyAppearedSet{
            if !UserDefaultsSettings.firstLunchSet {
                let customAlert = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "AllertIntroID") as! AllertViewIntro
                self.window?.rootViewController!.present(customAlert, animated: true, completion: nil)
            }
        }
    }
    
    func setupUnitMeasure(){
        if !UserDefaultsSettings.serchForKey(kUsernameKey: "weightUnit"){
            UserDefaultsSettings.weightUnitSet = "Kg"
        }
        if !UserDefaultsSettings.serchForKey(kUsernameKey: "lenghtUnit"){
            UserDefaultsSettings.lenghtUnitSet = "cm"
        }
        if !UserDefaultsSettings.serchForKey(kUsernameKey: "biologicalSex"){
            UserDefaultsSettings.biologicalSexSet = "Male"
        }
    }
}
