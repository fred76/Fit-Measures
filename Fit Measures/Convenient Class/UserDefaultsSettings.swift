//
//  UserDefaultsSettings.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 30/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit

class UserDefaultsSettings {
    private static let height = "height"
    private static let age = "age"
    private static let weightUnit = "weightUnit"
    private static let lenghtUnit = "lenghtUnit"
    private static let biologicalSex = "biologicalSex"
    private static let firstLunch = "firstLunch"
    private static let isAlreadyAppeared = "isAlreadyAppeared"
    
    static var heightSet: Double {
        get { return UserDefaults.standard.double(forKey: height)}
        set {UserDefaults.standard.set(newValue, forKey: height)}
    }
    
    static var ageSet: Double {
        get { return UserDefaults.standard.double(forKey: age)}
        set {UserDefaults.standard.set(newValue, forKey: age)}
    }
    
    static var weightUnitSet : String {
        get { return UserDefaults.standard.string(forKey: weightUnit)! }
        set {UserDefaults.standard.set(newValue, forKey: weightUnit)}
    }
    
    static var lenghtUnitSet: String {
        get { return UserDefaults.standard.string(forKey: lenghtUnit)! }
        set {UserDefaults.standard.set(newValue, forKey: lenghtUnit)}
    }
    
    static var biologicalSexSet: String {
        get { return UserDefaults.standard.string(forKey: biologicalSex)! }
        set {UserDefaults.standard.set(newValue, forKey: biologicalSex)}
    }
    
    static var firstLunchSet: Bool {
        get { return UserDefaults.standard.bool(forKey: firstLunch) }
        set {UserDefaults.standard.set(newValue, forKey: firstLunch)}
    }
    static var isAlreadyAppearedSet: Bool {
        get { return UserDefaults.standard.bool(forKey: isAlreadyAppeared) }
        set {UserDefaults.standard.set(newValue, forKey: isAlreadyAppeared)}
    }
    
   
    @discardableResult static func serchForKey(kUsernameKey: String) -> Bool {
        return UserDefaults.standard.object(forKey: kUsernameKey) != nil
    }
    
}

import Foundation

extension UserDefaults {
    enum Key: String {
        case reviewWorthyActionCount
        case lastReviewRequestAppVersion
    }
    
    func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func set(_ integer: Int, forKey key: Key) {
        set(integer, forKey: key.rawValue)
    }
    
    func set(_ object: Any?, forKey key: Key) {
        set(object, forKey: key.rawValue)
    }
}
