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
    
    var SupplementController : SupplementSearchedByName!
    
    var storageProductBySearch : [ProductSearched] = []
    
    var productDetail = ProductSearched()
    
    func downloadJSONfromSearch(_ url : String, completion: @escaping (Int) -> Void) { 
        request(url, method: .get).responseJSON { response in
            
            if let er = response.result.error {
                print("ERRORE:")
                print(er.localizedDescription)
            }
            guard let ilJson = response.result.value else { 
                return
            }
            
            guard let json = JSON(ilJson)["products"].array else {return }
            print(json)
            let totale = json.count
            for i in 0..<totale {
                
                let productDetail = ProductSearched()
                
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
                
                if let jsonIngredients = json[i]["ingredients_text"].string {
                    productDetail.ingredientList = jsonIngredients
                }
                
                if let jsonNutriments = json[i]["nutriments"].dictionary {
                    if let productCarbohydrates = jsonNutriments["carbohydrates_value"]?.string {
                        productDetail.carbohydrates = productCarbohydrates
                    }
                    
                    if let productFat = jsonNutriments["fat_value"]?.string {
                        productDetail.fatValue = productFat
                    }
                    
                    if let productProtein = jsonNutriments["proteins_value"]?.string {
                        productDetail.proteinsValue = productProtein
                    }
                }
                
               
                
                if let labelsHierarchy = json[i]["labels_hierarchy"].array {
                
                for label in labelsHierarchy {
                    let label = label.string
                    let column: Character = ":"
                    if let idx = label?.firstIndex(of: column)
                    {
                        let pos = label?.distance(from: label!.startIndex, to: idx)
                        let labelClean = label!.dropFirst(pos! + 1)
                        let replaced = String(labelClean.map {
                            $0 == "-" ? " " : $0
                        })
                        productDetail.labels.append(String(replaced))
                    }
                }
                }
                self.storageProductBySearch.append(productDetail)
            }
            completion(totale)
        }
    }
    
    func downloadJSONfromScan(_ url : String, completion: @escaping (Bool) -> Void) {
        request(url, method: .get).responseJSON { response in
            
            if let er = response.result.error {
                print("ERRORE:")
                print(er.localizedDescription)
            }
            
            guard let ilJson = response.result.value else {
                return
            }
            
            if let jsonProduct = JSON(ilJson)["product"].dictionary { 
            if let productName = jsonProduct["product_name"]?.string {
                self.productDetail.productName = productName
            }
            
            if let productBrand = jsonProduct["brands"]?.string {
                self.productDetail.brand = productBrand
            }
            
            if let productQuantity = jsonProduct["quantity"]?.string {
                self.productDetail.quantity = productQuantity
            }
            
            if let productImage = jsonProduct["image_url"]?.string {
                self.productDetail.image = productImage
            }
            
            if let jsonNutriments = jsonProduct["nutriments"]?.dictionary {
               
                if let productCarbohydrates = jsonNutriments["carbohydrates_value"]?.string {
                    self.productDetail.carbohydrates = productCarbohydrates
                }
                
                if let productFat = jsonNutriments["fat_value"]?.string {
                    self.productDetail.fatValue = productFat
                }
                
                if let productProtein = jsonNutriments["proteins_value"]?.string {
                    self.productDetail.proteinsValue = productProtein
                }
            }
            
            if let jsonIngredients = jsonProduct["ingredients_text"]?.string {
                self.productDetail.ingredientList = jsonIngredients
            }
   
            if let labelsHierarchy = jsonProduct["labels_hierarchy"]?.array {
             
                for label in labelsHierarchy {
                    let label = label.string
                    let column: Character = ":"
                    if let idx = label?.firstIndex(of: column)
                    {
                        let pos = label?.distance(from: label!.startIndex, to: idx)
                        let labelClean = label!.dropFirst(pos! + 1)
                        let replaced = String(labelClean.map {
                            $0 == "-" ? " " : $0
                        })
                        self.productDetail.labels.append(String(replaced))
                    }
                }
            }
            }
            
            let jsonProductExist = JSON(ilJson)["status"].boolValue
            
            completion(jsonProductExist)
        }
        
    }
}

