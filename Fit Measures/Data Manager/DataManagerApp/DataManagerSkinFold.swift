//
//  DataManagerSkinFold.swift
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
}
