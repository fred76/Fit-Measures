//
//  ProductListSearchedByName.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 04/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit

class SupplementSearchedByName: UITableViewController {

    var incrementSearch : Int = 1
    var searchText : String!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9685102105, green: 0.9686148763, blue: 0.9725942016, alpha: 1)
    }
    override func viewDidDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            DownloadManager.shared.storageProductBySearch = []
        }
        
    }
    
    // MARK: - Table view data source
 
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
        return DownloadManager.shared.storageProductBySearch.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 
    }
    
    @IBAction func more(_ sender: Any) {
        searchMoreProduct(code: searchText)
    }
    
    func searchMoreProduct(code:String ) {
        incrementSearch += 1
        let nextPage = String(incrementSearch)
        let url = "https://world.openfoodfacts.org/cgi/search.pl?action=process&search_terms=\(code)&sort_by=unique_scans_n&page_size=20&page=\(nextPage)&json=1"
        DownloadManager.shared.downloadJSONfromSearch(url) { (count) in
            DispatchQueue.main.async {
                if self.incrementSearch > 0 { 
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSearched", for: indexPath) as! ProductCellForSearched
        cell.imageProduct.image = UIImage(named: "Camera")
        cell.imageProduct.layer.cornerRadius = 12
        let app = DownloadManager.shared.storageProductBySearch[indexPath.row]
        cell.productName.text = app.productName
        cell.brand.text = app.brand
        cell.quantity.text = app.quantity 
       
        cell.request = request(app.image, method: .get).responseData { rispostaServer in
            if rispostaServer.response != nil {
                if rispostaServer.request?.url?.absoluteString ==
                    cell.request?.request?.url?.absoluteString {
                    if let icona = rispostaServer.data {
                        cell.imageProduct.image = UIImage(data: icona)
                    }
                }
            } else { 
                print("errore")
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductDetailsFromSearch" {
            let supplementDetail = segue.destination as! SupplementDetailsController
            if let indexPath = tableView.indexPathForSelectedRow {
                supplementDetail.productSearched = DownloadManager.shared.storageProductBySearch[indexPath.row]
                if let cell = self.tableView.cellForRow(at: indexPath) as? ProductCellForSearched {
                   
                    supplementDetail.productImagePassed = cell.imageProduct.image
                }
                self.tableView.deselectRow(at: indexPath, animated:true)
            }
            
        }
    }
}
