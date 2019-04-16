//
//  DataManagerSupplement.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 14/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import CoreData
import UIKit
extension DataManager {
    @discardableResult func addSupplement(
        productName : String?,
        brand : String?,
        quantity : String?,
        ingredientList : String?,
        carbohydrates : String?,
        fatValue : String?,
        dailyDose : String?,
        proteinsValue : String?,
        image : Data?,
        labels : [String]?,
        shouldRemind :Bool?,
        uniqueIdentifier: NSString?,
        dateWhenSupplementWillEnd: Date?,
        quantityAddedByUser: String?,
        daysAnWeek: String?) -> Supplement{
        
        let addAttribute = NSEntityDescription.insertNewObject(forEntityName: "Supplement", into: managedContext) as! Supplement
        if let p = productName
        {addAttribute.productName = p}
        if let p = brand
        {addAttribute.brand = p}
        if let p = quantity
        {addAttribute.quantity = p}
        if let p = ingredientList
        {addAttribute.ingredientList = p}
        if let p = carbohydrates
        {addAttribute.carbohydrates = p}
        if let p = fatValue
        {addAttribute.fatValue = p}
        if let p = dailyDose
        {addAttribute.dailyDose = p}
        if let p = proteinsValue
        {addAttribute.proteinsValue = p}
        if let p = image
        {addAttribute.image = p as NSData}
        if let p = labels
        {addAttribute.labels = p}
        if let p = shouldRemind
        {addAttribute.shouldRemind = p}
        if let p = uniqueIdentifier
        {addAttribute.uniqueIdentifier = p as String}
        if let p = dateWhenSupplementWillEnd
        {addAttribute.dateWhenSupplementWillEnd = p as NSDate}
        if let p = quantityAddedByUser
        {addAttribute.quantityAddedByUser = p}
        if let p = daysAnWeek
        {addAttribute.daysAnWeek = p}
        return addAttribute
    }
    
    func convertImagetoData(image:UIImage) -> Data?{  
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                print("jpg error")
                return nil}
        return imageData
    }
    
    func supplementCount(maxCount : Int, message: String, viecontroller : UIViewController) -> Bool {
        var maxLimit : Bool = false
        let fetchRequest = NSFetchRequest<Supplement>(entityName: "Supplement")
        
        do {
            let arrayOfEntitySearched = try managedContext.fetch(fetchRequest)
            if arrayOfEntitySearched.count >= maxCount && !UserDefaults.standard.bool(forKey: "fred76.com.ifit.supplement"){
                maxLimit = true
                allertWithParameter(title: loc("LOCARTITLE"), message: message, viecontroller: viecontroller)
            } else {
                maxLimit = false
            }
        } catch let error as NSError {
            print("Count not fetch \(error), \(error.userInfo)")
        }
        return maxLimit
    }
} 
