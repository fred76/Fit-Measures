//
//  SupplementController.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 03/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import UserNotifications
class UserSupplementListAndScan: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UISearchBarDelegate {
    
    @IBOutlet var placeholderView: UIView!
    
    @IBOutlet var placeholderImage: UIImageView!
    @IBOutlet var myProductCollectionView: UITableView!
    @IBOutlet var searchProduct: UISearchBar!
    @IBOutlet var barCodeButton: UIButton!
    var scanner: ScannerHelper?
    var nutrimentDictionary : NSDictionary!
    var status : Bool = false
    fileprivate let supplementCellID = "CellSupplement"
    lazy var supplementFetchedResultsController: NSFetchedResultsController<Supplement> = {
        let fetchRequest: NSFetchRequest<Supplement> = Supplement.fetchRequest()
        let nameSort = NSSortDescriptor(key: #keyPath(Supplement.productName), ascending: true)
        
        fetchRequest.sortDescriptors = [nameSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataManager.shared.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myProductCollectionView.delegate = self
        myProductCollectionView.dataSource = self
        searchProduct.delegate = self
        do {
            try supplementFetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        let textFieldInsideSearchBar = searchProduct.value(forKey: "searchField") as? UITextField
        
        textFieldInsideSearchBar?.textColor = .white
     }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        if let s = self.scanner {
            s.previewAdded.removeFromSuperlayer()
            s.button.removeFromSuperview()
            s.overlayView.removeFromSuperview()
        }
    }
    
    let factsImagesArray = [
        "1A",
        "2A",
        "3A",
        "4A",
        "5A"
    ]
    func randomFactImage() -> UIImage {
        let unsignedArrayCount = UInt32(factsImagesArray.count)
        let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        let randomNumber = Int(unsignedRandomNumber)
        return UIImage(named: factsImagesArray[randomNumber])!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let p = supplementFetchedResultsController.fetchedObjects
        if p?.count == 0{
            myProductCollectionView.backgroundView = placeholderView
            
            placeholderImage.image = randomFactImage()
        } else {
            myProductCollectionView.backgroundView = nil
        } 
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .black // colorLiteral(red: 0.9685102105, green: 0.9686148763, blue: 0.9725942016, alpha: 1)
        searchProduct.text = ""
        DownloadManager.shared.storageProductBySearch = []
    }
    
    @IBAction func code(_ sender: Any) {
//        handleCode(code: "000039681")
                        self.scanner = ScannerHelper(withViewController: self, view: self.view, codeOutputHandler: self.handleCode(code:))
                        if let scanner = self.scanner { scanner.requestCaptureSessioStartRunning() }
        
     
        
    }
    
  
    
 
 
    
    // MARK: - Search Bar
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
    
    // MARK: - Barcode Scan
    
    func scanAndSegue(code:String) {
        let url = "https://world.openfoodfacts.org/api/v0/product/[\(code)].json"
        DownloadManager.shared.downloadJSONfromScan(url, completion: { (isExist) in
            DispatchQueue.main.async {
                if isExist {
                    if let s = self.scanner {
                        s.previewAdded.removeFromSuperlayer()
                    }
                    
                    self.performSegue(withIdentifier: "ProductDetailsFromScan", sender: self)
                }
                else {
                    self.performSegue(withIdentifier: "ProductInsertManually", sender: self) 
                }
                
            }
        })
    }
    
    func handleCode(code:String) {
        
        scanAndSegue(code: code)
        
    }
    
    // MARK: - Search
    
    func searchAndSegue(code:String) {
        
        let replaced = code.replacingOccurrences(of: " ", with: "+")
        let url = "https://world.openfoodfacts.org/cgi/search.pl?search_terms=\(replaced)&search_simple=1&action=process&json=1" 
        DownloadManager.shared.downloadJSONfromSearch(url) { (count) in
            DispatchQueue.main.async {
                if count > 0 {
                    self.performSegue(withIdentifier: "ProductList", sender: self)
                } else {
                    self.performSegue(withIdentifier: "ProductInsertManually", sender: self)
                }
            }
        }
    }
    
    func searchHandleCode(code:String) {
        searchAndSegue(code: code)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductList" {
            if let destinationVC = segue.destination as? SupplementSearchedByName {
                destinationVC.searchText = searchProduct.text
            }
        }
        if segue.identifier == "ProductDetailsFromScan" {
            if let destinationVC = segue.destination as? SupplementDetailsController {
                 destinationVC.productSearched = DownloadManager.shared.productDetail
            }
        }
        if segue.identifier == "SupplementDetails" {
            
            if let destinationVC = segue.destination as? SupplementDetailsController { 
                if let indexPath = self.myProductCollectionView.indexPathForSelectedRow {
                    destinationVC.productAllreadySearched = supplementFetchedResultsController.object(at: indexPath)
                }
            }
        }
    }
}

extension UserSupplementListAndScan {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        self.scanner?.scannerHelperDelegate(output, didOutput: metadataObjects, from: connection)
    }
    
}



extension UserSupplementListAndScan : UITableViewDataSource, UITableViewDelegate {
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? SelectedProductCell else {
            return
        }
        let supplementDetail = supplementFetchedResultsController.object(at: indexPath)
        cell.productName.text = supplementDetail.productName
        cell.carbs.text = supplementDetail.carbohydrates
        cell.fat.text = supplementDetail.fatValue
        cell.pro.text = supplementDetail.proteinsValue
        if let image = supplementDetail.image {
           cell.imageProduct.image = UIImage(data: image as Data)
        } else {
            cell.imageProduct.image = UIImage(named: "cameraIcon")
        } 
        cell.dailyQuantity.text = supplementDetail.dailyDose
        cell.endScortDate.text = StaticClass.dateFormat(d: supplementDetail.dateWhenSupplementWillEnd!)
        cell.weekAnDays.text = supplementDetail.daysAnWeek
        if supplementDetail.carbohydrates!.isEmpty {
            supplementDetail.carbohydrates = "0"
        }
        if supplementDetail.fatValue!.isEmpty {
            supplementDetail.fatValue = "0"
        }
        if supplementDetail.proteinsValue!.isEmpty {
            supplementDetail.proteinsValue = "0"
        }
        cell.circleView.value = [supplementDetail.carbohydrates!.CGFloatValue(),supplementDetail.fatValue!.CGFloatValue(),supplementDetail.proteinsValue!.CGFloatValue()] as! [CGFloat]
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = supplementFetchedResultsController.sections else {
            return 0 }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = supplementFetchedResultsController.sections?[section] else {
            return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: supplementCellID, for: indexPath) as! SelectedProductCell
        
        configure(cell: cell, for: indexPath)
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let supplementDeleted = supplementFetchedResultsController.object(at: indexPath)
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [supplementDeleted.uniqueIdentifier!])
            DataManager.shared.managedContext.delete(supplementDeleted)
            if DataManager.shared.managedContext.hasChanges {
                DataManager.shared.save()
            }
        }
    }
    
    
  
    
    
}
// MARK: - NSFetchedResultsControllerDelegate
extension UserSupplementListAndScan: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myProductCollectionView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .update:
            let cell = myProductCollectionView.cellForRow(at: indexPath!) as! SelectedProductCell
            configure(cell: cell, for: indexPath!)
        case .insert:
            myProductCollectionView.insertRows(at: [newIndexPath!], with: .fade)
        case .move:
            myProductCollectionView.deleteRows(at: [indexPath!], with: .fade)
            myProductCollectionView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            myProductCollectionView.deleteRows(at: [indexPath!], with: .fade)
        @unknown default: print("Error")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myProductCollectionView.endUpdates()
    }
    
    
}

