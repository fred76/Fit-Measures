//
//  Thumbnail+CoreDataProperties.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 10/01/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData


extension Thumbnail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Thumbnail> {
        return NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
    }

    @NSManaged public var id: Double
    @NSManaged public var imageData: NSData?
    @NSManaged public var fullRes: PicFullRes?

}
