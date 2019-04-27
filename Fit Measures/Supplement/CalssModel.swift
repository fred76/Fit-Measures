//
//  CalssModel.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 05/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation

import UIKit
import UserNotifications
class ProductSearched: NSObject {
    var productName : String = ""
    var brand : String = ""
    var quantity : String = ""
    var ingredientList : String = ""
    var carbohydrates : String = ""
    var fatValue : String = ""
    var proteinsValue : String = ""
    var image : String = ""
    var labels : [String] = []
    var shouldRemind = false
    var uniqueIdentifier: NSString?
    var dateWhenSupplementWillEnd: Date?
    var dailyDose : String = ""
    var quantityAddedByUser: String = ""
    var daysAnWeek: String = ""
    
    func scheduleNotification(dueDate : Date) {
        
        removeNotification()
        if shouldRemind && dueDate > Date() {
            
            let content = UNMutableNotificationContent()
            content.title = "Is time to by again:"
            content.body = productName
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


