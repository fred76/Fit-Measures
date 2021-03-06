//
//  PicFullRes+CoreDataProperties.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 28/02/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension PicFullRes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PicFullRes> {
        return NSFetchRequest<PicFullRes>(entityName: "PicFullRes")
    }

    @NSManaged public var imageData: NSData?
    @NSManaged public var uniqueIdentifier: NSString?
    @NSManaged public var thumbnail: Thumbnail?

}
