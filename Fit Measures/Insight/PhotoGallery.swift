//
//  CameraMainController.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 25/11/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import PhotosUI
class PhotoGallery: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HideTabBarDelegate {
    func hide() {
        picturesCollection.reloadData()
    } 
    @IBOutlet var takeButton: UIButton!
    @IBOutlet var BackImage: UIView!
    @IBOutlet var cameraInstruction: UITextView!
    var textString : String!
    var blockOperations: [BlockOperation] = []
    var shouldReloadCollectionView : Bool! = true
    fileprivate let rawDataId = "PicturesCell"
    @IBOutlet weak var picturesCollection: UICollectionView!
    @IBOutlet weak var cameraButton: UIButton!
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraInstruction.setContentOffset(CGPoint.zero, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.shared.checkPermission()
        picturesCollection.delegate = self
        picturesCollection.dataSource = self
        do {
            try picturesFetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        textString = "CameraUse"
        if let lang = Bundle.main.preferredLocalizations.first {
            if lang == "en" { textString = "CameraUse" }
            if lang == "it" { textString = "CameraUse_it"  }
        }
        let textURL = Bundle.main.url(forResource: textString, withExtension: "rtf")
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.rtf]
        let attribText = try! NSAttributedString(url: textURL!, options: options, documentAttributes: nil)
        cameraInstruction.attributedText = attribText
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isToolbarHidden = true
        let p = picturesFetchedResultsController.fetchedObjects
        if p?.count == 0{
            picturesCollection.backgroundView = BackImage
        } else {
            picturesCollection.backgroundView = nil
        }
        takeButton.layer.cornerRadius = 25
        takeButton.layer.borderColor = UIColor.white.cgColor
        takeButton.layer.borderWidth = 1
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    lazy var picturesFetchedResultsController: NSFetchedResultsController<Thumbnail> = {
        let fetchRequest: NSFetchRequest<Thumbnail> = Thumbnail.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(Thumbnail.id), ascending: true)
        
        fetchRequest.sortDescriptors = [dateSort]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataManager.shared.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    var imagePicker = UIImagePickerController()
    
    
    
    @IBAction func openCamera(_ sender: UIButton) {
        
         openGallary()
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func configure(cell: UICollectionViewCell, for indexPath: IndexPath) {
        
        guard let cell = cell as? PicturesCell else {
            return
        }
        let measreData = picturesFetchedResultsController.object(at: indexPath)
        if let thumbnailData = measreData.imageData {
            let image = UIImage(data: thumbnailData as Data)
            cell.userPictures.image  = image
            let date = measreData.id
            let d = Date.init(timeIntervalSince1970: date)
            let stringDate = StaticClass.dateFormat(d: d as NSDate)
            cell.dateLabel.text = stringDate
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = (collectionView.bounds.width/2.0)-10
        
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionInfo = picturesFetchedResultsController.sections?[section] else {
            return 0 }
        return sectionInfo.numberOfObjects
        
    }
    var selectedIndexes = [NSIndexPath]() {
        didSet {
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = picturesCollection.dequeueReusableCell(withReuseIdentifier: "PicturesCell", for: indexPath) as! PicturesCell
        configure(cell: cell, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? PicturesCell,
            let indexPath = self.picturesCollection.indexPath(for: cell) {
            if segue.identifier == "ShowPic" {
                let controller = segue.destination as! PicFullResController
                controller.delegate = self
                
                let measreData2 = picturesFetchedResultsController.object(at: indexPath)
                if let thumbnailData = measreData2.fullRes {
                    if let t = thumbnailData.imageData{
                        let image = UIImage(data: t as Data)
                        controller.image = image
                        
                        controller.thumb = thumbnailData
                        
                    }
                }
            }
            
        }
    }
}

extension PhotoGallery: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {}
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == NSFetchedResultsChangeType.insert {
            if (picturesCollection?.numberOfSections)! > 0 {
                if picturesCollection?.numberOfItems( inSection: newIndexPath!.section ) == 0 {
                    self.shouldReloadCollectionView = true
                } else {
                    blockOperations.append(
                        BlockOperation(block: { [weak self] in
                            if let this = self {
                                DispatchQueue.main.async {
                                    this.picturesCollection!.insertItems(at: [newIndexPath!])
                                }
                            }
                        })
                    )
                }
                
            } else {
                self.shouldReloadCollectionView = true
            }
        }
        else if type == NSFetchedResultsChangeType.update {
            
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            
                            this.picturesCollection!.reloadItems(at: [indexPath!])
                        }
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.move {
            
            
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            
                            this.picturesCollection!.moveItem(at: indexPath!, to: newIndexPath!)
                        }
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.delete {
            
            if picturesCollection?.numberOfItems( inSection: indexPath!.section ) == 1 {
                
                self.shouldReloadCollectionView = true
            } else {
                blockOperations.append(
                    BlockOperation(block: { [weak self] in
                        if let this = self {
                            DispatchQueue.main.async {
                                
                                this.picturesCollection!.deleteItems(at: [indexPath!])
                            }
                        }
                    })
                )
            }
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        if type == NSFetchedResultsChangeType.insert {
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            this.picturesCollection!.insertSections(NSIndexSet(index: sectionIndex) as IndexSet)
                        }
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.update {
            
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            this.picturesCollection!.reloadSections(NSIndexSet(index: sectionIndex) as IndexSet)
                        }
                    }
                })
            )
        }
        else if type == NSFetchedResultsChangeType.delete {
            
            blockOperations.append(
                BlockOperation(block: { [weak self] in
                    if let this = self {
                        DispatchQueue.main.async {
                            this.picturesCollection!.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet)
                        }
                    }
                })
            )
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        // Checks if we should reload the collection view to fix a bug @ http://openradar.appspot.com/12954582
        if (self.shouldReloadCollectionView == true) {
            DispatchQueue.main.async {
                self.picturesCollection.reloadData();
            }
        } else {
            DispatchQueue.main.async {
                self.picturesCollection!.performBatchUpdates({ () -> Void in
                    for operation: BlockOperation in self.blockOperations {
                        operation.start()
                    }
                }, completion: { (finished) -> Void in
                    self.blockOperations.removeAll(keepingCapacity: false)
                })
            }
        }
    }
}

//MARK: - UIImagePickerControllerDelegate

extension PhotoGallery:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        DataManager.shared.prepareImageForSaving(image: selectedImage) {
            self.picturesCollection.reloadData()
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { 
                    picker.isNavigationBarHidden = false
                    self.dismiss(animated: true, completion: nil)
                }
    
}
