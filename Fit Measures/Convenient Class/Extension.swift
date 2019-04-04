//
//  File.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 20/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit
import Charts

// MARK: - extension UIViewController
extension UIViewController {
    
    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                })
                return
            }
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }
    func setToolBar(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.navigationController?.toolbar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.navigationController?.toolbar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                })
                return
            }
        }
        self.navigationController?.toolbar.isHidden = hidden
    }
    
}

// MARK: - extension UIButton
extension UIButton {
    
    public func addBorder(color: UIColor, width: CGFloat) {
        
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = 3
        
//        let border = CALayer()
//        border.backgroundColor = color.cgColor
//
//        switch side {
//        case .Top:
//            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
//        case .Bottom:
//            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
//        case .Left:
//            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
//        case .Right:
//            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
//        }
//
//        self.layer.addSublayer(border)
    }
}

// MARK: - extension FileManager
extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory()) 
            try tmpDirectory.forEach {[unowned self] file in
                let path = String.init(format: "%@%@", NSTemporaryDirectory(), file)
                try self.removeItem(atPath: path)
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - extension UIImage
extension UIImage {
    func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        
        // convert UIImage to CIImage and set as input
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        //Return the image
        return UIImage(cgImage: cgImage!)
    }
}

enum FilterType : String {
    case Chrome = "CIPhotoEffectChrome"
    case Fade = "CIPhotoEffectFade"
    case Instant = "CIPhotoEffectInstant"
    case Mono = "CIPhotoEffectMono"
    case Noir = "CIPhotoEffectNoir"
    case Process = "CIPhotoEffectProcess"
    case Tonal = "CIPhotoEffectTonal"
    case Transfer =  "CIPhotoEffectTransfer"
}



// MARK: - extension UILabel
extension UILabel {
    
    func countLabelLines() -> Int {
        // Call self.layoutIfNeeded() if your view is uses auto layout
        let myText = self.text! as NSString
        let attributes = [NSAttributedString.Key.font : self.font]
        
        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
    
    func isTruncated() -> Bool {
        
        if (self.countLabelLines() > self.numberOfLines) {
            return true
        }
        return false
    }
}

extension UILabel {
    
    var isTruncatedu: Bool {
        
        guard let labelText = text else {
            return false
        }
        
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
}
// MARK: - extension String

 

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension String {
    var floatValue: Float {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.floatValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
    
    var doubleValue:Double {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.doubleValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

// MARK: - extension ChartXAxisFormatter
extension ChartXAxisFormatter: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let dateFormatter = dateFormatter {
            
            let date = Date(timeIntervalSince1970: value)
            return dateFormatter.string(from: date)
        }
        
        return ""
    }
    
}

class Items {
    static let sharedInstance = Items()
    var measureArray = [Double]()
    var plicheArray = [Double]()
    var method = String()
    
    func updateMaesure(){
        
        
        if let getLastMeasureAvailable = DataManager.shared.getLastMeasureAvailable() {
          Items.sharedInstance.measureArray.removeAll()
          if  !UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths") {
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.weight)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.neck)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_L)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_R_Relax)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.forearm_L)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.wrist)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.waist)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.hips)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.thigh_L)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.calf_R)
         
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.weight)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.neck)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_R)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_L)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_R_Relax)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_L_Relax)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.forearm_R)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.forearm_L)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.wrist)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.chest)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.waist)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.hips)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.thigh_R)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.thigh_L)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.calf_R)
//            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.calf_L)
          } else {
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.weight)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.neck)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_R)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_L)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_R_Relax)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.bicep_L_Relax)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.forearm_R)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.forearm_L)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.wrist)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.chest)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.waist)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.hips)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.thigh_R)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.thigh_L)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.calf_R)
            Items.sharedInstance.measureArray.append(getLastMeasureAvailable.calf_L)
            }
          
        }
        
    }
    func updatePliche(){
    
        
    if let plicheMeasure = DataManager.shared.getLastPlicheAvailable() {
    Items.sharedInstance.plicheArray.removeAll()
    Items.sharedInstance.plicheArray.append(plicheMeasure.sum)
    Items.sharedInstance.plicheArray.append(plicheMeasure.bodyDensity)
    Items.sharedInstance.plicheArray.append(plicheMeasure.bodyFatPerc)
    Items.sharedInstance.plicheArray.append(plicheMeasure.leanMass)
    Items.sharedInstance.method = plicheMeasure.method!
    }
        
    }
}
