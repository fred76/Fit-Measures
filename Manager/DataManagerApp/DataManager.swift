//
//  DataManager.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 29/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import CoreData
import HealthKit
import StoreKit

class DataManager: NSObject, SKRequestDelegate {
    static let shared = DataManager()
    
    // MARK: - CoreData:
    var bodyMeasure : BodyMeasure!
    var plicheMeasure : PlicheMeasure!
    var fetchedResultsControllerMeasure: NSFetchedResultsController<BodyMeasure>?
    var fetchRequest: NSFetchRequest<BodyMeasure>! = BodyMeasure.fetchRequest()
    var managedContext: NSManagedObjectContext!
    var fetchedResultsControllerPictures: NSFetchedResultsController<Thumbnail>?
    
    func save() { do {try! managedContext.save()
        print("database salvato")}}
    
    // MARK: - Measure Add:
    
    let uuid = UUID().uuidString
    let now = Date()
    
   // MARK: - Photos:
    
    let convertQueue = DispatchQueue(label: "convertQueue", attributes: .concurrent)
    let saveQueue = DispatchQueue(label: "saveQueue", attributes: .concurrent)
    
    // MARK: - original_application_version:
    
    let productionStoreURL = URL(string: "https://buy.itunes.apple.com/verifyReceipt")
    let sandboxStoreURL = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")
    let receiptURL = Bundle.main.appStoreReceiptURL
    
   
}

