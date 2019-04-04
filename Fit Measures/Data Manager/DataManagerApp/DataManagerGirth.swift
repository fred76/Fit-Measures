//
//  DataManagerGirth.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 02/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import HealthKit
extension DataManager {
    // MARK: - Measure Fetch by:
    
    func getLastMeasureAvailable() -> BodyMeasure? {
        var measure : BodyMeasure?
        
        let fetch = NSFetchRequest<BodyMeasure>(entityName: "BodyMeasure")
        let sortDate = NSSortDescriptor(key: "dateOfEntry", ascending: true)
        fetch.sortDescriptors = [sortDate]
        do {
            let results = try managedContext.fetch(fetch)
            
            
            measure = results.last
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        
        return measure
    }
    
    func assignUniqueIdentifierToMeasure() {
        
        let fetch = NSFetchRequest<BodyMeasure>(entityName: "BodyMeasure")
        do {
            
            let results = try managedContext.fetch(fetch)
            for m in results {
                if m.uniqueIdentifier?.length == 0 {
                    m.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
                }
            }
            save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func assignUniqueIdentifierToPliche() {
        
        let fetch = NSFetchRequest<PlicheMeasure>(entityName: "PlicheMeasure")
        do {
            
            let results = try managedContext.fetch(fetch)
            for m in results {
                if m.uniqueIdentifier?.length == 0 {
                    m.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
                }
            }
            save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func assignUniqueIdentifierToPicFullRes() {
        
        let fetch = NSFetchRequest<PicFullRes>(entityName: "PicFullRes")
        do {
            
            let results = try managedContext.fetch(fetch)
            for m in results {
                if m.uniqueIdentifier?.length == 0 {
                    m.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
                }
            }
            save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func assignUniqueIdentifierToThumb() {
        let fetch = NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
        do {
            
            let results = try managedContext.fetch(fetch)
            for m in results {
                if m.uniqueIdentifier?.length == 0 {
                    m.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
                }
            }
            save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    @discardableResult func bodyMeasurementForTodayIsAvailable() -> (Bool) {
        var count : Int = 0
        var isAdded: Bool = false
        let fetchRequest = NSFetchRequest<BodyMeasure>(entityName: "BodyMeasure")
        fetchRequest.predicate = NSPredicate(format: "dateOfEntry = %@", StaticClass.getDate() as NSDate)
        
        do {
            let arrayOfEntitySearched = try managedContext.fetch(fetchRequest)
            
            count = arrayOfEntitySearched.count
            if count == 1 {
                isAdded = true
            }
            
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
        }
        return isAdded
    }
    
    @discardableResult func bodyMeasurementExist() -> (Bool) {
        var count : Int = 0
        var isAdded: Bool = false
        let fetchRequest = NSFetchRequest<BodyMeasure>(entityName: "BodyMeasure")
        
        do {
            let arrayOfEntitySearched = try managedContext.fetch(fetchRequest)
            
            count = arrayOfEntitySearched.count
            
            if count > 0 {
                isAdded = true
            }
            
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
        }
        return isAdded
    }
    
    func bodyMeasurementFetchAllDateAndSort(with attributeToFetch: String) -> (date : [NSDate],value :[Double]){
        var dateArray : [NSDate] = []
        var ValueArray : [Double] = []
        let fetchRequest = NSFetchRequest<BodyMeasure>(entityName: "BodyMeasure")
        let sort = NSSortDescriptor(key: #keyPath(PlicheMeasure.dateOfEntry), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            for data in results  {
                
                let value = data.value(forKey: "dateOfEntry") as! NSDate
                
                dateArray.append(value)
            }
            for data in results  {
                let value = data.value(forKey: attributeToFetch) as! Double
                ValueArray.append(value)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        
        return (dateArray, ValueArray)
    }
    
    func bodyMeasurementExplode() -> ([BodyMeasure]){
        var measure : [BodyMeasure]?
        let fetchRequest = NSFetchRequest<BodyMeasure>(entityName: "BodyMeasure")
        let sort = NSSortDescriptor(key: #keyPath(PlicheMeasure.dateOfEntry), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            measure = results
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return (measure!)
    }
    
    func bodyMeasurementCount() -> (Int){
        var measure : Int?
        let fetchRequest = NSFetchRequest<BodyMeasure>(entityName: "BodyMeasure")
        let sort = NSSortDescriptor(key: #keyPath(PlicheMeasure.dateOfEntry), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            measure = results.count
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return (measure!)
    }
    
    
    @discardableResult func bodyMeasureAddForCurrentDate(dateofEntry : Date?) -> BodyMeasure {
        
        let addAttribute = NSEntityDescription.insertNewObject(forEntityName: "BodyMeasure", into: managedContext) as! BodyMeasure
        addAttribute.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
        if let dateofEntry = dateofEntry { addAttribute.dateOfEntry = dateofEntry as NSDate }
        return addAttribute
    }
    
    func bodyMeasureAddFromCSV(array : [String]) {
        
        let addAttribute = NSEntityDescription.insertNewObject(forEntityName: "BodyMeasure", into: managedContext) as! BodyMeasure
        addAttribute.weight = Double(array[0]) ?? 0
        addAttribute.bicep_R = Double(array[1]) ?? 0
        addAttribute.bicep_L = Double(array[2]) ?? 0
        addAttribute.bicep_R_Relax = Double(array[3]) ?? 0
        addAttribute.bicep_L_Relax = Double(array[4]) ?? 0
        addAttribute.calf_R = Double(array[5]) ?? 0
        addAttribute.calf_L = Double(array[6]) ?? 0
        addAttribute.chest = Double(array[7]) ?? 0
        addAttribute.forearm_R = Double(array[8]) ?? 0
        addAttribute.forearm_L = Double(array[9]) ?? 0
        addAttribute.hips = Double(array[10]) ?? 0
        addAttribute.neck = Double(array[11]) ?? 0
        addAttribute.thigh_R = Double(array[12]) ?? 0
        addAttribute.thigh_L = Double(array[13]) ?? 0
        addAttribute.waist = Double(array[14]) ?? 0
        addAttribute.wrist = Double(array[15]) ?? 0
        addAttribute.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
        let date = StaticClass.dateFromStringTransform(array[16])
        addAttribute.dateOfEntry = date as NSDate
        HealthManager.addToHealthKit(DataToSave: .bodyMass, unitMeasure: HKQuantity(unit: HKUnit.gram(), doubleValue: (Double(array[0]) ?? 0)*1000), date: date as Date) {
            
        }
        HealthManager.addToHealthKit(DataToSave: .waistCircumference, unitMeasure: HKQuantity(unit: HKUnit.meter(), doubleValue: (Double(array[14]) ?? 0)/100), date: date as Date) {
            
        }
        save()
        
    }
}
