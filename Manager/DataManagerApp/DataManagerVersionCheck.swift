//
//  DataManagerVersionCheck.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 02/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import StoreKit
extension DataManager {
    func loadReceipt()  {
        print("com.ifit.girths \(UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths.unlock"))")
        print("com.ifit.skinFolds \(UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds.unlock"))")
        print("com.ifit.bundle \(UserDefaults.standard.bool(forKey: "fred76.com.ifit.bundle.unlock"))")
        if UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths.unlock") || UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds.unlock") || UserDefaults.standard.bool(forKey: "fred76.com.ifit.bundle.unlock") { 
            return
        }
        guard let receiptURL = receiptURL else {print("NO URL"); return }
        do {
            let receipt = try Data(contentsOf: receiptURL)
            verifyIfPurchasedBeforeFreemium(productionStoreURL!, receipt)
        } catch {
            let appReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
            appReceiptRefreshRequest.delegate = self
            appReceiptRefreshRequest.start()
        }
        
    }
    
    private func verifyIfPurchasedBeforeFreemium(_ storeURL: URL, _ receipt: Data) {
        do {
            let requestContents:Dictionary = ["receipt-data": receipt.base64EncodedString()]
            let requestData = try JSONSerialization.data(withJSONObject: requestContents, options: [])
            var storeRequest = URLRequest(url: storeURL)
            storeRequest.httpMethod = "POST"
            storeRequest.httpBody = requestData
            URLSession.shared.dataTask(with: storeRequest) { (data, response, error) in
                DispatchQueue.main.async {
                    if data != nil {
                        do {
                            let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any?]
                            if let statusCode = jsonResponse["status"] as? Int {
                                if statusCode == 21007 {
                                    print("Switching to test against sandbox")
                                    self.verifyIfPurchasedBeforeFreemium(self.sandboxStoreURL!, receipt)
                                }
                            }
                            if let receiptResponse = jsonResponse["receipt"] as? [String: Any?],
                                let original_application_version = receiptResponse["original_application_version"] as? String {
                                
                                //                                let dateFormatter = DateFormatter()
                                //                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                                //                                let dateObject = dateFormatter.date(from: original_purchase_date)
                                //
                                //                                let n = Date()
                                print("original_application_version \(original_application_version)")
                                if (original_application_version.doubleValue + 0) < 3 {
                                    UserDefaults.standard.set(true, forKey: "fred76.com.ifit.girths.unlock")
                                    UserDefaults.standard.set(true, forKey: "fred76.com.ifit.skinFolds.unlock")
                                    UserDefaults.standard.set(true, forKey: "fred76.com.ifit.bundle.unlock") 
                                }
                            }
                        } catch {
                            print("Error: " + error.localizedDescription)
                        }
                    }
                }
                
                }.resume()
        } catch {
            print("Error: " + error.localizedDescription)
        }
    }
    func requestDidFinish(_ request: SKRequest) {
        print("Refresh")
        // a fresh receipt should now be present at the url
        do {
            let receipt = try Data(contentsOf: receiptURL!) //force unwrap is safe here, control can't land here if receiptURL is nil
            verifyIfPurchasedBeforeFreemium(productionStoreURL!, receipt)
        } catch {
            // still no receipt, possible but unlikely to occur since this is the "success" delegate method
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("app receipt refresh request did fail with error: \(error)")
        // for some clues see here: https://samritchie.net/2015/01/29/the-operation-couldnt-be-completed-sserrordomain-error-100/
    }
    private func isPaidVersionNumber(_ originalVersion: String) -> Bool {
        let pattern:String = "^\\d+\\.\\d+"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let results = regex.matches(in: originalVersion, options: [], range: NSMakeRange(0, originalVersion.count))
            
            let original = results.map {
                Double(originalVersion[Range($0.range, in: originalVersion)!])
            }
            
            if original.count > 0, original[0]! < 3 {
                print("App purchased prior to Freemium model")
                return true
            }
        } catch {
            print("Paid Version RegEx Error.")
        }
        return false
    }
    
    func purchasedGirthsAndSkinfilds() -> Bool{
        var purchased : Bool = false
        if UserDefaults.standard.bool(forKey: "fred76.com.ifit.girths.unlock") || UserDefaults.standard.bool(forKey: "fred76.com.ifit.skinFolds.unlock") { 
            purchased = true
        }
        return purchased
    }
}
