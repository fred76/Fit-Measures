
//
//  Color File.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 27/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit
struct StaticClass { 
    
    static let alertViewHeaderColor : UIColor = #colorLiteral(red: 0.2666336298, green: 0.2666856647, blue: 0.2666303515, alpha: 1)
    static let alertViewBackgroundColor: UIColor = #colorLiteral(red: 0.1842891872, green: 0.1843278706, blue: 0.1842867434, alpha: 1)
    static let appBackgroundColor : UIColor = #colorLiteral(red: 0.04704833031, green: 0.04706484824, blue: 0.04704730958, alpha: 1)
    static let blueHeader : UIColor = #colorLiteral(red: 0.04933099449, green: 0.6540151238, blue: 0.9243635535, alpha: 1)
    static let blueLean : UIColor = #colorLiteral(red: 0.04933099449, green: 0.6540151238, blue: 0.9243635535, alpha: 1)
    static let blueButton : UIColor = #colorLiteral(red: 0.06274509804, green: 0.662745098, blue: 0.9333333333, alpha: 1) 
    static let redFat : UIColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    static let adMobString : String = "ca-app-pub-3940256099942544/2934735716" //My String "ca-app-pub-9833367902957453~1306670365"
    
    static var dateFormatterMediumYY: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter
    }()
    
    static func getDate() -> Date {
        let today = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter .dateStyle = DateFormatter.Style.short
        _ = 86400.0
        let dateAsString = dateFormatter.string(from: today.addingTimeInterval(0))
        
        return dateFormatter.date(from: dateAsString)!
    }
    
    static var dateFormatterLongLong: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter
    }()
    
    static func dateFormat(d:NSDate) -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter .dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yy"
        let dateAsString = dateFormatter.string(from: d.addingTimeInterval(0) as Date)
        
        return dateAsString
    }
    
    static func dateFromNSDateSince1970(_ value: NSDate) -> TimeInterval {
        
        
        let date = value.timeIntervalSince1970
        
        return date
    }
    static func dateFromStringTransform(_ value: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let valueX = dateFormatter.date(from: value)
        
        return valueX!
    }
    static func dateFromStringSince1970(_ value: String) -> Double {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        let valueX = dateFormatter.date(from: value)
        let date = valueX?.timeIntervalSince1970
        
        return date!
    }
    
    static func dateFromString(_ value: String) -> Date {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter .dateStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd/MM/yy"
        let valueX = dateFormatter.date(from: value)
        
        
        return valueX!
    }
    
    static func removeZero(label:UILabel, value: String, constr : NSLayoutConstraint, unit : String) -> (String) {
        var t : String = ""
        if value == "0.0" {
            label.isHidden = true
        } else {
            t = value + unit
            constr.constant = -20
        }
        
        
        return t
    }
    
    static func removeZeroInsight(label:UILabel, value: String,  unit : String) -> (String) {
        var t : String = ""
        if value == "0.0" {
            label.isHidden = true
        } else {
            t = value + unit
            
        }
        
        
        return t
    }
    static func randomIndexpath(upperLimit: Int) -> Int{
        let indexpathCount = UInt32(upperLimit)
        let unsignedRandomNumber = arc4random_uniform(indexpathCount)
        let randomNumber = Int(unsignedRandomNumber)
        return randomNumber
    }
   
    
    @discardableResult static func didLoadView(v: UIViewController)->UIView? {
        guard let view = v.view else {
            return nil
        } 
        return view
    }
 
}
 
public func loc(_ localizedKey:String) -> String {
    return NSLocalizedString(localizedKey, comment: "")
    
    
}
