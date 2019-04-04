//
//  DownloadManager.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 04/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {
    
    static let shared = DownloadManager() 
   var topChartController : ProductListSearchedByName!
     var storage : [ProductSearchedModel] = []
    func downloadJSON(_ url : String) {
        
        debugPrint("scarico: " + url)
        request(url, method: .get).responseJSON { response in
            
            if let er = response.result.error {
                print("ERRORE:")
                print(er.localizedDescription)
            }
            guard let ilJson = response.result.value else {
                print("JSON Nil")
                return // ferma tutta l'esecuzione del codice in questo punto
            }
            
            // cosi la var JSON è un array
            guard let json = JSON(ilJson)["products"].array else {print("SSSS") ;return }
            print("json \(json)")
         //self.storage = []
            
            let totale = json.count
            print(totale)
            for i in 0..<totale {
                let productDetail = ProductSearchedModel()
                
               // print("dddd \(json[i]["nutriments"])")
                if let productName = json[i]["product_name"].string {
                    productDetail.productName = productName
                }
                
                if let productBrand = json[i]["brands"].string {
                    productDetail.brand = productBrand
                }
                if let productQuantity = json[i]["quantity"].string {
                    productDetail.quantity = productQuantity
                }
                
                if let productIngredientList = json[i]["ingredients_text_en"].string {
                    productDetail.ingredientList = productIngredientList
                }
                if let productImage = json[i]["image_url"].string {
                    productDetail.image = productImage
                }
                
               self.storage.append(productDetail)
            } 
            
        }
    }
}

