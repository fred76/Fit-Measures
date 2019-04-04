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
extension DataManager {
    func deletPic(t: PicFullRes){
        managedContext.delete(t)
        save()
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
}
