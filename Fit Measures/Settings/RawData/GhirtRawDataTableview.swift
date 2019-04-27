//
//  RawDataTableview.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 10/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import CoreData

class GhirtRawDataTableview: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var rawMeasureTabe: UITableView!
    fileprivate let rawDataId = "RawDataId"
    lazy var measureFetchedResultsController: NSFetchedResultsController<BodyMeasure> = {
        let fetchRequest: NSFetchRequest<BodyMeasure> = BodyMeasure.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(BodyMeasure.dateOfEntry), ascending: true)
       
        fetchRequest.sortDescriptors = [dateSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataManager.shared.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    @IBOutlet var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rawMeasureTabe.delegate=self
        rawMeasureTabe.dataSource=self
        
        let bodyMeasurementIsAdded = DataManager.shared.bodyMeasurementExist()
        if !bodyMeasurementIsAdded {
         rawMeasureTabe.backgroundView = backView
            
        }

        do {
            try measureFetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        self.rawMeasureTabe.rowHeight = 44
    }
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? RawDataCell else {
            return
        }
        rawMeasureTabe.backgroundView = nil
        let measreData = measureFetchedResultsController.object(at: indexPath)
        cell.titleLabel.text = "Measure"
        if let data = measreData.dateOfEntry {
            cell.dateLabel.text = StaticClass.dateFormat(d: data)
        } 
        
       
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = measureFetchedResultsController.sections else {
            return 0 }
        return sections.count
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = measureFetchedResultsController.sections?[section] else {
            return 0 }
        return sectionInfo.numberOfObjects
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: rawDataId, for: indexPath) as! RawDataCell
        
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

            DataManager.shared.managedContext.delete(measureFetchedResultsController.object(at: indexPath))
            if DataManager.shared.managedContext.hasChanges {
                DataManager.shared.save()
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "MeasureRawDetails" {
            let raw = segue.destination as! GirthsRowValueDetails
            if let indexPath = self.rawMeasureTabe.indexPathForSelectedRow {
         raw.measure = measureFetchedResultsController.object(at: indexPath)
            }
        }
    }
    
    
}
// MARK: - NSFetchedResultsControllerDelegate
extension GhirtRawDataTableview: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        rawMeasureTabe.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .update:
            let cell = rawMeasureTabe.cellForRow(at: indexPath!) as! RawDataCell
            configure(cell: cell, for: indexPath!)
        case .insert:
            rawMeasureTabe.insertRows(at: [newIndexPath!], with: .fade)
        case .move:
            rawMeasureTabe.deleteRows(at: [indexPath!], with: .fade)
            rawMeasureTabe.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            rawMeasureTabe.deleteRows(at: [indexPath!], with: .fade)
        @unknown default: print("Error")
        }
    }
    
     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        rawMeasureTabe.endUpdates()
    }
    
 
}

