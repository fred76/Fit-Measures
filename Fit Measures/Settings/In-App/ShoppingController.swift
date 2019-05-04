//
//  ShoppingController.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 19/03/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit
import StoreKit

class ShoppingController: UITableViewController {
    
    let showDetailSegueIdentifier = "showDetail"
    @IBOutlet var buttonView: UIView!
    
    var products: [SKProduct] = []
    
    
    var imageArray = ["Bundle_cric", "Girth_Circ","SkinFold_circ", "supple_circ"]
    
    var parentNavigationController : UINavigationController?
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if identifier == showDetailSegueIdentifier {
//            guard let indexPath = tableView.indexPathForSelectedRow else {
//                return false
//            }
//            
//            let product = products[indexPath.row]
//            
//            return GandCProducts.store.isProductPurchased(product.productIdentifier)
//        }
//        
//        return true
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == showDetailSegueIdentifier {
//            guard let indexPath = tableView.indexPathForSelectedRow else { return }
//            
//            let product = products[indexPath.row]
//            
//            if let name = resourceNameForProductIdentifier(product.productIdentifier),
//                let detailViewController = segue.destination as? DetailViewController {
//                let image = UIImage(named: name)
//                detailViewController.image = image
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping"
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(ShoppingController.reload), for: .valueChanged)
        reload()
        buttonView.layer.cornerRadius = 6
        buttonView.layer.borderWidth = 2
        buttonView.layer.borderColor = UIColor.white.cgColor
        
        buttonView.backgroundColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(ShoppingController.handlePurchaseNotification(_:)),
                                               name: .IAPHelperPurchaseNotification,
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    @objc func reload() {
        products = [] 
        tableView.reloadData()
        
        IAPHelper.shared.requestProducts{ [weak self] success, products in
            guard let self = self else { return }
            if success {
                self.products = products! 
                self.tableView.reloadData()
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func restorePurchase(_ sender: Any) {
        IAPHelper.shared.restorePurchases()
    }
    
    
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        guard
            let productID = notification.object as? String,
            let index = products.firstIndex(where: { product -> Bool in
                product.productIdentifier == productID
            })
            else { return }
        
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}

// MARK: - UITableViewDataSource

extension ShoppingController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("products.count \(products.count)")
        return products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellProduct", for: indexPath) as! ProductCell
        
        let product = products[indexPath.row]
        
        cell.product = product
        cell.imageProduct.image = UIImage(named: imageArray[indexPath.row])
        cell.buyButtonHandler = { product in
            IAPHelper.shared.buyProduct(product)
        }
        
        return cell
    }
}
