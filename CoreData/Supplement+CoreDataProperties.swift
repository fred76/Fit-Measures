//
//  Supplement+CoreDataProperties.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 14/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//
//

import Foundation
import CoreData
import UserNotifications

extension Supplement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Supplement> {
        return NSFetchRequest<Supplement>(entityName: "Supplement")
    }

    @NSManaged public var productName: String? 
    @NSManaged public var brand: String?
    @NSManaged public var quantity: String?
    @NSManaged public var ingredientList: String?
    @NSManaged public var carbohydrates: String?
    @NSManaged public var fatValue: String?
    @NSManaged public var proteinsValue: String?
    @NSManaged public var image: NSData?
    @NSManaged public var labels: [String]?
    @NSManaged public var shouldRemind: Bool
    @NSManaged public var uniqueIdentifier: String?
    @NSManaged public var dateWhenSupplementWillEnd: NSDate?
    @NSManaged public var dailyDose: String?
    @NSManaged public var quantityAddedByUser: String?
    @NSManaged public var daysAnWeek: String?

    func scheduleNotification(dueDate : Date) {
        
        removeNotification()
        if shouldRemind && dueDate > Date() {
            
            let content = UNMutableNotificationContent()
            content.title = "Is time to by again::"
            content.body = productName!
            content.sound = UNNotificationSound.default
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: uniqueIdentifier! as String, content: content, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
            
            print("Scheduled: \(request) for itemID: \(uniqueIdentifier! as String)")    }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [uniqueIdentifier! as String])
    }
}
