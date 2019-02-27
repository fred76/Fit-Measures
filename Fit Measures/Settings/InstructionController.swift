//
//  InstructionController.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 10/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit


class InstructionController: UIViewController, UIPopoverPresentationControllerDelegate{
    @IBOutlet weak var Text: UITextView!
    
    var textString : String!
    
    var importOption = ImportOption.pliche
    var plicheMethods = PlicheMethods.jackson_7
    override func viewDidLoad() {
        super.viewDidLoad()
        if let lang = Bundle.main.preferredLocalizations.first {
            if lang == "en" {
                textString = "Istruzioni"
            }
            if lang == "it" {
                textString = "Istruzioni_Ita"
            }
        }
        
        
        let textURL = Bundle.main.url(forResource: textString, withExtension: "rtf")
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.rtf]
        let attribText = try! NSAttributedString(url: textURL!, options: options, documentAttributes: nil)
        
        
        
        Text.attributedText = attribText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exportGrith(_ sender: Any) { exportGirthTemplateAsCSV() }
    
    @IBAction func exportPliche(_ sender: Any) { exportPlicheTemplateAsCSV() }
    
    @IBAction func importGirth(_ sender: Any) { importGirthFromCsv() }
    
    @IBAction func importPliche(_ sender: Any) { importPlicheFromCsv() }
    
    @IBAction func exportMyGirth(_ sender: Any) { exportGirthAsCSV() }
    
    @IBAction func exportMyPliche(_ sender: Any) { exportPlicheAsCsv()  }
    
}

extension InstructionController {
    
    func exportGirthAsCSV(){
        
        let fileName = "Circumference.csv" 
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        //"weight,bicep_R,bicep_L,calf_R,calf_L,chest,forearm_R,forearm_L,hips,neck,thigh_R,thigh_L,waist,wrist,dateOfEntry\n"
        var csvText = "weight,bicep_R,bicep_L,bicep_R_Relax,bicep_L_Relax,calf_R,calf_L,chest,forearm_R,forearm_L,hips,neck,thigh_R,thigh_L,waist,wrist,dateOfEntry\n"
        let med = DataManager.shared.bodyMeasurementExplode()
        var newLine : String = ""
        for m in med {
            
            newLine = "\(m.weight),\(m.bicep_R),\(m.bicep_L_Relax),\(m.bicep_R_Relax),\(m.bicep_L),\(m.calf_R),\(m.calf_L),\(m.chest),\(m.forearm_R),\(m.forearm_L),\(m.hips),\(m.neck),\(m.thigh_R),\(m.thigh_L),\(m.waist),\(m.wrist),\(StaticClass.dateFormat(d: m.dateOfEntry!))\n"
            
            csvText.append(newLine)
        }
        csvText.removeLast()
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            vc.excludedActivityTypes = []
            if let popover = vc.popoverPresentationController {
                popover.permittedArrowDirections = .any
                popover.delegate = self
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: 0 , y: self.Text.bounds.height, width: self.view.frame.width, height: self.view.frame.height )
                popover.backgroundColor = .clear
                
                present(vc, animated: true, completion: nil)
                
            } else {
                present(vc, animated: true, completion: nil)
            }
            
            vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                if completed == true {
                    FileManager.default.clearTmpDirectory()
                    
                }
            }
        } catch {
            
            print("Failed to create file")
            print("\(error)")
        }
        
        
    }
    
    func exportPlicheAsCsv(){
        
        let fileName = "Skin Fold.csv"
        print("fileName : \(fileName) \n")
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        //"weight,abdominal,biceps,chest,midaxillary,subscapular,suprailiac,thigh,triceps,dateOfEntry,method,age\n"
        var csvText = "weight,abdominal,biceps,chest,midaxillary,subscapular,suprailiac,thigh,triceps,dateOfEntry,method,skin_fold_sum,bodyFatPercentage,body_density,lean_mass\n"
        let med = DataManager.shared.plicheExplode()
        var newLine : String = ""
        var met = ""
        for m in med {
            
            if m.method == "jackson & Polloc 7 point" {
                met = "jp7"
            }
            if m.method == "jackson & Polloc 3 point Man" {
                met = "jp3m"
            }
            if m.method == "jackson & Polloc 3 point Woman" {
                met = "jp3w"
            }
            if m.method == "Sloan - Men 2 point" {
                met = "sm"
            }
            if m.method == "Sloan - Woman 2 point" {
                met = "sw"
            }
            if m.method == "Durnin & Womersley Man 4 Pliche" {
                met = "dw"
            }
            
            newLine = "\(m.weight),\(m.abdominal),\(m.biceps),\(m.chest),\(m.midaxillary),\(m.subscapular),\(m.suprailiac),\(m.thigh),\(m.triceps),\(StaticClass.dateFormat(d: m.dateOfEntry!)),\(met),\(m.sum),\(m.bodyFatPerc),\(m.bodyDensity),\(m.leanMass)\n"
            csvText.append(newLine)
        }
        csvText.removeLast()
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            vc.excludedActivityTypes = []
            if let popover = vc.popoverPresentationController {
                popover.permittedArrowDirections = .any
                popover.delegate = self
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: 0 , y: self.Text.bounds.height, width: self.view.frame.width, height: self.view.frame.height )
                popover.backgroundColor = .clear
                
                present(vc, animated: true, completion: nil)
                
            } else {
                present(vc, animated: true, completion: nil)
            }
            vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                if completed == true {
                    FileManager.default.clearTmpDirectory()
                    
                }
            }
        } catch {
            
            print("Failed to create file")
            print("\(error)")
        }
        
        
    }
    
    func exportGirthTemplateAsCSV(){
        
        let fileName = "GirthMeasure.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "weight,bicep_R,bicep_L,bicep_R_Relax,bicep_L_Relax,calf_R,calf_L,chest,forearm_R,forearm_L,hips,neck,thigh_R,thigh_L,waist,wrist,dateOfEntry\n"
        
        let newLine = "1.1,2.2,3.3,4.4,3.3,4.4,5.5,6.6,7.7,8.8,9.9,10.0,11.1,12.2,13.3,14.4,01/01/2018\n"
        
        csvText.append(newLine)
        
        csvText.removeLast()
        
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            
            
            vc.excludedActivityTypes = []
            if let popover = vc.popoverPresentationController {
                popover.permittedArrowDirections = .any
                popover.delegate = self
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: 0 , y: self.Text.bounds.height, width: self.view.frame.width, height: self.view.frame.height )
                popover.backgroundColor = .clear
                
                present(vc, animated: true, completion: nil)
                
            } else {
                present(vc, animated: true, completion: nil)
            }
            vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                if completed == true {
                    FileManager.default.clearTmpDirectory()
                    
                }
            }
        } catch {
            
            print("Failed to create file")
            print("\(error)")
        }
        
        
    }
    
    func exportPlicheTemplateAsCSV(){
        
        let fileName = "PlicheMeasure.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "weight,abdominal,biceps,chest,midaxillary,subscapular,suprailiac,thigh,triceps,dateOfEntry,method,age\n"
        
        let jp7 = "70,3,0,3.3,3.5,3.6,3.6,4.6,4.7,01/01/2018,jp7,18\n"
        let jp3m = "70,3,0,3.3,3.5,3.6,3.6,4.6,4.7,01/02/2018,jp3m,18\n"
        let jp3w = "70,3,0,3.3,3.5,3.6,3.6,4.6,4.7,01/03/2018,jp3w,18\n"
        let sm = "70,3,0,3.3,3.5,3.6,3.6,4.6,4.7,01/04/2018,sm,18\n"
        let sw = "70,3,0,3.3,3.5,3.6,3.6,4.6,4.7,01/05/2018,sw,18\n"
        let dw = "70,3,5,3.3,3.5,3.6,3.6,4.6,4.7,01/06/2018,dw,18\n"
        csvText.append(jp7)
        csvText.append(jp3m)
        csvText.append(jp3w)
        csvText.append(sm)
        csvText.append(sw)
        csvText.append(dw)
        csvText.removeLast()
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
            
            
            vc.excludedActivityTypes = []
            if let popover = vc.popoverPresentationController {
                popover.permittedArrowDirections = .any
                popover.delegate = self
                popover.sourceView = self.view
                popover.sourceRect = CGRect(x: 0 , y: self.Text.bounds.height, width: self.view.frame.width, height: self.view.frame.height )
                popover.backgroundColor = .clear
                present(vc, animated: true, completion: nil)
            } else {
                present(vc, animated: true, completion: nil)
            }
            vc.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
                if completed == true {
                    FileManager.default.clearTmpDirectory()
                    
                }
            }
        } catch {
            
            print("Failed to create file")
            print("\(error)")
        }
        
        
    }
    
    func importGirthFromCsv(){
        importOption = .girth
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text", "public.data"], in: .import)
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func importPlicheFromCsv(){
        importOption = .pliche
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text", "public.data"], in: .import)
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
}




extension InstructionController : UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let urlOfCSV = try! String.init(contentsOf: url)
        
        
        
        
        background {
            switch self.importOption {
                
            case .girth: self.readCsvGirth(data: urlOfCSV) {  FileManager.default.clearTmpDirectory() }
                
            case .pliche : self.readCsvPliche(data: urlOfCSV, closure: {
                FileManager.default.clearTmpDirectory()
            })
                
            }
        }
        main {
            DataManager.shared.allertWithParameter(title: loc("Good Job"), message: loc("Check Your Insight"), viecontroller: self)
        }
        
    }
    
    func readCsvPliche(data: String, closure: @escaping ()->()) {
        
        let rows = data.components(separatedBy: "\n")
        
        for row in rows.dropFirst() {
            let t = row.replacingOccurrences(of: "\r", with: "")
            let t2 = t.replacingOccurrences(of: ";", with: ",")
            let columns = t2.components(separatedBy: ",") 
            DataManager.shared.plicheAddFromCSV(array: columns)
        }
        
        if let plicheMeasure = DataManager.shared.getLastPlicheAvailable() {
            Items.sharedInstance.plicheArray.removeAll()
            Items.sharedInstance.plicheArray.append(plicheMeasure.sum)
            Items.sharedInstance.plicheArray.append(plicheMeasure.bodyDensity)
            Items.sharedInstance.plicheArray.append(plicheMeasure.bodyFatPerc)
            Items.sharedInstance.plicheArray.append(plicheMeasure.leanMass)
            Items.sharedInstance.method = plicheMeasure.method!
        }
        closure()
        
    } 
    
    func readCsvGirth(data: String, closure: @escaping ()->()) {
        let rows = data.components(separatedBy: "\n")
        for row in rows.dropFirst() {
            let t = row.replacingOccurrences(of: "\r", with: "")
            let t2 = t.replacingOccurrences(of: ";", with: ",")
            let columns = t2.components(separatedBy: ",")
            
            DataManager.shared.bodyMeasureAddFromCSV(array: columns)
        }
        
        Items.sharedInstance.updateMaesure()
        closure()
        
    }
    
    func background(work: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            work()
        }
    }
    
    func main(work: @escaping () -> ()) {
        DispatchQueue.main.async {
            work()
        }
    }
}


