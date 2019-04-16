//
//  DataManagerPhotos.swift
//  iFit Girths & Caliper
//
//  Created by Alberto Lunardini on 02/04/2019.
//  Copyright © 2019 Alberto Lunardini. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import PhotosUI
extension DataManager {
    
    func deletPic(t: PicFullRes){
        managedContext.delete(t)
        save()
    }
    
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        default:
            break
        }
    }
    
    func saveImage(imageData:NSData, thumbnailData:NSData, date: Double) {
        saveQueue.sync {
            // create new objects in moc
            guard let moc = self.managedContext else {
                return
            }
            guard let fullRes = NSEntityDescription.insertNewObject(forEntityName: "PicFullRes", into: moc) as? PicFullRes, let thumbnail = NSEntityDescription.insertNewObject(forEntityName: "Thumbnail", into: moc) as? Thumbnail else {
                // handle failed new object in moc
                print("moc error")
                return
            }
            //set image data of fullres
            fullRes.imageData = imageData
            fullRes.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
            //set image data of thumbnail
            thumbnail.imageData = thumbnailData
            thumbnail.id = date
            thumbnail.fullRes = fullRes
            thumbnail.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) + "thumbnail" as NSString
            
            // save the new objects
            do {
                try moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            // clear the moc
            moc.refreshAllObjects()
        }
    }
    
    func prepareImageForSaving(image:UIImage, closure: @escaping ()->()) {
        
        // use date as unique id
        let date : Double = NSDate().timeIntervalSince1970
        
        // dispatch with gcd.
        convertQueue.async {
            // create NSData from UIImage
            guard let imageData = image.jpegData(compressionQuality: 1) else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // scale image, I chose the size of the VC because it is easy
            let thumbnaill = image
            guard let thumbnailData  = thumbnaill.jpegData(compressionQuality: 0.7)  else {
                // handle failed conversion
                print("jpg error")
                return
            }
            
            // send to save function
            self.saveImage(imageData: imageData as NSData, thumbnailData: thumbnailData as NSData, date: date)
            
        }
        closure()
    }
    
    func assignUniqueIdentifierToPicFullRes() {
        
        let fetch = NSFetchRequest<PicFullRes>(entityName: "PicFullRes")
        do {
            
            let results = try managedContext.fetch(fetch)
            for m in results {
                if m.uniqueIdentifier?.length == 0 {
                    m.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
                }
            }
            save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func assignUniqueIdentifierToThumb() {
        let fetch = NSFetchRequest<Thumbnail>(entityName: "Thumbnail")
        do {
            
            let results = try managedContext.fetch(fetch)
            for m in results {
                if m.uniqueIdentifier?.length == 0 {
                    m.uniqueIdentifier = uuid + StaticClass.dateFormatterLongLong.string(from: now) as NSString
                }
            }
            save()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
}
