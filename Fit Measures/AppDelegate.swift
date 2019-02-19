//
//  AppDelegate.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 25/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var managedObjectContext: NSManagedObjectContext!
    var storeDirectoryURL: URL {
        return try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) }
    
    var storeURL: URL {  return self.storeDirectoryURL.appendingPathComponent("store.sqlite") }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = true

        setupCoreData() 
        DataManager.shared.managedContext = managedObjectContext
        
        if !UserDefaultsSettings.serchForKey(kUsernameKey: "weightUnit"){
            UserDefaultsSettings.weightUnitSet = "Kg"
        }
        if !UserDefaultsSettings.serchForKey(kUsernameKey: "lenghtUnit"){
            UserDefaultsSettings.lenghtUnitSet = "cm"
        }
        if !UserDefaultsSettings.serchForKey(kUsernameKey: "biologicalSex"){
            UserDefaultsSettings.biologicalSexSet = "Male"
        }
//        if !UserDefaultsSettings.serchForKey(kUsernameKey: "age"){
//            UserDefaultsSettings.ageSet = 0.0
//        }
        if let wTB = ( self.window?.rootViewController as? UITabBarController ) {
            wTB.tabBar.tintColor = StaticClass.blueButton
            wTB.tabBar.barTintColor = UIColor.black
            wTB.tabBar.isTranslucent = true
            if !UserDefaultsSettings.serchForKey(kUsernameKey: "age"){
                wTB.selectedIndex = 4
            }
        }
        authorizeHealthKit()
       UserDefaultsSettings.isAlreadyAppearedSet = false
        
    
        return true
    }
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == .keyboard) { 
            return false
        }
        return true
    }
    var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) {
        if !UserDefaultsSettings.isAlreadyAppearedSet{
            if !UserDefaultsSettings.firstLunchSet {
                let customAlert = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "AllertIntroID") as! AllertViewIntro
                self.window?.rootViewController!.present(customAlert, animated: true, completion: nil)
            }
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) { }
    
   
    
    func setupCoreData() {
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")
        let model = NSManagedObjectModel(contentsOf: modelURL!)
        try! FileManager.default.createDirectory(at: self.storeDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: self.storeURL, options: options)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}

extension AppDelegate {
    private func authorizeHealthKit() {
        
        HealthManager.authorizeHealthKit { (authorized, error) in
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }
        
    }
}
