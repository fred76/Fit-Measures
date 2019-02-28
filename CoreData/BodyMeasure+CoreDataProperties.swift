//
//  BodyMeasure+CoreDataProperties.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 28/02/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension BodyMeasure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BodyMeasure> {
        return NSFetchRequest<BodyMeasure>(entityName: "BodyMeasure")
    }

    @NSManaged public var bicep_L: Double
    @NSManaged public var bicep_L_Relax: Double
    @NSManaged public var bicep_R: Double
    @NSManaged public var bicep_R_Relax: Double
    @NSManaged public var calf_L: Double
    @NSManaged public var calf_R: Double
    @NSManaged public var chest: Double
    @NSManaged public var dateOfEntry: NSDate?
    @NSManaged public var forearm_L: Double
    @NSManaged public var forearm_R: Double
    @NSManaged public var hips: Double
    @NSManaged public var neck: Double
    @NSManaged public var thigh_L: Double
    @NSManaged public var thigh_R: Double
    @NSManaged public var waist: Double
    @NSManaged public var weight: Double
    @NSManaged public var wrist: Double
    @NSManaged public var uniqueIdentifier: NSString?

}
