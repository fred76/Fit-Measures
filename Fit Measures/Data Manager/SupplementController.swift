//
//  SupplementController.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 03/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit
import AVFoundation
class SupplementController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UISearchBarDelegate {
    
    @IBOutlet var myProductCollectionView: UITableView!
    @IBOutlet var searchProduct: UISearchBar!
    @IBOutlet var barCodeButton: UIButton!
    var scanner: ScannerHelper?
    var nutrimentDictionary : NSDictionary!
    var status : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchProduct.delegate = self
        
    }
    
    @IBAction func code(_ sender: Any) {
        //        self.scanner = ScannerHelper(withViewController: self, view: self.view, codeOutputHandler: self.handleCode(code:))
        //        if let scanner = self.scanner { scanner.requestCaptureSessioStartRunning() }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.2) {
            self.barCodeButton.transform = self.barCodeButton.transform.translatedBy(x: 100, y: 0)
        }
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        UIView.animate(withDuration: 0.2) {
            self.barCodeButton.transform = self.barCodeButton.transform.translatedBy(x: -100, y: 0)
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        UIView.animate(withDuration: 0.2) {
            self.barCodeButton.transform = self.barCodeButton.transform.translatedBy(x: -100, y: 0)
        }
        if let text = searchBar.text {
            searchHandleCode(code: text)
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //
    //    func scanAndSegue(code:String, closure: @escaping ()->()) {
    //        let url = "https://world.openfoodfacts.org/api/v0/product/[\(code)].json"
    //        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) -> Void in
    //            // Check if data was received successfully
    //            if error == nil && data != nil {
    //                do {
    //                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
    //                    let status = json["status"] as! Bool
    //                    if status {
    //                        let product = json["product"] as! NSDictionary
    //                        let nutriment  = product["nutriments"] as! NSDictionary
    //                        self.nutrimentDictionary = nutriment
    //                        closure()
    //                    } else {
    //                        closure()
    //                    }
    //                } catch { print(error)
    //                }
    //            }
    //            }.resume()
    //
    //    }
    //
    //    func handleCode(code:String) {
    //        scanAndSegue(code: code) {
    //            DispatchQueue.main.async {
    //                if self.status {
    //                    self.performSegue(withIdentifier: "ProductFound", sender: self)
    //                }
    //                else { self.performSegue(withIdentifier: "ProductNotFound", sender: self) }
    //            }
    //        }
    //    }
    //
    func searchAndSegue(code:String, closure: @escaping ()->()) {
        
        let replaced = code.replacingOccurrences(of: " ", with: "+")
      
        
        let urln = "https://world.openfoodfacts.org/category/\(replaced)/1.json"
        
        let url = "https://world.openfoodfacts.org/cgi/search.pl?search_terms=\(replaced)&search_simple=1&action=process&json=1"
        print(url)
        DownloadManager.shared.downloadJSON(url)
        closure()
//        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) -> Void in
//            // Check if data was received successfully
//            if error == nil && data != nil {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
//                    let count = json["count"] as! Int
//                    print("count \(count)")
//                    let product = json["products"] as! NSArray
//                    let p = product[0] as! NSArray
//
//                    print("p \(p["product_name"])")
//
////                    let nutriment  = product["product_name"] as! NSDictionary
////                    print("nutriment \(nutriment)")
//                    closure()
//
//                } catch { print(error)
//                }
//            }
//            }.resume()
        
    }
    
    func searchHandleCode(code:String) {
        searchAndSegue(code: code) {
            DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ProductList", sender: self)
            }
        }
    }
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.scanner?.scannerHelperDelegate(output, didOutput: metadataObjects, from: connection)
    }
    
    
}

