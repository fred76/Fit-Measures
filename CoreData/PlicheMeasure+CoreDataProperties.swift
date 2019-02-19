//
//  PlicheMeasure+CoreDataProperties.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 10/01/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension PlicheMeasure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlicheMeasure> {
        return NSFetchRequest<PlicheMeasure>(entityName: "PlicheMeasure")
    }

    @NSManaged public var abdominal: Double
    @NSManaged public var age: Double
    @NSManaged public var biceps: Double
    @NSManaged public var bodyDensity: Double
    @NSManaged public var bodyFatPerc: Double
    @NSManaged public var chest: Double
    @NSManaged public var dateOfEntry: NSDate?
    @NSManaged public var leanMass: Double
    @NSManaged public var method: String?
    @NSManaged public var midaxillary: Double
    @NSManaged public var subscapular: Double
    @NSManaged public var sum: Double
    @NSManaged public var suprailiac: Double
    @NSManaged public var thigh: Double
    @NSManaged public var triceps: Double
    @NSManaged public var weight: Double

}
