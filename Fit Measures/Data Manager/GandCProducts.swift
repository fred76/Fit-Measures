//
//  GandCProducts.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 19/03/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import Foundation

public struct GandCProducts {
    
    public static let girthShopping = "fred76.com.ifit.girths"
    public static let skinFoldsShopping = "fred76.com.ifit.skinFolds"
    public static let bundleShopping2 = "fred76.com.ifit.bundle"
    private static let productIdentifiers: Set<ProductIdentifier> = [GandCProducts.girthShopping,GandCProducts.skinFoldsShopping,GandCProducts.bundleShopping2]
    
    public static let store = IAPHelper(productIds: GandCProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
