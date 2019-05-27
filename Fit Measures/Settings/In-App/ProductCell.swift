//
//  ProductCell.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 19/03/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit
import StoreKit

class ProductCell: UITableViewCell {
    
    @IBOutlet var buttonView: UIView!
    @IBOutlet var imageProduct: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var priceLabel: UILabel!
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        
        return formatter
    }()
    
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            buttonView.layer.borderColor = UIColor.white.cgColor
            buttonView.layer.borderWidth = 2
            buttonView.layer.cornerRadius = 6
            nameLabel.text = product.localizedTitle
            descriptionLabel.text = product.localizedDescription
            print("product.localizedTitle \(product.localizedTitle)")
            print("product.localizedDescription \(product.localizedDescription)")
            if IAPHelper.shared.isProductPurchased(product.productIdentifier) {
                buttonView.addSubview(checkMark())
                priceLabel.text = ""
            } else if IAPHelper.canMakePayments() {
                ProductCell.priceFormatter.locale = product.priceLocale
                priceLabel.text = ProductCell.priceFormatter.string(from: product.price)
                buttonView.addSubview(newBuyButton())
                
            } else {
                priceLabel.text = "Not available"
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews() 
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        descriptionLabel.text = ""
        priceLabel.text = ""
        
    }
    
    var buyButtonHandler: ((_ product: SKProduct) -> Void)?
    
    func checkMark() -> UIImageView {
        let v = UIImageView()
        
        v.frame = CGRect(x: 25, y: 15, width: self.buttonView.bounds.size.width-50, height: self.buttonView.bounds.size.height-30)
        
        
        v.image = UIImage(named: "Check")
        v.contentMode = .scaleAspectFit
        
        return v
    }
    
    func newBuyButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(tintColor, for: .normal)
        button.setTitle("Buy now", for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: self.buttonView.bounds.size.width, height: self.buttonView.bounds.size.height)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 6
        
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(ProductCell.buyButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func buyButtonTapped(_ sender: AnyObject) {
        buyButtonHandler?(product!)
    }
}

