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
    
    var bodyMeasure : BodyMeasure!
    var plicheMeasure : PlicheMeasure!
    static let shared = DataManager()
    
    var fetchedResultsControllerMeasure: NSFetchedResultsController<BodyMeasure>?
    var fetchRequest: NSFetchRequest<BodyMeasure>! = BodyMeasure.fetchRequest()
    var managedContext: NSManagedObjectContext!
    var fetchedResultsControllerPictures: NSFetchedResultsController<Thumbnail>?
    
    func save() { do {try! managedContext.save()
        }}
    
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
    
    // MARK: - Measure Add:
    let uuid = UUID().uuidString
    
    let now = Date()
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
    
    // MARK: - Measure Fetch by:
    
    func getLastPlicheAvailable() -> (PlicheMeasure?) {
        
        var measure : PlicheMeasure?
        let fetchRequest2 = NSFetchRequest<PlicheMeasure>(entityName: "PlicheMeasure")
        let sortDate = NSSortDescriptor(key: "dateOfEntry", ascending: true)
        fetchRequest2.sortDescriptors = [sortDate]
        do {
            let arrayOfEntitySearched = try managedContext.fetch(fetchRequest2)
            measure = arrayOfEntitySearched.last
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
        }
        return (measure)
    }
    
    @discardableResult func plicheForTodayIsVavailable() -> (Bool) {
        var count : Int = 0
        var isAdded: Bool = false
        let fetchRequest = NSFetchRequest<PlicheMeasure>(entityName: "PlicheMeasure")
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
    
    @discardableResult func plicheMeasurementExist() -> (Bool) {
        var count : Int = 0
        var isAdded: Bool = false
        let fetchRequest = NSFetchRequest<PlicheMeasure>(entityName: "PlicheMeasure")
        
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
    
    func plicheFetchAllDateAndSort(with attributeToFetch: String) -> (date : [NSDate],value :[Double], method : [String]){
        var dateArray : [NSDate] = []
        var ValueArray : [Double] = []
        var MethodArray : [String] = []
        let fetchRequest = NSFetchRequest<PlicheMeasure>(entityName: "PlicheMeasure")
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
            for data in results  {
                let value = data.value(forKey: "method") as! String
                MethodArray.append(value)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        
        return (dateArray, ValueArray, MethodArray)
    }
    
    func plicheExplode() -> ([PlicheMeasure]){
        var measure : [PlicheMeasure]?
        let fetchRequest = NSFetchRequest<PlicheMeasure>(entityName: "PlicheMeasure")
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
    
    
    // MARK: - Pliche Add:
    func plicheAddFromCSV(array : [String]) {
        let plicheValueEntry = NSEntityDescription.insertNewObject(forEntityName: "PlicheMeasure", into: managedContext) as! PlicheMeasure
        
        
        let lastWeight : Double = Double(array[0]) ?? 0
        var sum : Double = 0
        var bodyDensity : Double = 0
        var bodyFatPerc : Double = 0
        var leanMass : Double = 0
        var dateToHK : Date!
        plicheValueEntry.weight = Double(array[0]) ?? 0
        
        if array[10] == "jp7" {
            
            
            plicheValueEntry.chest = Double(array[3]) ?? 0
            plicheValueEntry.abdominal = Double(array[1]) ?? 0
            plicheValueEntry.thigh = Double(array[7]) ?? 0
            plicheValueEntry.midaxillary = Double(array[4]) ?? 0
            plicheValueEntry.suprailiac = Double(array[6]) ?? 0
            plicheValueEntry.subscapular = Double(array[5]) ?? 0
            plicheValueEntry.triceps = Double(array[8]) ?? 0
            plicheValueEntry.method = "jackson & Polloc 7 point"
            let date = StaticClass.dateFromStringTransform(array[9])
            dateToHK = date
            plicheValueEntry.dateOfEntry = date as NSDate
            
            sum = plicheValueEntry.chest+plicheValueEntry.abdominal+plicheValueEntry.thigh+plicheValueEntry.midaxillary+plicheValueEntry.suprailiac+plicheValueEntry.subscapular+plicheValueEntry.triceps
            plicheValueEntry.method = "jackson & Polloc 7 point"
            if UserDefaultsSettings.biologicalSexSet == "Male"{
                let s = (0.00000055 * (sum*sum))
                let a = (0.00028826 * Double(array[11])!)
                bodyDensity = 1.112-(0.00043499 * sum) + s - a
                bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
            } else {
                let t =  (0.00012828 * Double(array[11])!)
                bodyDensity = 1.097-(0.00046971 * sum) + (0.00000056 * (sum*sum)) - t
                bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
            }
            
        }
        if array[10] == "jp3m"{
            plicheValueEntry.chest = Double(array[3]) ?? 0
            plicheValueEntry.abdominal = Double(array[1]) ?? 0
            plicheValueEntry.thigh = Double(array[7]) ?? 0
            plicheValueEntry.method = "jackson & Polloc 3 point Man"
            let dateDoube = StaticClass.dateFromStringSince1970(array[9])
            
            let date =  NSDate(timeIntervalSince1970: dateDoube)
            dateToHK = date as Date
            plicheValueEntry.dateOfEntry = date
            
            
            sum = plicheValueEntry.chest+plicheValueEntry.abdominal+plicheValueEntry.thigh
            let s = (0.0000016 * (sum*sum))
            let a = (0.0002574 * Double(array[11])!)
            bodyDensity = 1.10938-(0.0008267 * sum) + s - a
            bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
            
            
        }
        if array[10] == "jp3w" {
            plicheValueEntry.thigh = Double(array[7]) ?? 0
            plicheValueEntry.suprailiac = Double(array[6]) ?? 0
            plicheValueEntry.triceps = Double(array[8]) ?? 0
            plicheValueEntry.method = "jackson & Polloc 3 point Woman"
            let date = StaticClass.dateFromStringTransform(array[9])
            dateToHK = date
            plicheValueEntry.dateOfEntry = date as NSDate
            
            sum = plicheValueEntry.thigh+plicheValueEntry.suprailiac+plicheValueEntry.triceps
            let t = (0.0000023 * (sum*sum)) - (0.0001392 * Double(array[11])!)
            bodyDensity = 1.0994921-(0.0009929 * sum) + t
            bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
            
            
        }
        if array[10] == "sm" {
            plicheValueEntry.thigh = Double(array[7]) ?? 0
            plicheValueEntry.subscapular = Double(array[5]) ?? 0
            plicheValueEntry.method = "Sloan - Men 2 point"
            let t = Double(array[7]) ?? 0
            let s = Double(array[5]) ?? 0
            let date = StaticClass.dateFromStringTransform(array[9])
            dateToHK = date
            plicheValueEntry.dateOfEntry = date as NSDate
            let a = 0.001327 * t
            let b = 0.00131  * s
            bodyDensity = 1.1043-(a) - (b)
            bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
            sum = plicheValueEntry.thigh+plicheValueEntry.subscapular
            save()
        }
        if array[10] == "sw" {
            plicheValueEntry.suprailiac = Double(array[6]) ?? 0
            plicheValueEntry.triceps = Double(array[8]) ?? 0
            let s = Double(array[6]) ?? 0
            let t = Double(array[8]) ?? 0
            plicheValueEntry.method = "Sloan - Woman 2 point"
            let date = StaticClass.dateFromStringTransform(array[9])
            dateToHK = date
            plicheValueEntry.dateOfEntry = date as NSDate
            let a = 0.0008 * s
            let b = 0.00088 * t
            bodyDensity = 1.0764-(a) - (b)
            bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
            sum = plicheValueEntry.suprailiac+plicheValueEntry.triceps
        }
        if array[10] == "dw" {
            
            plicheValueEntry.biceps = Double(array[2]) ?? 0
            plicheValueEntry.suprailiac = Double(array[6]) ?? 0
            plicheValueEntry.subscapular = Double(array[5]) ?? 0
            plicheValueEntry.triceps = Double(array[8]) ?? 0
            plicheValueEntry.method = "Durnin & Womersley Man 4 Pliche"
            let date = StaticClass.dateFromStringTransform(array[9])
            dateToHK = date
            plicheValueEntry.dateOfEntry = date as NSDate
            
            
            sum = plicheValueEntry.biceps+plicheValueEntry.suprailiac+plicheValueEntry.subscapular+plicheValueEntry.triceps
            let age = Double(array[11]) ?? 0
            if UserDefaultsSettings.biologicalSexSet == "Male"{
                switch age {
                case 0..<17: bodyDensity = 1.1533-(0.0643 * log10(sum))
                case 17..<19: bodyDensity = 1.1620-(0.0630 * log10(sum))
                case 19..<29: bodyDensity = 1.1631-(0.0632 * log10(sum))
                case 29..<39: bodyDensity = 1.1422-(0.0544 * log10(sum))
                case 39..<49: bodyDensity = 1.1620-(0.0700 * log10(sum))
                case 49..<100: bodyDensity = 1.1715-(0.0779 * log10(sum))
                default:
                    break
                }
                bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
            } else {
                switch age {
                case 0..<17: bodyDensity = 1.1369-(0.0598 * log10(sum))
                case 17..<19: bodyDensity = 1.1549-(0.0678 * log10(sum))
                case 19..<29: bodyDensity = 1.1599-(0.0717 * log10(sum))
                case 29..<39: bodyDensity = 1.1423-(0.0632 * log10(sum))
                case 39..<49: bodyDensity = 1.1333-(0.0612 * log10(sum))
                case 49..<100: bodyDensity = 1.1339-(0.0645 * log10(sum))
                default:
                    break
                }
                bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
            }
            
        }
        plicheValueEntry.sum = sum
        plicheValueEntry.bodyDensity = bodyDensity
        plicheValueEntry.bodyFatPerc = bodyFatPerc
        plicheValueEntry.leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
        leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
        plicheValueEntry.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
        save()
        
        HealthManager.addToHealthKit(DataToSave: .bodyFatPercentage, unitMeasure: HKQuantity(unit: HKUnit.percent(), doubleValue: bodyFatPerc/100), date: dateToHK) {
            
        }
        HealthManager.addToHealthKit(DataToSave: .leanBodyMass, unitMeasure: HKQuantity(unit: HKUnit.gram(), doubleValue: leanMass*1000), date: dateToHK) {
            
        }
        HealthManager.addToHealthKit(DataToSave: .bodyMass, unitMeasure: HKQuantity(unit: HKUnit.gram(), doubleValue: lastWeight*1000), date: dateToHK) {
            
        }
        
    }
    
    
    
    
    func plicheAddedByUser(abdominal: Double?, biceps: Double?,chest: Double?,midaxillary: Double?,subscapular: Double?,suprailiac: Double?,thigh: Double?,triceps: Double?, viewVontroller : UIViewController,plicheMethod : String) -> (sum : Double,bodyDensity : Double,bodyFatPerc : Double,leanMass : Double,fatMass : Double,lastWeight : Double) {
        
        // let plicheMethod = PlicheMethods.jackson_3_Man
        var plicheValueEntry : PlicheMeasure!
        if plicheForTodayIsVavailable() {
            plicheValueEntry = getLastPlicheAvailable()!
        }
        else {
            plicheValueEntry = NSEntityDescription.insertNewObject(forEntityName: "PlicheMeasure", into: managedContext) as? PlicheMeasure
            plicheValueEntry.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
            
        }
        
        
        var lastWeight : Double = 0
        if let lastWeightA = getLastMeasureAvailable()?.weight {
            lastWeight = lastWeightA
        }
        
        
        var sum : Double = 0
        var bodyDensity : Double = 0
        var bodyFatPerc : Double = 0
        var leanMass : Double = 0
        var fatMass : Double = 0
        plicheValueEntry.weight = lastWeight
        if plicheMethod == "jackson & Polloc 7 point" {
            if let chest = chest, let abdominal = abdominal, let thigh = thigh,let midaxillary = midaxillary,let suprailiac = suprailiac,let subscapular = subscapular,let triceps = triceps {
                plicheValueEntry.chest = chest
                plicheValueEntry.abdominal = abdominal
                plicheValueEntry.thigh = thigh
                plicheValueEntry.midaxillary = midaxillary
                plicheValueEntry.suprailiac = suprailiac
                plicheValueEntry.subscapular = subscapular
                plicheValueEntry.triceps = triceps
                plicheValueEntry.method = plicheMethod
                plicheValueEntry.dateOfEntry = StaticClass.getDate() as NSDate
                plicheValueEntry.age = UserDefaultsSettings.ageSet
                
                if UserDefaultsSettings.biologicalSexSet == "Male"{
                    // Densità corporea = 1.112-(0.00043499 X SUM7) + (0.00000055 X (SUM72) - (0.00028826 X età) - SUM7 = torace + addome + coscia + ascellare + soprailiaca + sottoscapolare + tricipite
                    sum = chest+abdominal+thigh+midaxillary+suprailiac+subscapular+triceps
                    bodyDensity = 1.112-(0.00043499 * sum) + (0.00000055 * (sum*sum)) - (0.00028826 * UserDefaultsSettings.ageSet)
                    bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
                } else {
                    // Densità corporea= 1.097 - (0.00046971 X SUM7) + (0.00000056 X SUM72 ) - (0.00012828 X età) - SUM7 = torace + addome + coscia + ascellare + soprailiaca + sottoscapolare + tricipite
                    
                    sum = chest+abdominal+thigh+midaxillary+suprailiac+subscapular+triceps
                    bodyDensity = 1.097-(0.00046971 * sum) + (0.00000056 * (sum*sum)) - (0.00012828 * UserDefaultsSettings.ageSet)
                    bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
                }
                plicheValueEntry.sum = sum
                plicheValueEntry.bodyDensity = bodyDensity
                plicheValueEntry.bodyFatPerc = bodyFatPerc
                plicheValueEntry.leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                fatMass = lastWeight - leanMass
                //save()()
            } else {
                allertWithParameter(title: "WARNING", message: "Entry All Measurement", viecontroller: viewVontroller)
            }
        }
        
        // Densità corporea = 1.10938 - (0.0008267 x SUM3) + (0.0000016 x SUM32 ) - (0.0002574 x età) - SUM3 = torace + addome + coscia
        if plicheMethod == "jackson & Polloc 3 point Man" {
            if let chest = chest, let abdominal = abdominal, let thigh = thigh {
                plicheValueEntry.chest = chest
                plicheValueEntry.abdominal = abdominal
                plicheValueEntry.thigh = thigh
                plicheValueEntry.method = plicheMethod
                plicheValueEntry.dateOfEntry = StaticClass.getDate() as NSDate
                plicheValueEntry.age = UserDefaultsSettings.ageSet
                sum = chest+abdominal+thigh
                bodyDensity = 1.10938-(0.0008267 * sum) + (0.0000016 * (sum*sum)) - (0.0002574 * UserDefaultsSettings.ageSet)
                bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
                
                plicheValueEntry.sum = sum
                plicheValueEntry.bodyDensity = bodyDensity
                plicheValueEntry.bodyFatPerc = bodyFatPerc
                plicheValueEntry.leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                fatMass = lastWeight - leanMass
                //save()()
            } else {
                allertWithParameter(title: loc("WARNING"), message: loc("Entry All Measurement"), viecontroller: viewVontroller)
            }
        }
        
        // Densità corporea= 1.0994921 - (0.0009929 x SUM3) + (0.0000023 x SUM32 ) - (0.0001392 x età) - SUM3 = tricipite + soprailiaca + coscia
        if plicheMethod == "jackson & Polloc 3 point Woman" {
            if let thigh = thigh, let suprailiac = suprailiac, let triceps = triceps {
                plicheValueEntry.thigh = thigh
                plicheValueEntry.suprailiac = suprailiac
                plicheValueEntry.triceps = triceps
                plicheValueEntry.method = plicheMethod
                plicheValueEntry.dateOfEntry = StaticClass.getDate() as NSDate
                plicheValueEntry.age = UserDefaultsSettings.ageSet
                sum = thigh+suprailiac+triceps
                bodyDensity = 1.0994921-(0.0009929 * sum) + (0.0000023 * (sum*sum)) - (0.0001392 * UserDefaultsSettings.ageSet)
                bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
                
                plicheValueEntry.sum = sum
                plicheValueEntry.bodyDensity = bodyDensity
                plicheValueEntry.bodyFatPerc = bodyFatPerc
                plicheValueEntry.leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                fatMass = lastWeight - leanMass
                //save()()
            } else {
                allertWithParameter(title: loc("WARNING"), message: loc("Entry All Measurement"), viecontroller: viewVontroller)
            }
        }
        if plicheMethod == "Sloan - Men 2 point" { //D= 1,1043-0,001327 x pl.coscia – 0,00131 x pl.sottoscapolare
            if let thigh = thigh, let subscapular = subscapular {
                plicheValueEntry.thigh = thigh
                plicheValueEntry.subscapular = subscapular
                plicheValueEntry.method = plicheMethod
                plicheValueEntry.dateOfEntry = StaticClass.getDate() as NSDate
                plicheValueEntry.age = UserDefaultsSettings.ageSet
                sum = thigh+subscapular
                bodyDensity = 1.1043-(0.001327 * thigh) - (0.00000055 * subscapular)
                bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
                
                plicheValueEntry.sum = sum
                plicheValueEntry.bodyDensity = bodyDensity
                plicheValueEntry.bodyFatPerc = bodyFatPerc
                plicheValueEntry.leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                fatMass = lastWeight - leanMass
                //save()()
            } else {
                allertWithParameter(title: loc("WARNING"), message: loc("Entry All Measurement"), viecontroller: viewVontroller)
            }
        }
        
        if plicheMethod == "Sloan - Woman 2 point" { //D= 1,0764 – 0,00081 x pl.soprailiaca – 0,00088 x pl.tricipitale
            if let suprailiac = suprailiac, let triceps = triceps {
                plicheValueEntry.suprailiac = suprailiac
                plicheValueEntry.triceps = triceps
                plicheValueEntry.method = plicheMethod
                plicheValueEntry.dateOfEntry = StaticClass.getDate() as NSDate
                plicheValueEntry.age = UserDefaultsSettings.ageSet
                sum = suprailiac+triceps
                bodyDensity = 1.0764-(0.0008 * suprailiac) - (0.00088 * triceps)
                bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
                
                plicheValueEntry.sum = sum
                plicheValueEntry.bodyDensity = bodyDensity
                plicheValueEntry.bodyFatPerc = bodyFatPerc
                plicheValueEntry.leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                fatMass = lastWeight - leanMass
                //save()()
            } else {
                allertWithParameter(title: loc("WARNING"), message: loc("Entry All Measurement"), viecontroller: viewVontroller)
            }
        }
        
        if plicheMethod == "Durnin & Womersley Man 4 Pliche" {
            if let biceps = biceps,let suprailiac = suprailiac,let subscapular = subscapular,let triceps = triceps {
                plicheValueEntry.biceps = biceps
                plicheValueEntry.suprailiac = suprailiac
                plicheValueEntry.subscapular = subscapular
                plicheValueEntry.triceps = triceps
                plicheValueEntry.method = plicheMethod
                plicheValueEntry.dateOfEntry = StaticClass.getDate() as NSDate
                plicheValueEntry.age = UserDefaultsSettings.ageSet
                let age = UserDefaultsSettings.ageSet
                if UserDefaultsSettings.biologicalSexSet == "Male"{
                    // D= 1,1631– 0,0632 x log10 (pl.bicipite+ tricip.+sottoscap.+soprail.)
                    sum = triceps+biceps+subscapular+suprailiac
                    switch age {
                    case 0..<17: bodyDensity = 1.1533-(0.0643 * log10(sum))
                    case 17..<19: bodyDensity = 1.1620-(0.0630 * log10(sum))
                    case 19..<29: bodyDensity = 1.1631-(0.0632 * log10(sum))
                    case 29..<39: bodyDensity = 1.1422-(0.0544 * log10(sum))
                    case 39..<49: bodyDensity = 1.1620-(0.0700 * log10(sum))
                    case 49..<100: bodyDensity = 1.1715-(0.0779 * log10(sum))
                    default:
                        break
                    }
                    
                    bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
                } else {
                    // D= 1,1599– 0,0717 x log10 (pl.bicipite+ tricip.+sottoscap.+soprail.)
                    
                    sum = triceps+biceps+subscapular+suprailiac
                    switch age {
                    case 0..<17: bodyDensity = 1.1369-(0.0598 * log10(sum))
                    case 17..<19: bodyDensity = 1.1549-(0.0678 * log10(sum))
                    case 19..<29: bodyDensity = 1.1599-(0.0717 * log10(sum))
                    case 29..<39: bodyDensity = 1.1423-(0.0632 * log10(sum))
                    case 39..<49: bodyDensity = 1.1333-(0.0612 * log10(sum))
                    case 49..<100: bodyDensity = 1.1339-(0.0645 * log10(sum))
                    default:
                        break
                    }
                    bodyFatPerc = ((4.95/bodyDensity) - 4.5) * 100
                }
                plicheValueEntry.sum = sum
                plicheValueEntry.bodyDensity = bodyDensity
                plicheValueEntry.bodyFatPerc = bodyFatPerc
                plicheValueEntry.leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                leanMass = lastWeight - ((lastWeight/100)*bodyFatPerc)
                fatMass = lastWeight - leanMass
                //save()
            } else {
                allertWithParameter(title: loc("WARNING"), message: loc("Entry All Measurement"), viecontroller: viewVontroller)
            }
        }
        
        HealthManager.addToHealthKit(DataToSave: .bodyFatPercentage, unitMeasure: HKQuantity(unit: HKUnit.percent(), doubleValue: bodyFatPerc/100), date: StaticClass.getDate()) {
            
        }
        
        HealthManager.addToHealthKit(DataToSave: .leanBodyMass, unitMeasure: HKQuantity(unit: HKUnit.gram(), doubleValue: leanMass*1000), date: StaticClass.getDate()) {
            
        }
        
        return (sum, bodyDensity,bodyFatPerc,leanMass,fatMass, lastWeight)
    }
    
    // MARK: - AllertView:
    
    func allertWithParameter(title: String,message: String, viecontroller : UIViewController){
        let allertWeight = UIAlertController(title: title,
                                             message: message,
                                             preferredStyle: .alert)
        allertWeight.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        viecontroller.present(allertWeight, animated: true, completion: nil)
    }
    
    
    
    func allertWeight(viecontroller : UIViewController){
        let Weight = getLastMeasureAvailable()!.weight
        let allertWeight = UIAlertController(title: loc("Noitce"),
                                             message: "Last Weight used \n \(Weight) Kg",
            preferredStyle: .alert)
        allertWeight.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        viecontroller.present(allertWeight, animated: true, completion: nil)
    }
    
    
    let convertQueue = DispatchQueue(label: "convertQueue", attributes: .concurrent)
    
    let saveQueue = DispatchQueue(label: "saveQueue", attributes: .concurrent)
    
    func deletPic(t: PicFullRes){
        managedContext.delete(t)
        save()
    }
    
    func saveImage(imageData:NSData, thumbnailData:NSData, date: Double) {
      saveQueue.sync {
            // create new objects in moc
            guard let moc = self.managedContext else {
                return
            }
            guard let fullRes = NSEntityDescription.insertNewObject(forEntityName: "PicFullRes", into: moc) as? PicFullRes, let thumbnail = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: moc) as? Thumbnail else {
                // handle failed new object in moc
                print("moc error")
                return
            }
            //set image data of fullres
            fullRes.imageData = imageData
            fullRes.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
            //set image data of thumbnail
            thumbnail.imageData = thumbnailData
            thumbnail.id = date
            thumbnail.fullRes = fullRes
            thumbnail.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) + "thumbnail" as NSString
        
            // save the new objects
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // clear the moc
            moc.refreshAllObjects()
        }
    }
    
    func prepareImageForSaving(image:UIImage, closure: @escaping ()->()) {
        
        // use date as unique id
        let date : Double = NSDate().timeIntervalSince1970
        
        // dispatch with gcd.
        convertQueue.async {
            // create NSData from UIImage
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            // scale image, I chose the size of the VC because it is easy
            let thumbnaill = image
            guard let thumbnailData  = thumbnaill.jpegData(compressionQuality: 0.7)  else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // send to save function
            self.saveImage(imageData: imageData as NSData, thumbnailData: thumbnailData as NSData, date: date)
            
        }
        closure()
    }
    
    func showTopLevelAlert(title : String, body : String, alertActionDoIt : UIAlertAction) {
        let alertController = UIAlertController (title: title , message: body, preferredStyle: .alert)
        alertController.addAction(alertActionDoIt)
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - original_application_version:
    
    private let productionStoreURL = URL(string: "https://buy.itunes.apple.com/verifyReceipt")
    
    private let sandboxStoreURL = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")
    
    let receiptURL = Bundle.main.appStoreReceiptURL
    
    func loadReceipt()  {
        print("com.ifit.girths \(UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths"))")
        print("com.ifit.skinFolds \(UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds"))")
        print("com.ifit.bundle \(UserDefaults.standard.bool(forKey: "fred76.com.ifit.bundle"))")
        if UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths") || UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds") || UserDefaults.standard.bool(forKey: "fred76.com.ifit.bundle") {
            return
        }
        guard let receiptURL = receiptURL else {print("NO URL"); return }
        do {
            let receipt = try Data(contentsOf: receiptURL)
            verifyIfPurchasedBeforeFreemium(productionStoreURL!, receipt)
        } catch {
            let appReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
            appReceiptRefreshRequest.delegate = self
            appReceiptRefreshRequest.start()
        }
        
    }
    
    private func verifyIfPurchasedBeforeFreemium(_ storeURL: URL, _ receipt: Data) {
        do {
            let requestContents:Dictionary = ["receipt-data": receipt.base64EncodedString()]
            let requestData = try JSONSerialization.data(withJSONObject: requestContents, options: [])
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            
            URLSession.shared.dataTask(with: storeRequest) { (data, response, error) in
                DispatchQueue.main.async {
                    if data != nil {
                        do {
                            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any?]
                            
                            if let statusCode = jsonResponse["status"] as? Int {
                                if statusCode == 21007 {
                                    print("Switching to test against sandbox")
                                    self.verifyIfPurchasedBeforeFreemium(self.sandboxStoreURL!, receipt)
                                }
                            }
                            if let receiptResponse = jsonResponse["receipt"] as? [String: Any?],
                                let original_application_version = receiptResponse["original_application_version"] as? String {
                                
                                //                                let dateFormatter = DateFormatter()
                                //                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                                //                                let dateObject = dateFormatter.date(from: original_purchase_date)
                                //
                                //                                let n = Date()
                                
                                if original_application_version.doubleValue < 0 {
                                    UserDefaults.standard.set(true, forKey: "fred76.com.ifit.girths")
                                    UserDefaults.standard.set(true, forKey: "fred76.com.ifit.skinFolds")
                                    UserDefaults.standard.set(true, forKey: "fred76.com.ifit.bundle")
                                }
                            }
                        } catch {
                            print("Error: " + error.localizedDescription)
                        }
                    }
                }
                
                }.resume()
        } catch {
            print("Error: " + error.localizedDescription)
        }
    }
    func requestDidFinish(_ request: SKRequest) {
        print("Refresh")
        // a fresh receipt should now be present at the url
        do {
            let receipt = try Data(contentsOf: receiptURL!) //force unwrap is safe here, control can't land here if receiptURL is nil
            verifyIfPurchasedBeforeFreemium(productionStoreURL!, receipt)
        } catch {
            // still no receipt, possible but unlikely to occur since this is the "success" delegate method
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("app receipt refresh request did fail with error: \(error)")
        // for some clues see here: https://samritchie.net/2015/01/29/the-operation-couldnt-be-completed-sserrordomain-error-100/
    }
    private func isPaidVersionNumber(_ originalVersion: String) -> Bool {
        let pattern:String = "^\\d+\\.\\d+"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let results = regex.matches(in: originalVersion, options: [], range: NSMakeRange(0, originalVersion.count))
            
            let original = results.map {
                Double(originalVersion[Range($0.range, in: originalVersion)!])
            }
            
            if original.count > 0, original[0]! < 3 {
                print("App purchased prior to Freemium model")
                return true
            }
        } catch {
            print("Paid Version RegEx Error.")
        }
        return false
    }
    
   
}



enum FilterType : String {
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
}


