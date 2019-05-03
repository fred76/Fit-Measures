//
//  IAPHelper.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 19/03/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import StoreKit
public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void 
extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("IAPHelperPurchaseNotification")
}

open class IAPHelper: NSObject  {
    private var productIdentifiers: Set<ProductIdentifier>!
    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    static let shared = IAPHelper()
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        print("INIT")
    }
    func getProductes(productIds: Set<ProductIdentifier>) {
        print("HHHHHHH")
        productIdentifiers = productIds
        for productIdentifier in productIds {
            let purchased = UserDefaults.standard.bool(forKey: productIdentifier)
            
            print("productIdentifier \(productIdentifier)")
            print("purchased \(purchased)")
            if purchased {
                purchasedProductIdentifiers.insert(productIdentifier)
                print("Previously purchased: \(productIdentifier)")
            } else {
                print("Not purchased: \(productIdentifier)")
            }
        } 
    }
    
    
}

// MARK: - StoreKit API

extension IAPHelper {
    
    public func requestProducts(completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    public func buyProduct(_ product: SKProduct) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()  }
    
    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
extension IAPHelper: SKProductsRequestDelegate {
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }
    
    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}
extension IAPHelper: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default: print("Error")
                
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        
        return true
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        print("complete...")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
        
        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }
        
        if identifier == "fred76.com.ifit.bundle" {
            print("ENTRO")
            
            print("AAAAAA \(UserDefaults.standard.bool(forKey: "fred76.com.ifit.bundle"))")
           purchasedProductIdentifiers.insert("fred76.com.ifit.girths")
           purchasedProductIdentifiers.insert("fred76.com.ifit.skinFolds")
            purchasedProductIdentifiers.insert("fred76.com.ifit.supplement")
            UserDefaults.standard.set(true, forKey: "fred76.com.ifit.bundle")
            UserDefaults.standard.set(true, forKey: "fred76.com.ifit.girths")
            UserDefaults.standard.set(true, forKey: "fred76.com.ifit.skinFolds")
            UserDefaults.standard.set(true, forKey: "fred76.com.ifit.supplement")
            NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: "fred76.com.ifit.bundle")
            NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: "fred76.com.ifit.girths")
            NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: "fred76.com.ifit.skinFolds")
            NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: "fred76.com.ifit.supplement")
        }
        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
    
   
}
