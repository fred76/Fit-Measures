//
//  enum.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 20/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit

public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}
enum ImportOption : String {
    case girth
    case pliche
} 

// ["Triceps","Suprailiac","Thigh","Abdominal","Chest","Subscapular","Midaxillary"]
enum BodyPlichePoints : String {
    case tricipite = "Triceps"
    case sottoscapola = "Subscapular"
    case coscia = "Thigh"
    case addome = "Abdominal"
    case petto = "Chest"
    case soprailliaca = "Suprailiac"
    case bicipite = "Biceps"
    case ascella = "Midaxillary"
    
}

enum Supplementlabels : String {
   case Vegetarian = "vegetarian"
   case Gluten_free = "gluten free"
   case No_GMOs = "no gmos"
   case No_artificial_preservatives = "no artificial preservatives"
   case No_added_sugar = "no added sugar"
   case No_lactose = "no lactose"
   case Organic = "organic"
   case EU_Organic = "EU Organic"
   case Vegan = "vegan"
    
}

enum PlicheMethods : String {
    case jackson_7 = "jackson & Polloc 7 point"
   // case jackson_4 = "jackson & Polloc 4 point"
    case jackson_3_Man = "jackson & Polloc 3 point Man"
    case jackson_3_Woman = "jackson & Polloc 3 point Woman"
    case sloanMen = "Sloan - Men 2 point"
    case sloanWoman = "Sloan - Woman 2 point"
    case DurninMan = "Durnin & Womersley Man 4 Pliche"
}

enum BodyMeasurementPoints : String {
    case weight = "Weight"
    case neck = "Neck"
    case bicep_L = "Bicep_L"
    case bicep_R = "Bicep_R"
    case bicep_L_Relax = "bicep_L_Relax"
    case bicep_R_Relax = "bicep_R_Relax"
    case forearm_L = "Forearm_L"
    case Forearm_R = "Forearm_R"
    case wrist = "Wrist"
    case chest = "Chest"
    case waist = "Waist"
    case hips = "Hips"
    case thigh_L = "Thigh_L"
    case Thigh_R = "Thigh_R"
    case calf_L = "Calf_L"
    case Calf_R = "Calf_R"
}
 
enum ARCoffeeSessionState: String, CustomStringConvertible {
    case initialized = "initialized"
    case ready = "ready"
    case temporarilyUnavailable = "temporarily unavailable"
    case failed = "failed"
    
    var description: String {
        switch self {
        case .initialized:
            return "👀 Look for a plane to place your dummy"
        case .ready:
            return "🏋️‍♀️ Click any plane to place your dummy!"
        case .temporarilyUnavailable:
            return "🕳 no plane available"
        case .failed:
            return "⛔️ AReality paused"
        }
    }
}

import HealthKit

extension HKBiologicalSex {
    
    var stringRepresentation: String {
        switch self {
        case .notSet: return "Unknown"
        case .female: return "Female"
        case .male: return "Male"
        case .other: return "Other"
        default: break
        }
        return ""
    }
}
