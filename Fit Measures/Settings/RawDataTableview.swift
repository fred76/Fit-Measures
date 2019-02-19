//
//  RawDataTableview.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 10/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import CoreData

class RawDataTableview: UIViewController, UITableViewDelegate, UITableViewDataSource {
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
        cell.dateLabel.text = StaticClass.dateFormat(d: (measreData.dateOfEntry)!)
        
       
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
            let raw = segue.destination as! MeasureRowValueDetails
            if let indexPath = self.rawMeasureTabe.indexPathForSelectedRow {
         raw.measure = measureFetchedResultsController.object(at: indexPath)
            }
        }
    }
    
    
}
// MARK: - NSFetchedResultsControllerDelegate
extension RawDataTableview: NSFetchedResultsControllerDelegate {
    
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
        }
    }
    
     func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        rawMeasureTabe.endUpdates()
    }
    
 
}


import UIKit
import CoreData

class RawDataTableviewPliche: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var plicheTableView: UITableView!
    @IBOutlet var backView: UIView!
    fileprivate let rawDataId = "RawDataIdPliche"
    lazy var measureFetchedResultsController: NSFetchedResultsController<PlicheMeasure> = {
        let fetchRequest: NSFetchRequest<PlicheMeasure> = PlicheMeasure.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(PlicheMeasure.dateOfEntry), ascending: true)
        
        fetchRequest.sortDescriptors = [dateSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataManager.shared.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plicheTableView.delegate = self
        plicheTableView.dataSource = self
        let plicheMeasureIsAdded = DataManager.shared.plicheMeasurementExist()
        if !plicheMeasureIsAdded{
            plicheTableView.backgroundView = backView
            
        }
        do {
            try measureFetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        self.plicheTableView.rowHeight = 44
    }
    
    func configure(cell: UITableViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? RawDataCellPliche else {
            return
        }
        plicheTableView.backgroundView = nil
        let measreData = measureFetchedResultsController.object(at: indexPath)
           cell.titleLabel.text = measreData.method
 
         cell.dateLabel.text = StaticClass.dateFormat(d: (measreData.dateOfEntry)!)
        
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: rawDataId, for: indexPath) as! RawDataCellPliche
        
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
        
        
        if segue.identifier == "PlicheRawDetails" {
            let raw = segue.destination as! PlicheRawValuDetails
            if let indexPath = self.plicheTableView.indexPathForSelectedRow {
                raw.measure = measureFetchedResultsController.object(at: indexPath)
            }
        }
    }
}
// MARK: - NSFetchedResultsControllerDelegate
extension RawDataTableviewPliche: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        plicheTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .update:
            let cell = plicheTableView.cellForRow(at: indexPath!) as! RawDataCellPliche
            configure(cell: cell, for: indexPath!)
        case .insert:
            plicheTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .move:
            plicheTableView.deleteRows(at: [indexPath!], with: .fade)
            plicheTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            plicheTableView.deleteRows(at: [indexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        plicheTableView.endUpdates()
    }
    
    
}
