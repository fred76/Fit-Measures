//
//  PicFullResController.swift
//  Fit Measures
//
//  Created by Alberto Lunardini on 14/12/2018.
//  Copyright © 2018 Alberto Lunardini. All rights reserved.
//

import UIKit
protocol HideTabBarDelegate {
    func hide()
}
class PicFullResController: UIViewController { 
    var delegate : HideTabBarDelegate! = nil
    @IBOutlet var picFullRess: UIImageView!
    var image : UIImage!
    var thumb : PicFullRes!
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.navigationController?.toolbar.isHidden = false navigationController?.setToolbarHidden(false, animated: true)
        delegate.hide()
        picFullRess.image = image
        hidesBottomBarWhenPushed = true
        
      
            self.navigationController?.isToolbarHidden = false
        
        var items = [UIBarButtonItem]()
        
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePic)) )
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePic)) )
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        self.toolbarItems = items
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @objc func deletePic (){
        
        DataManager.shared.deletPic(t: thumb)
        
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true) {
            self.delegate.hide()
        }
    }
    @objc func sharePic (){
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.excludedActivityTypes = [
//            UIActivity.ActivityType.assignToContact,
//            UIActivity.ActivityType.saveToCameraRoll,
//            UIActivity.ActivityType.postToFlickr,
//            UIActivity.ActivityType.postToVimeo,
//            UIActivity.ActivityType.postToTencentWeibo,
//            UIActivity.ActivityType.postToTwitter,
//            UIActivity.ActivityType.openInIBooks,
//            UIActivity.ActivityType.postToFacebook,
//            UIActivity.ActivityType.airDrop,
//            UIActivity.ActivityType.mail
        ]
        present(vc, animated: true, completion: nil)
    }
    func share(sharingImage: UIImage?) {
        let sharingItems:[AnyObject?] = [
            sharingImage as AnyObject
        ]
        let activityViewController = UIActivityViewController(activityItems: sharingItems.compactMap({$0}), applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.popoverPresentationController?.sourceView = view
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    override var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.topViewController == self
        }
        set {
            super.hidesBottomBarWhenPushed = newValue
        }
    }
    
    
   
}


