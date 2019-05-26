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
import UserNotifications 

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CDEPersistentStoreEnsembleDelegate, UNUserNotificationCenterDelegate{
    
    var window: UIWindow?
    
    var managedObjectContext: NSManagedObjectContext!
	
	var orientationLock = UIInterfaceOrientationMask.all
	
    var storeDirectoryURL: URL {
        return try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true) }
    
    var storeURL: URL {  return self.storeDirectoryURL.appendingPathComponent("store.sqlite") }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IAPHelper.shared.getProductes(productIds: GandCProducts.productIdentifiers) 
        navBarAppereance()
        tabBarAppereance()
        setupUnitMeasure()
        setupCoreData()
        DataManager.shared.managedContext = managedObjectContext 
        alertAboutiCloud()
        DataManager.shared.loadReceipt()
        AddMobManager.shared.AddMobs()
        ConsentManager.shared.showIntro()
		AppUtility.lockOrientation(.portrait)
        //       CDESetCurrentLoggingLevel(CDELoggingLevel.verbose.rawValue)
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
            for item in notifications {
                print(item.content.body)
            }
        }
        
//        #warning("Remove Bool for test in-App - Enable loadReceipt")
//        let testInApp = false
//        UserDefaults.standard.set(testInApp, forKey: "fred76.com.ifit.girths.unlock")
//        UserDefaults.standard.set(testInApp, forKey: "fred76.com.ifit.skinFolds.unlock")
//        UserDefaults.standard.set(testInApp, forKey: "fred76.com.ifit.bundle.unlock")
//        UserDefaults.standard.set(testInApp, forKey: "fred76.com.ifit.supplement.unlock")
        
        
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
        FirebaseManager.shared.analyticsCollectionPermision(set: UserDefaultsSettings.GDPRStatusSet)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        //showInitialAlert()
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
    
    // MARK:- User Notification Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received local notification \(notification)")
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


