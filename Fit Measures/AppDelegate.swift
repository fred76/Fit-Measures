//
//  AppDelegate.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 25/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import CoreData
import Ensembles
import CloudKit
import StoreKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CDEPersistentStoreEnsembleDelegate{
    
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
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
         
        // Use verbose logging for sync
//       CDESetCurrentLoggingLevel(CDELoggingLevel.verbose.rawValue)
        
        
        setupCoreData()
        DataManager.shared.managedContext = managedObjectContext
        
        if !UserDefaultsSettings.serchForKey(kUsernameKey: "appVersion"){
            UserDefaultsSettings.appVersionSet = appVersion ?? "0"
        }
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
        
        DataManager.shared.loadReceipt()
        return true
        
    }
   
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let taskIdentifier = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        try! managedObjectContext.save()
        self.sync(iCloudIsOn: UserDefaultsSettings.cloudSynchSet) {
            UIApplication.shared.endBackgroundTask(taskIdentifier)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.sync(iCloudIsOn: UserDefaultsSettings.cloudSynchSet, nil)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       
        if !UserDefaultsSettings.isAlreadyAppearedSet{
            if !UserDefaultsSettings.firstLunchSet {
                let customAlert = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "AllertIntroID") as! AllertViewIntro
                self.window?.rootViewController!.present(customAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) { }
    
    
    
    func iClouYesSync() -> UIAlertAction {
        let enableiCloudSync = UIAlertAction(title: "OK", style: .default) { (action) in
            UserDefaultsSettings.cloudSynchSet = true
            self.setupEnsemble(iCloudIsOn: UserDefaultsSettings.cloudSynchSet)
        }
        return enableiCloudSync
    }
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == .keyboard) {
            return false
        }
        return true
    }
    
    var orientationLock = UIInterfaceOrientationMask.all
    
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
    
    // MARK: Notification Handlers
    
    @objc func localSaveOccurred(_ notif: Notification) {
        self.sync(iCloudIsOn: UserDefaultsSettings.cloudSynchSet, nil)
    }
    
    @objc func cloudDataDidDownload(_ notif: Notification) {
        self.sync(iCloudIsOn: UserDefaultsSettings.cloudSynchSet, nil)
    }
    
    // MARK: Ensembles
    
    func setupEnsemble(iCloudIsOn : Bool) {
        if !iCloudIsOn {
            return
        }
        // Setup Ensemble
        let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd")
        cloudFileSystem = CDEICloudFileSystem(ubiquityContainerIdentifier: nil)
        ensemble = CDEPersistentStoreEnsemble(ensembleIdentifier: "GANDC", persistentStore: storeURL, managedObjectModelURL: modelURL!, cloudFileSystem: cloudFileSystem)
        ensemble.delegate = self
        
        // Listen for local saves, and trigger merges
        NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.localSaveOccurred(_:)), name:NSNotification.Name.CDEMonitoredManagedObjectContextDidSave, object:nil)
        NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.cloudDataDidDownload(_:)), name:NSNotification.Name.CDEICloudFileSystemDidDownloadFiles, object:nil)
        
        //        // Pass context to controller
        //        let controller = self.window?.rootViewController as! ViewController
        //        controller.managedObjectContext = managedObjectContext
        //
        // Sync
        self.sync(iCloudIsOn: UserDefaultsSettings.cloudSynchSet, nil)
    }
    
    var cloudFileSystem: CDECloudFileSystem!
    
    var ensemble: CDEPersistentStoreEnsemble!
    
    func sync(iCloudIsOn : Bool ,_ completion: (() -> Void)?) {
        if !iCloudIsOn {
            return
        }
        if !ensemble.isLeeched {
            ensemble.leechPersistentStore {
                error in
                completion?()
            }
        }
        else {
            ensemble.merge {
                error in
                completion?()
            }
        }
    }
    
    func persistentStoreEnsemble(_ ensemble: CDEPersistentStoreEnsemble, didSaveMergeChangesWith notification: Notification) {
        managedObjectContext.performAndWait {
            self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    func persistentStoreEnsemble(_ ensemble: CDEPersistentStoreEnsemble!, globalIdentifiersForManagedObjects objects: [Any]!) -> [Any]! {
       // let uniqueId = (objects as NSArray).value(forKeyPath: "uniqueIdentifier") as! [AnyObject]
        
        return (objects as NSArray).value(forKeyPath: "uniqueIdentifier") as! [AnyObject]
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
